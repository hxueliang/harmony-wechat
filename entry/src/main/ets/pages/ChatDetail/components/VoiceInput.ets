enum RowBtnDirection {
  LEFT = -1,
  CENTER,
  RIGHT,
}

@Extend(Row)
function RowBtnStyles(dir: RowBtnDirection) {
  .width(70)
  .aspectRatio(1)
  .backgroundColor($r('app.color.voice_round_color'))
  .justifyContent(FlexAlign.Center)
  .borderRadius(35)
  .rotate({ angle: 10 * dir })
}

@Component
struct VoiceInput {
  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.ic_public_cancel'))
            .width(30)
            .aspectRatio(1)
            .fillColor($r('app.color.voice_round_font_color'))
        }
        .RowBtnStyles(RowBtnDirection.LEFT)

        Row() {
          Text('文')
            .fontSize(24)
            .fontColor($r('app.color.voice_round_font_color'))
        }
        .RowBtnStyles(RowBtnDirection.RIGHT)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 40, right: 40, bottom: 30 })

      Stack() {
        // 底部大图
        Image($r('app.media.ic_public_output'))
          .width('100%')
          .height(125)
          .fillColor($r('app.color.bottom_color'))
        // 底部声音icon
        Image($r('app.media.ic_public_recorder'))
          .width(30)
          .aspectRatio(1)
          .fillColor($r('app.color.bottom_voice_color'))
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
    .backgroundColor($r('app.color.voice_back_color'))
  }
}

export default VoiceInput