import { MessageTypeEnum } from '../../../constants'

@CustomDialog
@Component
struct MediaPreview {
  controller: CustomDialogController
  url: string = ''
  messageType: MessageTypeEnum = MessageTypeEnum.IMAGE

  build() {
    // Todo: 底部没全屏
    Column() {
      if (this.messageType === MessageTypeEnum.IMAGE) {
        Image('file://' + this.url)
          .width('100%')
      }
      else if (this.messageType === MessageTypeEnum.VIDEO) {
        Video({
          src: 'file://' + this.url
        })
          .width('100%')
          .height('100%')
          .autoPlay(true)
          .controls(false)
          .loop(true)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.black'))
    .onClick(() => {
      this.controller.close()
    })
  }
}

export default MediaPreview