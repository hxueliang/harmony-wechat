import preferences from '@ohos.data.preferences'

import { connectList } from '../apis'
import { CONNECT_LIST_KEY, WECHAT_STORE_KEY } from '../constants'
import { UserInfo } from '../models'

export class WechatStore {
  static getStore() {
    return preferences.getPreferences(getContext(), WECHAT_STORE_KEY)
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
}