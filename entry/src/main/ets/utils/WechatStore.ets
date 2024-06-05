import preferences from '@ohos.data.preferences'

import { connectList } from '../apis'
import { Connect_List, Wechat_Store_Key } from '../constants'
import { ConnectItem } from '../models'

export class WechatStore {
  static getStore(context?: Context) {
    return preferences.getPreferences(context || getContext(), Wechat_Store_Key)
  }

  static async setConnectList(list: ConnectItem[], context?: Context) {
    const store = await WechatStore.getStore(context)
    store.putSync(Connect_List, JSON.stringify(list))
  }

  static async getConnectList(context?: Context) {
    const store = await WechatStore.getStore(context)
    const listStr = store.getSync(Connect_List, JSON.stringify(connectList)) as string
    const list = JSON.parse(listStr) as ConnectItem[]
    return list
  }
}