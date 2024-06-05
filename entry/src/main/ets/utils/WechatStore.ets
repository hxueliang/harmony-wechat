import preferences from '@ohos.data.preferences'

import { connectList } from '../apis'
import { CONNECT_LIST_KEY, WECHAT_STORE_KEY } from '../constants'
import { UserInfo } from '../models'

export class WechatStore {
  static getStore(context?: Context) {
    return preferences.getPreferences(context || getContext(), WECHAT_STORE_KEY)
  }

  static async setConnectList(list: UserInfo[], context?: Context) {
    const store = await WechatStore.getStore(context)
    store.putSync(CONNECT_LIST_KEY, JSON.stringify(list))
  }

  static async getConnectList(context?: Context) {
    const store = await WechatStore.getStore(context)
    const listStr = store.getSync(CONNECT_LIST_KEY, JSON.stringify(connectList)) as string
    const list = JSON.parse(listStr) as UserInfo[]
    return list
  }
}