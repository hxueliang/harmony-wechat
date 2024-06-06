import { router, window } from '@kit.ArkUI'
import { CURRENT_USER_KEY } from '../../constants'
import { UserInfo, UserInfoModel } from '../../models'
import { BottomInput, Message } from './components'

@Entry
@Component
struct ChatDetail {
  @StorageProp(CURRENT_USER_KEY)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo) // 我
  @Provide
  talkUser: UserInfoModel = new UserInfoModel({} as UserInfo) // 对方
  messageList: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  aboutToAppear(): void {
    this.setWindowBackgroundColor()
    this.getTalkUser()
  }

  getTalkUser() {
    this.talkUser = router.getParams() as UserInfoModel
  }

  async setWindowBackgroundColor() {
    const win = await window.getLastWindow(getContext())
    win.setWindowBackgroundColor('#ededed')
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Image($r('app.media.ic_public_arrow_left'))
          .width(30)
          .aspectRatio(1)
          .zIndex(2)
          .onClick(() => {
            router.back()
          })
        Text(this.talkUser.userName)
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
        ForEach(this.messageList, (item: number, index: number) => {
          ListItem() {
            Message()
          }
          .padding({
            top: index === 0 ? 10 : 0,
            bottom: index === this.messageList.length - 1 ? 10 : 0,
          })
        })
      }
      .layoutWeight(1)

      BottomInput()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}