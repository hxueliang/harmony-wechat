import { CURRENT_USER_KEY } from '../../../constants'
import { MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../../models'

@Preview
@Component
struct Message {
  @StorageProp(CURRENT_USER_KEY)
  currentUser: UserInfo = new UserInfoModel({} as UserInfo)
  @Prop
  currentMessage: MessageType = new MessageTypeModel({} as MessageType)
  @State
  isOwnMessage: boolean = this.currentUser.userId === this.currentMessage?.sendUser?.userId

  build() {
    Row({ space: 10 }) {
      Image('https://img1.baidu.com/it/u=3995643348,1848098846&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=800')
        .width(40)
        .aspectRatio(1)
        .borderRadius(4)

      Row() {
        Text('可贺呆顺可顺可贺,呆顺可贺呆顺可贺呆,顺可贺呆贺呆顺可贺呆。')
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .fontSize(14)
          .lineHeight(20)
          .borderRadius(4)
          .fontColor($r('app.color.text_primary'))

          .backgroundColor(this.isOwnMessage ? $r('app.color.second_primary') : $r('app.color.white'))
      }
      .justifyContent(this.isOwnMessage ? FlexAlign.Start : FlexAlign.Start)
      .layoutWeight(1)

      Text().width(40)
    }
    .padding({ left: 20, right: 20 })
    .direction(this.isOwnMessage ? Direction.Rtl : Direction.Ltr)
  }
}

export default Message