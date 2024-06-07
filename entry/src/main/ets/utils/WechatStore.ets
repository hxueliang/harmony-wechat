import preferences from '@ohos.data.preferences'

import { connectList } from '../apis'
import { currentUser } from '../apis/connect'
import { CONNECT_LIST_KEY, CURRENT_USER_KEY, TALK_USER_RECORD_KEY, WECHAT_STORE_KEY } from '../constants'
import { MessageTypeModel, UserInfo } from '../models'

export class WechatStore {
  static context: Context

  static getStore() {
    return preferences.getPreferences(WechatStore.context || getContext(), WECHAT_STORE_KEY)
  }

  static async setConnectList(list: UserInfo[]) {
    const store = await WechatStore.getStore()
    store.putSync(CONNECT_LIST_KEY, JSON.stringify(list))
  }

  static async getConnectList() {
    const store = await WechatStore.getStore()
    const listStr = store.getSync(CONNECT_LIST_KEY, JSON.stringify(connectList)) as string
    const list = JSON.parse(listStr) as UserInfo[]
    return list
  }

  static async getCurrentUser() {
    const store = await WechatStore.getStore()
    const userStr = store.getSync(CURRENT_USER_KEY, JSON.stringify(currentUser)) as string
    const user = JSON.parse(userStr) as UserInfo
    return user
  }

  /** 获取全部聊天记录(指定对话用户) */
  static async getAllMessageByUser(talkId: number) {
    const store = await WechatStore.getStore()
    const messageListStr = store.getSync(`${TALK_USER_RECORD_KEY}_${talkId}`, '[]') as string
    const messageList = JSON.parse(messageListStr) as MessageTypeModel[]
    return messageList
  }

  /** 删除全部聊天记录(指定对话用户) */
  static async delAllMessageByUser(talkId: UserInfo) {
    const store = await WechatStore.getStore()
    store.deleteSync(`${TALK_USER_RECORD_KEY}_${talkId}`)
    await store.flush()
  }

  /** 添加一条聊天记录(指定对话用户) */
  static async addOneMessageByUser(talkId: number, message: MessageTypeModel) {
    const store = await WechatStore.getStore()
    const messageList = await WechatStore.getAllMessageByUser(talkId)
    messageList.push(message)
    store.putSync(`${TALK_USER_RECORD_KEY}_${talkId}`, JSON.stringify(messageList))
    await store.flush()
  }

  /** 删除一条聊天记录(指定对话用户) */
  static async delOneMessageByUser(talkId: number, messageId: number | string) {
    const store = await WechatStore.getStore()
    const messageList = await WechatStore.getAllMessageByUser(talkId)
    const index = messageList.findIndex(item=> item.id == messageId)
    messageList.splice(index, 1)
    await store.flush()
  }
}