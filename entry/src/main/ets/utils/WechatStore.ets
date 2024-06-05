import preferences from '@ohos.data.preferences'

import { connectList } from '../apis'
import { currentUser } from '../apis/connect'
import { CONNECT_LIST_KEY, CURRENT_USER_KEY, WECHAT_STORE_KEY } from '../constants'
import { UserInfo } from '../models'

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
}