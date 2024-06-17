import { display, promptAction } from '@kit.ArkUI'
import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'
import { fileIo, picker } from '@kit.CoreFileKit'
import { util } from '@kit.ArkTS'
import { camera, cameraPicker } from '@kit.CameraKit'

import { Location, VoiceInput } from '.'
import { CURRENT_USER_KEY, MessageTypeEnum, VoiceInputState } from '../../../constants'
import { AudioCapturer, FileCommon } from '../../../utils'
import { PopupItem, MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../../models'

@Preview
@Component
struct BottomInput {
  @Provide
  voiceInputState: VoiceInputState = VoiceInputState.VOICING
  @StorageProp(CURRENT_USER_KEY)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo) // 我
  @Consume
  talkUser: UserInfoModel // 对方
  @State
  isKeyboardMode: boolean = true
  @State
  content: string = ''
  @State
  showVoiceInput: boolean = false
  @State
  screenWidth: number = 0
  @State
  screenHeight: number = 0
  @State
  showBottomCard: boolean = false // 显示底部
  @State
  showLocation: boolean = false
  @State
  bottomList: PopupItem[] = [
    {
      icon: $r('app.media.ic_public_photo'),
      title: '相册',
      onClick: () => {
        this.openPhotoAlbum()
      }
    },
    {
      icon: $r('app.media.ic_public_carema'),
      title: '拍摄',
      onClick: () => {
        this.openCamera()
      }
    },
    {
      icon: $r('app.media.ic_statusbar_gps'),
      title: '位置',
      onClick: () => {
        this.showLocation = true
      }
    },
    {
      icon: $r('app.media.ic_public_voice'),
      title: '语音输入',
    },
    {
      icon: $r("app.media.ic_public_collect"),
      title: '收藏',
    },
    {
      icon: $r("app.media.ic_public_contacts_filled"),
      title: '个人名片',
    },
    {
      icon: $r("app.media.ic_public_folder_filled"),
      title: '文件',
    },
    {
      icon: $r("app.media.ic_public_music_filled"),
      title: '音乐',
    }
  ]
  tempFilePath: string = '' // 文件临时路径
  duration: number = 0 // 语音时长
  timer: number = -1
  textController: TextInputController = new TextInputController() // 文本的控制器
  mockFilePath: string = '' // Todo: 相机拍照，模似数据用，后续模似器有相机功能后，要删除相应逻辑(1/3)
  sendMessage: (message: MessageTypeModel) => void = () => {
  }

  @Builder
  getVoiceInputUI() {
    Column() {
      VoiceInput()
    }
  }

  @Builder
  getLocationUI() {
    Column() {
      Location()
    }
  }

  @Builder
  getBottomCard(item: PopupItem) {
    Column() {
      Column() {
        Image(item.icon)
          .width(30)
          .height(30)
          .fillColor("#4c4c4c")
      }
      .backgroundColor(Color.White)
      .width(56)
      .aspectRatio(1)
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Text(item.title)
        .fontSize(12)
        .fontColor($r('app.color.text_second'))
        .margin({
          top: 10
        })
    }.layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      item.onClick && item.onClick()
    })
  }

  showSendBtn() {
    animateTo({
      duration: 200,
      playMode: PlayMode.Alternate
    }, () => {
      this.content = this.content
    })
  }

  async openCamera() {
    try {
      const result = await cameraPicker.pick(
        getContext(),
        [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO],
        { cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK }
      )
      const arr = [
        cameraPicker.PickerMediaType.PHOTO,
        cameraPicker.PickerMediaType.VIDEO,
      ]
      if (arr.includes(result.mediaType)) {
        // Todo: 相机拍照，模似数据用，后续模似器有相机功能后，要删除相应逻辑(3/3)
        if (this.mockFilePath) {
          await this.sendMediaMessage(this.mockFilePath)
          return
        }
        await this.sendMediaMessage(result.resultUri)
      }
    } catch (error) {
      promptAction.showToast({ message: '相机打开异常' })
    }
  }

  async openPhotoAlbum() {
    const photoPicker = new picker.PhotoViewPicker()
    const result = await photoPicker.select({
      maxSelectNumber: 9,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    })
    const photoUris = result.photoUris
    const length = photoUris.length
    let index = 0
    while (index < length) {
      await this.sendMediaMessage(photoUris[index])
      this.mockFilePath = photoUris[index] // Todo: 相机拍照，模似数据用，后续模似器有相机功能后，要删除相应逻辑(2/3)
      index++
    }
  }

  async sendMediaMessage(url: string) {
    // 解释媒体类型
    const extendName = url.split('.')[1]
    const messageType = extendName === 'mp4' ? MessageTypeEnum.VIDEO :
      extendName === 'jpg' ? MessageTypeEnum.IMAGE : MessageTypeEnum.IMAGE

    const file = await fileIo.open(url, fileIo.OpenMode.READ_ONLY) // 手机相册中的图片
    this.tempFilePath = getContext().filesDir + '/' + util.generateRandomUUID() + '.' + extendName
    await fileIo.copyFile(file.fd, this.tempFilePath)
    this.onSubmit(messageType)
    fileIo.close(file.fd) // 释放资源
    this.changeBottomCardDisplay(false)
  }

  onSubmit(type?: MessageTypeEnum) {
    const message = new MessageTypeModel({
      sendUser: this.currentUser,
      connectUser: this.talkUser,
      messageContent: this.content,
    } as MessageType)
    type && (message.messageType = type)
    this.tempFilePath && (message.sourceFilePath = this.tempFilePath)
    this.duration && (message.sourceDuration = this.duration)
    this.sendMessage(message)
    this.content = ''
    this.tempFilePath = ''
    this.duration = 0
  }

  async getScreenInfo() {
    const result = await display.getAllDisplays()
    this.screenWidth = px2vp(result[0].width)
    this.screenHeight = px2vp(result[0].height)
  }

  async checkPermission() {
    // 获取应用信息
    const buildInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    // 程序控制管理器
    const manager = abilityAccessCtrl.createAtManager()
    // 获取麦克风权限状态信息
    const status = manager.checkAccessTokenSync(buildInfo.appInfo?.accessTokenId, "ohos.permission.MICROPHONE")
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      // 有权限
      return Promise.resolve(true)
    }
    // 无权限
    // 唤起系统权限设置面
    const context = getContext() as common.UIAbilityContext
    context.startAbility({
      bundleName: 'com.huawei.hmos.settings', // 包名
      abilityName: 'com.huawei.hmos.settings.MainAbility', // ability名称
      uri: 'application_info_entry', // 具体页面
      parameters: {
        pushParams: buildInfo.name // 是哪个应用要开启权限
      }
    })
    return Promise.resolve(false)
  }

  beginCollectVoice() {
    this.tempFilePath = FileCommon.createFile() // 创建音频文件
    AudioCapturer.start(this.tempFilePath) // 开始录音了
    this.startTime()
  }

  releaseFinger() {
    AudioCapturer.stop() // 关闭语音输入
    this.stopTime()
    if (this.voiceInputState === VoiceInputState.CANCEL) {
      // 取消发送
      FileCommon.deleteFile(this.tempFilePath) // 删除文件
      this.duration = 0
      promptAction.showToast({ message: '取消发送' })
    }
    if (this.voiceInputState === VoiceInputState.VOICING) {
      // 发送语音
      if (this.duration < 1) {
        promptAction.showToast({ message: '说话时间太短', bottom: this.screenHeight / 2 - 30 })
        FileCommon.deleteFile(this.tempFilePath)
        this.tempFilePath = ''
        return
      }
      this.onSubmit(MessageTypeEnum.AUDIO)
    }
    if (this.voiceInputState === VoiceInputState.TRANSFER) {
      // 语音转文本
      promptAction.showToast({ message: '语音转文本' })
    }
    this.voiceInputState = VoiceInputState.VOICING
  }

  startTime() {
    this.timer = setInterval(() => {
      this.duration++
    }, 1000)
  }

  stopTime() {
    clearInterval(this.timer)
  }

  /**
   * 切换BottomCard显隐
   * @param isShow
   */
  changeBottomCardDisplay(isShow: boolean) {
    animateTo({ duration: 150 }, () => {
      this.showBottomCard = isShow
    })
  }

  aboutToAppear(): void {
    this.getScreenInfo()
    AudioCapturer.init() // 初始化采集器
  }

  aboutToDisappear(): void {
    AudioCapturer.release() // 释放采集器
  }

  build() {
    Column() {
      Row({ space: 12 }) {
        Image(this.isKeyboardMode ? $r('app.media.ic_public_sound') : $r('app.media.ic_public_keyboard'))
          .width(25)
          .aspectRatio(1)
          .onClick(() => {
            this.isKeyboardMode = !this.isKeyboardMode
            if (!this.isKeyboardMode) {
              // 显示"按住 说话"时，不显示BottomCard
              this.changeBottomCardDisplay(false)
            }
          })
        if (this.isKeyboardMode) {
          TextInput({ text: $$this.content, controller: this.textController })
            .layoutWeight(1)
            .borderRadius(2)
            .height(38)
            .backgroundColor($r('app.color.white'))
            .onSubmit(() => {
              this.onSubmit()
            })
            .onClick(() => {
              this.changeBottomCardDisplay(false)
            })
        } else {
          Button('按住 说话')
            .layoutWeight(1)
            .type(ButtonType.Normal)
            .borderRadius(2)
            .height(38)
            .backgroundColor($r('app.color.white'))
            .fontColor($r('app.color.text_primary'))
            .gesture(
              GestureGroup(
                GestureMode.Parallel,
                // voiceInputState
                LongPressGesture()
                  .onAction(async () => {
                    this.showVoiceInput = await this.checkPermission()
                    this.showVoiceInput && this.beginCollectVoice() // 开始收集声音 Todo: 待真机测试
                  })
                  .onActionEnd(() => {
                    this.showVoiceInput = false
                    this.releaseFinger() // Todo: 待真机测试
                  }),
                PanGesture()
                  .onActionUpdate((event) => {
                    const globalX = event.fingerList[0].globalX
                    const globalY = event.fingerList[0].globalY
                    if (globalY > this.screenHeight - 140) {
                      this.voiceInputState = VoiceInputState.VOICING
                      return
                    }
                    if (globalX < this.screenWidth / 2) {
                      this.voiceInputState = VoiceInputState.CANCEL
                    } else {
                      this.voiceInputState = VoiceInputState.TRANSFER
                    }
                  })
              )
            )
        }
        if (this.content) {
          Button('发送')
            .type(ButtonType.Normal)
            .height(38)
            .borderRadius(4)
            .backgroundColor($r('app.color.second_primary'))
            .fontColor($r('app.color.white'))
            .transition(
              TransitionEffect.OPACITY.animation({ duration: 200 })
                .combine(TransitionEffect.translate({
                  x: 20,
                }))
            )
            .onClick(() => {
              this.onSubmit()
            })
        } else {
          Image($r('app.media.ic_public_add_norm'))
            .width(25)
            .aspectRatio(1)
            .onClick(() => {
              // 切换BottomCard显隐
              this.changeBottomCardDisplay(!this.showBottomCard)
              if (this.showBottomCard) {
                this.textController.stopEditing() // 关闭编辑，会自动隐藏键盘
              }
              this.isKeyboardMode = true // 要显示文本输入，即：显示"按住 说话"时，不显示BottomCard
            })
        }
      }
      .height(50)
      .backgroundColor($r('app.color.second_back_color'))
      .padding({ right: 12, left: 12 })
      .bindContentCover($$this.showLocation, this.getLocationUI, {
        modalTransition: ModalTransition.NONE
      })

      if (this.showBottomCard) {
        // 底部结构
        GridRow({ columns: 4 }) {
          ForEach(this.bottomList, (item: PopupItem) => {
            GridCol() {
              this.getBottomCard(item)
            }.height(100)
          })
        }
        .width('100%')
        .padding({ top: 15 })
      }
    }
    .bindContentCover($$this.showVoiceInput, this.getVoiceInputUI, {
      modalTransition: ModalTransition.NONE
    })
  }
}

export default BottomInput