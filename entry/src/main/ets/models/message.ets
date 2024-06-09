import { util } from '@kit.ArkTS'

import { UserInfo, UserInfoModel } from '.'
import { MessageTypeEnum } from '../constants'

/** 消息类型 */
export interface MessageType {
  /** 发送人 */
  sendUser: UserInfo
  /** 归属人 */
  connectUser: UserInfo
  /** 内容 */
  messageContent: string
  /** 类型 */
  messageType: MessageTypeEnum
  /** 资源文件地址 */
  sourceFilePath?: string
  /** 资源时长【单位：秒】 */
  sourceDuration?: number
  /** 发达时间 */
  sendTime?: number
  /** 主键 */
  id?: number | string
}

export class MessageTypeModel implements MessageType {
  sendUser: UserInfo = new UserInfoModel({} as UserInfo)
  connectUser: UserInfo = new UserInfoModel({} as UserInfo)
  messageContent: string = ''
  messageType: MessageTypeEnum = MessageTypeEnum.TEXT
  sourceFilePath: string = ''
  sourceDuration: number = 0
  sendTime: number = 0
  id: number | string = 0

  constructor(model: MessageType) {
    this.sendUser = model.sendUser
    this.connectUser = model.connectUser
    this.messageContent = model.messageContent
    this.messageType = model.messageType = MessageTypeEnum.TEXT
    this.sourceFilePath = model.sourceFilePath || ''
    this.sourceDuration = model.sourceDuration || 0
    this.sendTime = model.sendTime || Date.now()
    this.id = model.id || util.generateRandomUUID()
  }
}
