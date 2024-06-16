import { CURRENT_USER_KEY, MessageTypeEnum, ShowContent, ShowTypeNameAndDuration } from '../../../constants'
import { LongGesturePopupItem, MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../../models'
import { AudioRenderer } from '../../../utils'

@Extend(Text)
function getMessageTextStyles() {
  .fontSize(14)
  .lineHeight(20)
  .fontColor($r('app.color.text_primary'))
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
  audioState: AnimationStatus = AnimationStatus.Initial
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

  @Styles
  getMessageBoxStyles() {
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .borderRadius(4)
    .backgroundColor(this.isOwnMessage ? $r('app.color.chat_primary') : $r('app.color.white'))
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
    Row() {
      Text(this.currentMessage.messageContent)
        .getMessageTextStyles()
    }
    .getMessageBoxStyles()
  }

  @Builder
  getAudioMessageUI() {
    Row({ space: 5 }) {
      Text(`${this.currentMessage.sourceDuration}"`)
        .getMessageTextStyles()

      ImageAnimator()
        .images([
          {
            src: $r("app.media.ic_public_voice3")
          },
          {
            src: $r("app.media.ic_public_voice1")
          },
          {
            src: $r("app.media.ic_public_voice2")
          },
          {
            src: $r("app.media.ic_public_voice3")
          }
        ])
        .state(this.audioState)
        .iterations(-1)
        .width(18)
        .aspectRatio(1)
        .rotate({
          angle: this.isOwnMessage ? 180 : 0
        })
    }
    .getMessageBoxStyles()
    .width(this.getAudioMessageWidth())
    .justifyContent(FlexAlign.End)
    .direction(this.isOwnMessage ? Direction.Ltr : Direction.Rtl)
    .onClick(() => {
      AudioRenderer.start(this.currentMessage.sourceFilePath!, () => {
        this.audioState = AnimationStatus.Stopped
      }) // 播放
      this.audioState = AnimationStatus.Running
    })
  }

  @Builder
  getImageMessageUI() {
    Row() {
      Image('file://' + this.currentMessage.sourceFilePath)
        .borderRadius(4)
    }
    .width('60%')
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
          else if (this.messageType === MessageTypeEnum.IMAGE) {
            this.getImageMessageUI()
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
    .alignItems(VerticalAlign.Top)
    .padding({ left: 20, right: 20 })
    .direction(this.isOwnMessage ? Direction.Rtl : Direction.Ltr)
  }
}

export default Message