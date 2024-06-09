import { router } from '@kit.ArkUI'

import { MessageTypeModel } from '../../models'
import { getTimeObj, WechatStore } from '../../utils'

@Component
export struct WeChat {
  @State
  list: MessageTypeModel[] = []

  aboutToAppear(): void {
    this.getAllMessageRecord()
    this.transTime(Date.now())
  }

  async getAllMessageRecord() {
    this.list = await WechatStore.getAllMessageRecord()
  }

  transTime(time: number) {
    const timeObj = getTimeObj(time)
    const nowObj = getTimeObj(new Date())
    console.log('x_log', JSON.stringify(nowObj))

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

  build() {
    Column() {
      Row() {
        Text('微信')
          .width('100%')
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Center)
          .fontSize(16)
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
                Text(item.messageContent)
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
