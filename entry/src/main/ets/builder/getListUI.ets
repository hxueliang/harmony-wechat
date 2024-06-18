import { getEmptyRowUI } from '.'
import { MyListItem, PopupItem } from '../models'

@Builder
export function getListUI(list: MyListItem[]) {
  Column() {
    ForEach(list, (item: MyListItem) => {
      if (item) {
        getListItem(item)
      } else {
        getEmptyRowUI()
      }
    })
  }
  .layoutWeight(1)
}

@Builder
export function getListItem(item: PopupItem) {
  Row({ space: 20 }) {
    Image(item.icon)
      .width(30)
      .aspectRatio(1)
    Text(item.title)
      .layoutWeight(1)
    Image($r('app.media.ic_public_arrow_left'))
      .width(20)
      .aspectRatio(1)
      .rotate({ angle: 180 })
  }
  .padding({ left: 20, right: 10, top: 12, bottom: 12 })
  .backgroundColor($r('app.color.white'))
  .onClick(() => {
    item.onClick && item.onClick()
  })
}