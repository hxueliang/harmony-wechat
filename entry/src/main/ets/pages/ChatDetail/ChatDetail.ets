import { router, window } from '@kit.ArkUI'
import { CURRENT_USER_KEY } from '../../constants'
import { UserInfo, UserInfoModel } from '../../models'

@Entry
@Component
struct ChatDetail {
  @StorageProp(CURRENT_USER_KEY)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo) // 我

  aboutToAppear(): void {
    this.setWindowBackgroundColor()
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
        Text('小趴趴')
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

      Text(JSON.stringify(this.currentUser))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
  }
}