export interface ConnectItem {
  /** 用户id */
  userId: number
  /** 用户名 */
  userName: string
  /** 头像 */
  avatar: string
}

export class ConnectItemModel implements ConnectItem {
  userId: number = 0
  userName: string = ''
  avatar: string = ''

  constructor(model: ConnectItem) {
    this.userId = model.userId
    this.userName = model.userName
    this.avatar = model.avatar
  }
}
