@Preview
@Component
struct BottomInput {
  @State
  isKeyboardMode: boolean = false

  build() {
    Row({ space: 12 }) {
      Image(this.isKeyboardMode ? $r('app.media.ic_public_sound') : $r('app.media.ic_public_keyboard'))
        .width(25)
        .aspectRatio(1)
        .onClick(() => {
          this.isKeyboardMode = !this.isKeyboardMode
        })
      if (this.isKeyboardMode) {
        TextInput()
          .layoutWeight(1)
          .borderRadius(2)
          .height(38)
          .backgroundColor($r('app.color.white'))
      } else {
        Button('按住 说话')
          .layoutWeight(1)
          .type(ButtonType.Normal)
          .borderRadius(2)
          .height(38)
          .backgroundColor($r('app.color.white'))
          .fontColor($r('app.color.text_primary'))
      }
      Image($r('app.media.ic_public_add_norm'))
        .width(25)
        .aspectRatio(1)
    }
    .height(50)
    .backgroundColor($r('app.color.second_back_color'))
    .padding({ right: 12, left: 12 })
  }
}

export default BottomInput