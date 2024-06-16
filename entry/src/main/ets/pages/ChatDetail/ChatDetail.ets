import { router, window } from '@kit.ArkUI'

import { getApiMessage } from '../../apis'
import { CURRENT_USER_KEY } from '../../constants'
import { MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../models'
import { AudioRenderer, AvPlayer, WechatStore } from '../../utils'
import { BottomInput, Message, MediaPreview } from './components'

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
  talkUserInputIng: boolean = false
  scroller: Scroller = new Scroller()
  player: AvPlayer = new AvPlayer()
  mediaPreviewUrl: string = ''
  mediaPreviewController: CustomDialogController = new CustomDialogController({
    builder: MediaPreview({
      url: this.mediaPreviewUrl
    }),
    autoCancel: false,
    customStyle: true
  })

  aboutToAppear(): void {
    this.setWindowBackgroundColor()
    this.getTalkUser()
    AudioRenderer.init() // 初始化音频渲染
    this.player.init()
  }

  aboutToDisappear(): void {
    this.releaseAudio()
  }

  async releaseAudio() {
    await AudioRenderer.stop() // 先暂停 再释放
    AudioRenderer.release()
  }

  getTalkUser() {
    this.talkUser = router.getParams() as UserInfoModel
    this.getAllMessageByUser()
  }

  async getAllMessageByUser() {
    this.messageList = await WechatStore.getAllMessageByUser(this.talkUser.userId)
    this.scrollBottom()
  }

  sendMessage(message: MessageTypeModel) {
    this.messageList.push(message)
    this.player.play('send.wav')
    WechatStore.addOneMessageByUser(this.talkUser.userId, message)
    this.scrollBottom()

    setTimeout(() => {
      this.requestMessage(message.messageContent)
    }, 1000)
  }

  async requestMessage(content: string) {
    this.talkUserInputIng = true
    try {
      const res = await getApiMessage(content)
      const message = new MessageTypeModel({
        sendUser: this.talkUser,
        connectUser: this.talkUser,
        messageContent: res?.data?.info?.text
      } as MessageType)
      this.messageList.push(message)
      WechatStore.addOneMessageByUser(this.talkUser.userId, message)
      this.scrollBottom()
    } catch (err) {
      console.log(JSON.parse(err))
    } finally {
      this.talkUserInputIng = false
    }
  }

  scrollBottom() {
    this.scroller.scrollEdge(Edge.Bottom)
  }

  async setWindowBackgroundColor() {
    const win = await window.getLastWindow(getContext())
    win.setWindowBackgroundColor('#ededed')
  }

  delOneMessage(messageId: string) {
    // 删除首选项数据
    WechatStore.delOneMessageByUser(this.talkUser.userId, messageId)
    // 删除内存数据
    const index = this.messageList.findIndex(item => item.id === messageId)
    if (index > -1) {
      this.messageList.splice(index, 1)
    }
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

      List({ space: 20, scroller: this.scroller }) {
        ForEach(this.messageList, (item: MessageTypeModel, index: number) => {
          ListItem() {
            Message({
              currentMessage: item,
              delOneMessage: () => {
                this.delOneMessage(item.id.toString())
              },
              mediaPreview: () => {
                this.mediaPreviewUrl = item.sourceFilePath
                this.mediaPreviewController.open()
              }
            })
          }
          .padding({
            top: index === 0 ? 10 : 0,
            bottom: index === this.messageList.length - 1 ? 10 : 0,
          })
        })
      }
      .layoutWeight(1)
      .onAppear(() => {
        this.scrollBottom()
      })

      BottomInput({
        sendMessage: (message: MessageTypeModel) => {
          this.sendMessage(message)
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}