import { promptAction, router } from '@kit.ArkUI'
import { generateBarcode, scanCore } from '@kit.ScanKit'

@Entry
@Component
struct PayQrCode {
  @State
  payParams: string = ''
  @State
  barCodeImage: PixelMap | null = null
  timer: number = -1

  aboutToAppear(): void {
    this.getNewPayParams()
    this.getBarCodeImage()
    this.timer = setInterval(() => {
      this.getNewPayParams()
    }, 10 * 1000)
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  getNewPayParams() {
    this.payParams = Math.random().toString() // 模似后端提供的密钥
    this.getBarCodeImage()
  }

  async getBarCodeImage() {
    if (!canIUse('scanCore.ScanType')) {
      return
    }
    // Todo: 待新版本模似器测试
    const option: generateBarcode.CreateOptions = {
      scanType: scanCore.ScanType.CODE128_CODE,
      width: 800,
      height: 200,
    }
    this.barCodeImage = await generateBarcode.createBarcode(this.payParams, option)
  }

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_public_arrow_left'))
            .width(30)
            .height(30)
            .fillColor($r("app.color.white"))
            .onClick(() => {
              router.back()
            })
            .zIndex(2)

          Text("收付款")
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontColor($r('app.color.white'))
        }
        .height(50)
      }
      .padding({
        left: 10,
        right: 10
      })

      Row() {
        Column() {
          Row({ space: 10 }) {
            Image($r("app.media.ic_public_scan"))
              .width(20)
              .height(20)
              .fillColor($r("app.color.pay_back"))
            Text("付款码")
              .fontColor($r("app.color.pay_back"))
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .height(60)
          .border({
            width: {
              bottom: 0.5
            },
            color: $r("app.color.border_color")
          })

          // 显示码
          Column({ space: 20 }) {
            Text("优先使用xx银行储蓄卡付款")
              .fontColor($r("app.color.text_second"))
              .fontSize(12)

            // 条型码
            if (this.barCodeImage) {
              Image(this.barCodeImage)
                .width(260)
                .height(60)
                .objectFit(ImageFit.Contain)
            } else {
              Text('此版本不支付条型码')
                .width(260)
                .height(60)
                .textAlign(TextAlign.Center)
                .border({
                  width: 1,
                })
            }


            // 二维码
            QRCode(this.payParams)
              .width(150)
              .aspectRatio(1)
          }
          .margin({
            top: 10,
            bottom: 10
          })
        }
        .padding(10)
        .borderRadius(4)
        .width("100%")
        .backgroundColor($r("app.color.white"))
      }
      .padding({
        left: 10,
        right: 20
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.pay_back"))
  }
}