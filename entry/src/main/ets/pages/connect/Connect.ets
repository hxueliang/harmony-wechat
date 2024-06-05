import { connectList, getConnectList } from '../../apis'
import { UserInfo } from '../../models'
import { WechatStore } from '../../utils'
import { router } from '@kit.ArkUI'

@Preview
@Component
export struct Connect {
  @State
  connectList: UserInfo[] = []
  @State
  filterList: UserInfo[] = []
  @State
  @Watch('getFilterList')
  filerValue: string = ''

  aboutToAppear(): void {
    this.getConnectList()
  }

  async getConnectList() {
    this.connectList = await WechatStore.getConnectList()
    this.connectList = await getConnectList()
    WechatStore.setConnectList(this.connectList)
  }

  getFilterList() {
    this.filterList = this.connectList.filter(item => item.userName.includes(this.filerValue))
  }

  build() {
    Column({ space: 5 }) {
      Row() {
        Search({ placeholder: '搜索', value: $$this.filerValue })
          .width('100%')
          .height(30)
          .borderRadius(4)
          .backgroundColor($r('app.color.white'))
      }
      .padding({
        left: 10,
        right: 10,
      })

      List() {
        ForEach(this.filerValue ? this.filterList : this.connectList, (item: UserInfo, index) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(item.avatar)
                .width(30)
                .aspectRatio(1)
                .borderRadius(4)
              Text(item.userName)
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .height(70)
            .padding({
              left: 10,
              right: 10,
            })
            .margin({
              bottom: index === this.connectList.length - 1 ? 20 : 0
            })
          }
          .stateStyles({
            pressed: {
              .backgroundColor($r('app.color.back_color'))
            },
            normal: {
              .backgroundColor(Color.Transparent)
            },
          })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ChatDetail/ChatDetail'
            })
          })
        })
      }
      .divider({
        strokeWidth: 1,
        color: $r('app.color.border_color')
      })
      .backgroundColor($r('app.color.white'))
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
  }
}

