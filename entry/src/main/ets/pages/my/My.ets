import { PopupItem } from '../../models'

@Preview
@Component
export struct My {
  @Builder
  getUserInfoUI() {
    Row({ space: 20 }) {
      Image($r('app.media.ic_public_switch_camera'))
        .width(80)
        .aspectRatio(1)
        .borderRadius(4)
      Column({ space: 20 }) {
        Text('九浪')
          .fontSize(24)
          .fontColor($r('app.color.text_primary'))
        Text('九浪')
          .fontSize(16)
          .fontColor($r('app.color.text_second'))
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Image($r('app.media.ic_public_arrow_left'))
        .width(20)
        .aspectRatio(1)
        .rotate({ angle: 180 })
    }
    .padding({ left: 20, right: 10, top: 30, bottom: 30 })
    .backgroundColor($r('app.color.white'))
  }

  @Builder
  getListItem() {
    Row({ space: 20 }) {
      Image($r('app.media.ic_public_switch_camera'))
        .width(30)
        .aspectRatio(1)
      Text('服务')
        .layoutWeight(1)
      Image($r('app.media.ic_public_arrow_left'))
        .width(20)
        .aspectRatio(1)
        .rotate({ angle: 180 })
    }
    .padding({ left: 20, right: 10, top: 12, bottom: 12 })
    .backgroundColor($r('app.color.white'))
  }

  @Builder
  getEmptyListItem() {
    Row()
      .height(10)
      .width('100%')
  }

  @Builder
  getListUI() {
    Column() {
      ForEach([1, '', 2, 3, '', 4], (item: string) => {
        if (item) {
          this.getListItem()
        } else {
          this.getEmptyListItem()
        }
      })
    }
    .layoutWeight(1)
  }

  build() {
    Column({ space: 10 }) {
      this.getUserInfoUI()
      this.getListUI()
    }
  }
}