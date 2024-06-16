@CustomDialog
@Component
struct ImagePreview {
  controller: CustomDialogController
  url: string = ''

  build() {
    // Todo: 底部没全屏
    Column() {
      Image('file://' + this.url)
        .width('100%')
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

export default ImagePreview