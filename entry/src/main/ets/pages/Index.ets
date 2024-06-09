import { ITabItem } from '../models'
import { WeChat } from './weChat/WeChat'
import { Connect } from './connect/Connect'

@Entry
@Component
struct Index {
  tabList: ITabItem[] = [{
    name: 'wechat',
    title: '微信',
    icon: $r('app.media.ic_public_message'),
    actionIcon: $r('app.media.ic_public_message_filled')
  }, {
    name: 'connect',
    title: '联系人',
    icon: $r('app.media.ic_public_contacts_group'),
    actionIcon: $r('app.media.ic_public_contacts_group_filled')
  }, {
    name: 'discover',
    title: '发现',
    icon: $r('app.media.ic_gallery_discover'),
    actionIcon: $r('app.media.ic_gallery_discover_filled')
  }, {
    name: 'my',
    title: '我的',
    icon: $r('app.media.ic_public_my'),
    actionIcon: $r('app.media.ic_public_my_filled')
  }]
  @State
  actionIndex: number = 0

  @Builder
  getTabUI(item: ITabItem, index: number) {
    Column({ space: 4 }) {
      Image(this.actionIndex === index ? item.actionIcon : item.icon)
        .width(20)
        .aspectRatio(1)
      Text(item.title)
        .fontSize(14)
        .fontColor(this.actionIndex === index ? $r('app.color.primary') : $r('app.color.text_primary'))
    }
  }

  build() {
    Tabs({ index: $$this.actionIndex }) {
      ForEach(this.tabList, (item: ITabItem, index: number) => {
        TabContent() {
          if (item.name === 'connect') {
            Connect()
          } else if (item.name === 'wechat') {
            WeChat()
          }
        }.tabBar(this.getTabUI(item, index))
      })
    }
    .animationDuration(100)
    .barPosition(BarPosition.End)
  }
}