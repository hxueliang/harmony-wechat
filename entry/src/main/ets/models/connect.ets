export interface UserInfo {
  /** 用户id */
  userId: number
  /** 用户名 */
  userName: string
  /** 头像 */
  avatar: string
}

export class UserInfoModel implements UserInfo {
  userId: number = 0
  userName: string = ''
  avatar: string = ''

  constructor(model: UserInfo) {
    this.userId = model.userId
    this.userName = model.userName
    this.avatar = model.avatar
  }
}
