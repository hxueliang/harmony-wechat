import preferences from '@ohos.data.preferences'
import { emitter } from '@kit.BasicServicesKit'

import { currentUser } from '../apis/connect'
import {
  CONNECT_LIST_KEY,
  CURRENT_USER_KEY,
  TALK_USER_RECORD_KEY,
  UPDATE_MESSAGE_RECORD_EVENT,
  WECHAT_STORE_KEY
} from '../constants'
import { MessageTypeModel, UserInfo, UserInfoModel } from '../models'
import { FileCommon } from '.'

export class WechatStore {
  static context: Context

  static getStore() {
    return preferences.getPreferences(WechatStore.context || getContext(), WECHAT_STORE_KEY)
  }

  static async setConnectList(list: UserInfo[]) {
    const store = await WechatStore.getStore()
    store.putSync(CONNECT_LIST_KEY, JSON.stringify(list))
    await store.flush()
  }

  static async getConnectList() {
    const store = await WechatStore.getStore()
    const listStr = store.getSync(CONNECT_LIST_KEY, '[]') as string
    const list = JSON.parse(listStr) as UserInfo[]
    return list
  }

  static async getCurrentUser() {
    const store = await WechatStore.getStore()
    const userStr = store.getSync(CURRENT_USER_KEY, JSON.stringify(currentUser)) as string
    const user = JSON.parse(userStr) as UserInfo
    return user
  }

  /** 获取聊天记录仓库 */
  static getMessageRecordStore(talkId: number) {
    return preferences.getPreferences(getContext(), `${TALK_USER_RECORD_KEY}_${talkId}`)
  }

  /** 获取全部聊天记录(指定对话用户) */
  static async getAllMessageByUser(talkId: number) {
    const store = await WechatStore.getMessageRecordStore(talkId)
    const allRecord = store.getAllSync() as object
    if (allRecord) {
      const list = Object.values(allRecord).map((item: string) => JSON.parse(item) as MessageTypeModel)
      list.sort((a, b) => a.sendTime - b.sendTime)
      return list
    }
    return []
  }

  /** 删除全部聊天记录(指定对话用户) */
  static async delAllMessageByUser(talkId: number) {
    const messageList = await WechatStore.getAllMessageByUser(talkId)
    messageList.forEach(message => {
      message.sourceFilePath && FileCommon.deleteFile(message.sourceFilePath)
    })
    preferences.deletePreferences(getContext(), `${TALK_USER_RECORD_KEY}_${talkId}`)
  }

  /** 添加一条聊天记录(指定对话用户) */
  static async addOneMessageByUser(talkId: number, message: MessageTypeModel) {
    const store = await WechatStore.getMessageRecordStore(talkId)
    store.putSync(message.id + '', JSON.stringify(message))
    await store.flush()
    // 触发更新
    // 方式一，线程内通信
    // getContext().eventHub.emit(UPDATE_MESSAGE_RECORD_EVENT)
    // 方式二，进程内通信
    emitter.emit(UPDATE_MESSAGE_RECORD_EVENT)
  }

  /** 删除一条聊天记录(指定对话用户) */
  static async delOneMessageByUser(talkId: number, messageId: number | string) {
    const messageList = await WechatStore.getAllMessageByUser(talkId)
    let index = messageList.length - 1
    while (index >= 0) {
      const message = messageList[index--]
      if (message.id === messageId && message.sourceFilePath) {
        FileCommon.deleteFile(message.sourceFilePath)
        index = -1
      }
    }
    const store = await WechatStore.getMessageRecordStore(talkId)
    store.deleteSync(messageId + '')
    await store.flush()
    emitter.emit(UPDATE_MESSAGE_RECORD_EVENT)
  }

  /** 获取所有联系人的最后一条聊天记录 */
  static async getAllMessageRecord() {
    const connectList = await WechatStore.getConnectList()
    const list: MessageTypeModel[] = []
    for (let index = 0; index < connectList.length; index++) {
      const messageList = await WechatStore.getAllMessageByUser(connectList[index].userId)
      messageList?.length && list.push(messageList[messageList.length - 1])
    }
    list.sort((a, b) => b.sendTime - a.sendTime)
    return list
  }
}