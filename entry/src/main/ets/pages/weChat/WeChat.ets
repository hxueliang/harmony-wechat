import { router } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'

import { MessageTypeModel, PopupItem } from '../../models'
import { getTimeObj, WechatStore } from '../../utils'
import {
  MessageTypeNameList,
  ShowContent,
  ShowTypeName,
  ShowTypeNameAndContent,
  ShowTypeNameAndDuration,
  UPDATE_MESSAGE_RECORD_EVENT
} from '../../constants'

@Component
export struct WeChat {
  @State
  list: MessageTypeModel[] = []
  @State
  showDropDown: boolean = false
  popList: PopupItem[] = [
    {
      title: '发起群聊',
      icon: $r('app.media.ic_public_message')
    },
    {
      title: '添加朋友',
      icon: $r('app.media.ic_public_add_friend')
    },
    {
      title: '扫一扫',
      icon: $r('app.media.ic_public_scan')
    },
    {
      title: '收付款',
      icon: $r('app.media.ic_public_receive')
    }
  ]

  aboutToAppear(): void {
    this.getAllMessageRecord()
    this.transTime(Date.now())
  }

  async getAllMessageRecord() {
    this.list = await WechatStore.getAllMessageRecord()
    // 方式一，线程内通信
    // getContext().eventHub.on(UPDATE_MESSAGE_RECORD_EVENT, async () => {
    //   this.list = await WechatStore.getAllMessageRecord()
    // })
    // 方式二，进程内通信
    emitter.on(UPDATE_MESSAGE_RECORD_EVENT, async () => {
      this.list = await WechatStore.getAllMessageRecord()
    })
  }

  transTime(time: number) {
    const timeObj = getTimeObj(time)
    const nowObj = getTimeObj(new Date())

    // 不同年
    if (timeObj.year !== nowObj.year) {
      return `${timeObj.year}年`
    }

    // 同年
    // 同日
    if (
      timeObj.month === nowObj.month &&
        timeObj.date === nowObj.date
    ) {
      return timeObj.hours + ':' + timeObj.minutes
    }
    // 不同日
    return `${timeObj.month}月${timeObj.date}日`
  }

  @Builder
  delTalkUserAllMessageUI(item: MessageTypeModel) {
    Row() {
      Text('删除')
        .width(100)
        .height(60)
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.danger'))
        .fontColor($r('app.color.white'))
        .onClick(() => {
          // 删除首选项数据
          WechatStore.delAllMessageByUser(item.connectUser.userId)
          // 删除内存数据
          const index = this.list.findIndex(message => message.id === item.id)
          if (index > -1) {
            this.list.splice(index, 1)
          }
        })
    }
    .padding({
      left: 10
    })
  }

  @Builder
  getPopUI() {
    Column() {
      ForEach(this.popList, (item: PopupItem) => {
        Row({ space: 2 }) {
          Image(item.icon)
            .width(20)
            .aspectRatio(1)
            .fillColor($r('app.color.back_color'))
          Text(item.title)
            .fontColor($r('app.color.back_color'))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
        }
        .padding({ left: 10, right: 10 })
        .height(40)
        .onClick(() => {
          item.onClick && item.onClick()
        })
      })
    }
    .width(108)
  }

  build() {
    Column() {
      Row() {
        Text('微信')
          .width('100%')
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Center)
          .fontSize(16)
        Image($r('app.media.ic_public_add_norm'))
          .width(20)
          .aspectRatio(1)
          .fillColor($r('app.color.text_primary'))
          .translate({ x: -30 })
          .onClick(() => {
            this.showDropDown = !this.showDropDown
          })
          .bindPopup(this.showDropDown, {
            builder: this.getPopUI,
            backgroundBlurStyle: BlurStyle.NONE,
            popupColor: $r('app.color.popup_back'),
            onStateChange: (event) => {
              this.showDropDown = event.isVisible
            }
          })
      }
      .padding({
        left: 10,
        right: 10,
      })
      .height(50)
      .border({
        width: { bottom: 1 },
        color: $r('app.color.border_color')
      })

      List({ space: 20 }) {
        ForEach(this.list, (item: MessageTypeModel, index: number) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(item.connectUser.avatar)
                .width(50)
                .aspectRatio(1)
                .borderRadius(4)
              Column() {
                Text(item.connectUser.userName)
                  .fontColor($r('app.color.text_primary'))
                Text(
                  ShowContent.includes(item.messageType) ? item.messageContent :
                    ShowTypeName.includes(item.messageType) ? `[${MessageTypeNameList[item.messageType]}]` :
                      ShowTypeNameAndDuration.includes(item.messageType) ? `[${MessageTypeNameList[item.messageType]}] ${item.sourceDuration}"` :
                        ShowTypeNameAndContent.includes(item.messageType) ? `[${MessageTypeNameList[item.messageType]}]` + ` ${item.messageContent}` :
                          ''
                )
                  .fontSize(14)
                  .fontColor($r('app.color.text_second'))
                  .maxLines(1)
                  .textOverflow({
                    overflow: TextOverflow.Ellipsis
                  })
              }
              .layoutWeight(1)
              .height(50)
              .justifyContent(FlexAlign.SpaceEvenly)
              .alignItems(HorizontalAlign.Start)

              Text(this.transTime(item.sendTime as number))
                .width(60)
                .fontColor($r('app.color.text_second'))
                .textAlign(TextAlign.End)
            }
          }
          .padding({
            top: index === 0 ? 10 : 0,
            bottom: index === this.list.length - 1 ? 10 : 0,
          })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ChatDetail/ChatDetail',
              params: item.connectUser
            })
          })
          .swipeAction({
            end: () => {
              this.delTalkUserAllMessageUI(item)
            }
          })
        })
      }
      .divider({
        strokeWidth: 1,
        color: $r('app.color.back_color'),
      })
      .padding({
        left: 10,
        right: 10,
      })
      .layoutWeight(1)
    }
    .height('100%')
  }
}
