import { CURRENT_USER_KEY } from '../../constants'
import { PopupItem, UserInfo, UserInfoModel } from '../../models'

type MyListItem = PopupItem | null

@Preview
@Component
export struct My {
  @StorageProp(CURRENT_USER_KEY)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  myList: MyListItem[] = [
    {
      title: '服务',
      icon: $r('app.media.ic_public_serve')
    },
    null,
    {
      title: '收藏',
      icon: $r('app.media.ic_public_collect_second')
    },
    {
      title: '朋友圈',
      icon: $r('app.media.ic_public_friends'),
    },
    {
      title: '卡包',
      icon: $r('app.media.ic_public_card'),
    },
    {
      title: '表情',
      icon: $r('app.media.ic_public_face'),
    },
    null,
    {
      title: '设置',
      icon: $r('app.media.ic_public_setting'),
    },
  ]

  @Builder
  getUserInfoUI() {
    Row({ space: 20 }) {
      Image(this.currentUser.avatar)
        .width(80)
        .aspectRatio(1)
        .borderRadius(4)
      Column({ space: 20 }) {
        Text(this.currentUser.userName)
          .fontSize(26)
          .fontColor($r('app.color.text_primary'))
        Text(`v信号：${this.currentUser.userId}`)
          .fontSize(18)
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
  getListItem(item: PopupItem) {
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
      ForEach(this.myList, (item: MyListItem) => {
        if (item) {
          this.getListItem(item)
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