import { CURRENT_USER_KEY } from '../../../constants'
import { MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../../models'

@Preview
@Component
struct Message {
  @StorageProp(CURRENT_USER_KEY)
  currentUser: UserInfo = new UserInfoModel({} as UserInfo)
  @Require
  @Prop
  currentMessage: MessageType = new MessageTypeModel({} as MessageType)
  @State
  isOwnMessage: boolean = this.currentUser.userId === this.currentMessage?.sendUser?.userId

  build() {
    Row({ space: 10 }) {
      Image(this.currentMessage.sendUser?.avatar)
        .width(40)
        .aspectRatio(1)
        .borderRadius(4)

      Row() {
        Text(this.currentMessage.messageContent)
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .fontSize(14)
          .lineHeight(20)
          .borderRadius(4)
          .fontColor($r('app.color.text_primary'))
          .backgroundColor(this.isOwnMessage ? $r('app.color.second_primary') : $r('app.color.white'))
      }
      .justifyContent(this.isOwnMessage ? FlexAlign.End : FlexAlign.Start)
      .layoutWeight(1)

      Text().width(40)
    }
    .padding({ left: 20, right: 20 })
    .direction(this.isOwnMessage ? Direction.Rtl : Direction.Ltr)
  }
}

export default Message