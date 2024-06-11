import { CURRENT_USER_KEY } from '../../../constants'
import { LongGesturePopupItem, MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../../models'

const longGesturePopupList: LongGesturePopupItem[] = [
  {
    title: '听筒播放',
    icon: $r("app.media.ic_public_ears"),
  },
  {
    title: '收藏',
    icon: $r("app.media.ic_public_cube"),
  },
  {
    title: '转文字',
    icon: $r("app.media.ic_public_trans_text"),
  },
  {
    title: '删除',
    icon: $r("app.media.ic_public_cancel"),
  },
  {
    title: '多选',
    icon: $r("app.media.ic_public_multi_select"),
  },
  {
    title: '引用',
    icon: $r("app.media.ic_public_link"),
  },
  {
    title: '提醒',
    icon: $r("app.media.ic_public_warin")
  }]

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
  @State
  showLongGesturePopup: boolean = false
  @State
  longGesturePopupList: LongGesturePopupItem[] = longGesturePopupList

  @Builder
  getPopupUI() {
    GridRow({ columns: 5 }) {
      ForEach(this.longGesturePopupList, (item: LongGesturePopupItem) => {
        GridCol() {
          Column({ space: 10 }) {
            Image(item.icon)
              .fillColor($r('app.color.white'))
              .width(18)
              .aspectRatio(1)
            Text(item.title)
              .fontColor($r('app.color.white'))
              .fontSize(14)
          }
          .height(70)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
      })
    }
    .padding({
      right: 10,
      left: 10,
      top: 5,
      bottom: 5,
    })
    .width(300)
  }

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
          .gesture(
            LongPressGesture()
              .onAction(() => {
                this.showLongGesturePopup = true
              })
          )
          .bindPopup(this.showLongGesturePopup, {
            builder: this.getPopupUI,
            popupColor: $r('app.color.popup_back'),
            backgroundBlurStyle: BlurStyle.NONE,
            onStateChange: ((event) => {
              this.showLongGesturePopup = event.isVisible
            })
          })
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