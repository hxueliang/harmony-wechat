import { VoiceInputState } from '../../../constants'

enum RowBtnDirection {
  LEFT = -1,
  CENTER,
  RIGHT,
}

@Extend(Row)
function RowBtnStyles(dir: RowBtnDirection, isSelect: boolean) {
  .width(70)
  .aspectRatio(1)
  .backgroundColor(
    isSelect ?
    $r('app.color.bottom_color') :
    $r('app.color.voice_round_color')
  )
  .justifyContent(FlexAlign.Center)
  .borderRadius(35)
  .rotate({ angle: 10 * dir })
  .scale({
    x: isSelect ? 1.2 : 1,
    y: isSelect ? 1.2 : 1,
  })
  .animation({
    duration: 200,
  })
}

@Extend(Row)
function SoundWaveRowStyles() {
  .width(70)
  .height(100)
}

@Component
struct VoiceInput {
  @Consume
  @Watch('changeVoiceInputState')
  voiceInputState: VoiceInputState
  @State
  isCancel: boolean = false
  @State
  isVoicing: boolean = false // 默认不能为true，因为bindPopup绑定的组件未挂载，需要在onAppear赋值
  @State
  isTransfer: boolean = false

  changeVoiceInputState() {
    this.isCancel = this.voiceInputState === VoiceInputState.CANCEL
    this.isVoicing = this.voiceInputState === VoiceInputState.VOICING
    this.isTransfer = this.voiceInputState === VoiceInputState.TRANSFER
  }

  @Builder
  getCancelPopupUI() {
    Row() {
    }
    .width(100)
    .height(100)
  }

  @Builder
  getVoicingPopupUI() {
    Row() {
    }
    .width('60%')
    .height(100)
  }

  @Builder
  getTransferPopupUI() {
    Row() {
    }
    .width('80%')
    .height(100)
  }

  @Builder
  getSoundWaveRowUI() {
    Row() {
      Row() {
      }
      .SoundWaveRowStyles()
      .bindPopup(this.isCancel, {
        builder: this.getCancelPopupUI,
        popupColor: $r('app.color.danger'),
        backgroundBlurStyle: BlurStyle.NONE,
        placement: Placement.Top,
      })

      Row() {
      }
      .SoundWaveRowStyles()
      .onAppear(() => {
        this.isVoicing = this.voiceInputState === VoiceInputState.VOICING
      })
      .bindPopup(this.isVoicing, {
        builder: this.getVoicingPopupUI,
        popupColor: $r('app.color.chat_primary'),
        backgroundBlurStyle: BlurStyle.NONE,
        placement: Placement.Top,
      })

      Row() {
      }
      .SoundWaveRowStyles()
      .bindPopup(this.isTransfer, {
        builder: this.getTransferPopupUI,
        popupColor: $r('app.color.chat_primary'),
        backgroundBlurStyle: BlurStyle.NONE,
        placement: Placement.Top,
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 40, right: 40 })
    .width('100%')
  }

  build() {
    Column() {
      // 声音波峰
      this.getSoundWaveRowUI()

      // 取消和转文本
      Row() {
        Row() {
          Image($r('app.media.ic_public_cancel'))
            .width(30)
            .aspectRatio(1)
            .fillColor(
              this.isCancel ?
              $r('app.color.voice_round_color') :
              $r('app.color.voice_round_font_color')
            )
        }
        .RowBtnStyles(RowBtnDirection.LEFT, this.isCancel)

        Row() {
          Text('文')
            .fontSize(24)
            .fontColor(
              this.isTransfer ?
              $r('app.color.voice_round_color') :
              $r('app.color.voice_round_font_color')
            )
        }
        .RowBtnStyles(RowBtnDirection.RIGHT, this.isTransfer)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 40, right: 40, bottom: 30 })

      // 语音
      Stack() {
        // 底部大图
        Image($r('app.media.ic_public_output'))
          .width('100%')
          .height(125)
          .fillColor(
            this.isVoicing ?
            $r('app.color.bottom_color') :
            $r('app.color.bottom_voice_color')
          )
          .scale({
            x: this.isVoicing ? 1.02 : 1,
            y: this.isVoicing ? 1.01 : 1,
          })
          .animation({
            duration: 200,
          })
        // 底部声音icon
        Image($r('app.media.ic_public_recorder'))
          .width(30)
          .aspectRatio(1)
          .fillColor(
            this.isVoicing ?
            $r('app.color.bottom_voice_color') :
            $r('app.color.bottom_color')
          )
          .animation({
            duration: 200,
          })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
    .backgroundColor($r('app.color.voice_back_color'))
  }
}

export default VoiceInput