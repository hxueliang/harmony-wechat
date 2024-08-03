import { promptAction } from '@kit.ArkUI'

import { getListUI } from '../../builder'
import { MyListItem } from '../../models'

@Component
export struct Find {
  list: MyListItem[] = [
    {
      title: '朋友圈',
      icon: $r('app.media.ic_public_friends')
    },
    null,
    {
      title: '视频号',
      icon: $r('app.media.ic_public_video')
    },
    {
      title: '直播',
      icon: $r('app.media.ic_public_live_streaming'),
      onClick: () => {
        promptAction.showToast({ message: '直播' })
      }
    },
    null,
    {
      title: '扫一扫',
      icon: $r('app.media.ic_public_scan')
    },
    {
      title: '听一听',
      icon: $r('app.media.ic_public_hear')
    },
    null,
    {
      title: '看一看',
      icon: $r('app.media.ic_public_look')
    },
    {
      title: '搜一搜',
      icon: $r('app.media.ic_public_search')
    },
    null,
    {
      title: '附近',
      icon: $r('app.media.ic_public_nearby')
    },
    null,
    {
      title: '购物',
      icon: $r('app.media.ic_public_shop')
    },
    {
      title: '游戏',
      icon: $r('app.media.ic_public_play_second')
    },
    null,
    {
      title: '小程序',
      icon: $r('app.media.ic_public_ms')
    },

  ]

  aboutToAppear(): void {
    console.log('Find')
  }

  build() {
    Scroll() {
      getListUI(this.list)
    }
  }
}