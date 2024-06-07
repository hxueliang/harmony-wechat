import { router, window } from '@kit.ArkUI'

import { getApiMessage } from '../../apis'
import { CURRENT_USER_KEY } from '../../constants'
import { MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../models'
import { BottomInput, Message } from './components'

@Entry
@Component
struct ChatDetail {
  @StorageProp(CURRENT_USER_KEY)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo) // 我
  @Provide
  talkUser: UserInfoModel = new UserInfoModel({} as UserInfo) // 对方
  @State
  messageList: MessageTypeModel[] = []
  @State
  message: string = ''
  @State
  talkUserInputIng: boolean = false

  aboutToAppear(): void {
    this.setWindowBackgroundColor()
    this.getTalkUser()
  }

  getTalkUser() {
    this.talkUser = router.getParams() as UserInfoModel
  }

  sendTextMessage(content: string) {
    this.message = content
    this.messageList.push(new MessageTypeModel({
      sendUser: this.currentUser,
      connectUser: this.talkUser,
      messageContent: content,
    } as MessageType))

    setTimeout(() => {
      this.requestMessage(content)
    }, 1000)
  }

  async requestMessage(content: string) {
    this.talkUserInputIng = true
    try {
      const res = await getApiMessage(content)
      this.messageList.push(new MessageTypeModel({
        sendUser: this.talkUser,
        connectUser: this.talkUser,
        messageContent: res?.data?.info?.text
      } as MessageType))
    } catch (err) {
      console.log(JSON.parse(err))
    } finally {
      this.talkUserInputIng = false
    }
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
        Text(this.talkUserInputIng ? '对方正在输入...' : this.talkUser.userName)
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
        ForEach(this.messageList, (item: MessageTypeModel, index: number) => {
          ListItem() {
            Message({
              currentMessage: item,
            })
          }
          .padding({
            top: index === 0 ? 10 : 0,
            bottom: index === this.messageList.length - 1 ? 10 : 0,
          })
        })
      }
      .layoutWeight(1)

      BottomInput({
        sendTextMessage: (content: string) => {
          this.sendTextMessage(content)
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}