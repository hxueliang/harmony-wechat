import { VoiceInput } from '.'

@Preview
@Component
struct BottomInput {
  @State
  isKeyboardMode: boolean = true
  @State
  content: string = ''
  @State
  showVoiceInput: boolean = false
  sendTextMessage: (content: string) => void = () => {
  }

  @Builder
  getVoiceInputUI() {
    Column() {
      VoiceInput()
    }
  }

  showSendBtn() {
    animateTo({
      duration: 200,
      playMode: PlayMode.Alternate
    }, () => {
      this.content = this.content
    })
  }

  onSubmit() {
    this.sendTextMessage(this.content)
    this.content = ''
  }

  build() {
    Row({ space: 12 }) {
      Image(this.isKeyboardMode ? $r('app.media.ic_public_sound') : $r('app.media.ic_public_keyboard'))
        .width(25)
        .aspectRatio(1)
        .onClick(() => {
          this.isKeyboardMode = !this.isKeyboardMode
        })
      if (this.isKeyboardMode) {
        TextInput({ text: $$this.content })
          .layoutWeight(1)
          .borderRadius(2)
          .height(38)
          .backgroundColor($r('app.color.white'))
          .onSubmit(() => {
            this.onSubmit()
          })
      } else {
        Button('按住 说话')
          .layoutWeight(1)
          .type(ButtonType.Normal)
          .borderRadius(2)
          .height(38)
          .backgroundColor($r('app.color.white'))
          .fontColor($r('app.color.text_primary'))
          .gesture(
            LongPressGesture()
              .onAction(() => {
                this.showVoiceInput = true
              })
              .onActionEnd(() => {
                this.showVoiceInput = false
              })
          )
      }
      if (this.content) {
        Button('发送')
          .type(ButtonType.Normal)
          .height(38)
          .borderRadius(4)
          .backgroundColor($r('app.color.second_primary'))
          .fontColor($r('app.color.white'))
          .transition(
            TransitionEffect.OPACITY.animation({ duration: 200 })
              .combine(TransitionEffect.translate({
                x: 20,
              }))
          )
          .onClick(() => {
            this.onSubmit()
          })
      } else {
        Image($r('app.media.ic_public_add_norm'))
          .width(25)
          .aspectRatio(1)
      }
    }
    .height(50)
    .backgroundColor($r('app.color.second_back_color'))
    .padding({ right: 12, left: 12 })
    .bindContentCover($$this.showVoiceInput, this.getVoiceInputUI, {
      modalTransition: ModalTransition.NONE
    })
  }
}

export default BottomInput