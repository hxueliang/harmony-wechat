@Preview
@Component
struct BottomInput {
  build() {
    Row({ space: 12 }) {
      Image($r('app.media.ic_public_sound'))
        .width(25)
        .aspectRatio(1)
      TextInput()
        .layoutWeight(1)
        .borderRadius(2)
        .height(38)
        .backgroundColor($r('app.color.white'))
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