import { CURRENT_USER_KEY, MessageTypeEnum, ShowContent, ShowTypeNameAndDuration } from '../../../constants'
import { LongGesturePopupItem, MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../../models'
import { WechatStore } from '../../../utils'

@Extend(Text)
function getMessageTextStyles(color: ResourceStr) {
  .padding({ left: 12, right: 12, top: 10, bottom: 10 })
  .fontSize(14)
  .lineHeight(20)
  .borderRadius(4)
  .fontColor($r('app.color.text_primary'))
  .backgroundColor(color)
}

@Preview
@Component
struct Message {
  @StorageProp(CURRENT_USER_KEY)
  currentUser: UserInfo = new UserInfoModel({} as UserInfo)
  @Require
  @Prop
  currentMessage: MessageType = new MessageTypeModel({} as MessageType)
  @State
  messageType: MessageTypeEnum = this.currentMessage.messageType
  @State
  isOwnMessage: boolean = this.currentUser.userId === this.currentMessage?.sendUser?.userId
  @State
  showLongGesturePopup: boolean = false
  @State
  longGesturePopupList: LongGesturePopupItem[] = [
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
      onClick: () => this.delOneMessage()
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
  delOneMessage: () => void = () => {
  }

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
        .onClick(() => {
          item.onClick && item.onClick()
        })
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

  getAudioMessageWidth() {
    const minWidth = 30
    const maxWidth = 100
    const calcWidth = minWidth + (this.currentMessage.sourceDuration as number) / 60 * (maxWidth - minWidth)
    if (calcWidth < maxWidth) return calcWidth + '%'
    return maxWidth + '%'
  }

  @Builder
  getTextMessageUI() {
    Text(this.currentMessage.messageContent)
      .getMessageTextStyles(this.isOwnMessage ? $r('app.color.chat_primary') : $r('app.color.white'))
  }

  @Builder
  getAudioMessageUI() {
    Text() {
      Span(this.isOwnMessage ?
        `${this.currentMessage.sourceDuration}" ` :
        `"${this.currentMessage.sourceDuration} `
      )

      ImageSpan($r('app.media.ic_public_recorder'))
        .width(18)
        .aspectRatio(1)
        .rotate({
          angle: this.isOwnMessage ? 180 : 0
        })
    }
    .getMessageTextStyles(this.isOwnMessage ? $r('app.color.chat_primary') : $r('app.color.white'))
    .width(this.getAudioMessageWidth())
    .textAlign(TextAlign.End)
    .direction(this.isOwnMessage ? Direction.Ltr : Direction.Rtl)
  }

  build() {
    Row({ space: 10 }) {
      Image(this.currentMessage.sendUser?.avatar)
        .width(40)
        .aspectRatio(1)
        .borderRadius(4)

      Row() {
        Row() {
          if (ShowContent.includes(this.messageType)) {
            this.getTextMessageUI()
          }
          else if (ShowTypeNameAndDuration.includes(this.messageType)) {
            this.getAudioMessageUI()
          }
        }
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