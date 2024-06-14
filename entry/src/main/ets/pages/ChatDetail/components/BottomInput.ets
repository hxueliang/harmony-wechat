import { display, promptAction } from '@kit.ArkUI'
import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'

import { VoiceInput } from '.'
import { CURRENT_USER_KEY, MessageTypeEnum, VoiceInputState } from '../../../constants'
import { AudioCapturer, FileCommon } from '../../../utils'
import { MessageType, MessageTypeModel, UserInfo, UserInfoModel } from '../../../models'

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
  tempAudioPath: string = '' // 语音的临时路径
  duration: number = 0 // 语音时长
  timer: number = -1
  sendMessage: (message: MessageTypeModel) => void = () => {
  }

  @Builder
  getVoiceInputUI() {
    Column() {
      VoiceInput()
    }
  }

  showSendBtn() {
    animateTo({
      duration: 200,
      playMode: PlayMode.Alternate
    }, () => {
      this.content = this.content
    })
  }

  onSubmit(type?: MessageTypeEnum) {
    const message = new MessageTypeModel({
      sendUser: this.currentUser,
      connectUser: this.talkUser,
      messageContent: this.content,
    } as MessageType)
    type && (message.messageType = type)
    this.tempAudioPath && (message.sourceFilePath = this.tempAudioPath)
    this.duration && (message.sourceDuration = this.duration)
    this.sendMessage(message)
    this.content = ''
    this.tempAudioPath = ''
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
    this.tempAudioPath = FileCommon.createFile() // 创建音频文件
    AudioCapturer.start(this.tempAudioPath) // 开始录音了
    this.startTime()
  }

  releaseFinger() {
    AudioCapturer.stop() // 关闭语音输入
    this.stopTime()
    if (this.voiceInputState === VoiceInputState.CANCEL) {
      // 取消发送
      FileCommon.deleteFile(this.tempAudioPath) // 删除文件
      promptAction.showToast({ message: '取消发送' })
    }
    if (this.voiceInputState === VoiceInputState.VOICING) {
      // 发送语音
      if (this.duration < 1) {
        promptAction.showToast({ message: '说话时间太短', bottom: this.screenHeight / 2 - 30 })
        FileCommon.deleteFile(this.tempAudioPath)
        this.tempAudioPath = ''
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

  aboutToAppear(): void {
    this.getScreenInfo()
    AudioCapturer.init() // 初始化采集器
  }

  aboutToDisappear(): void {
    AudioCapturer.release() // 释放采集器
  }

  build() {
    Row({ space: 12 }) {
      Image(this.isKeyboardMode ? $r('app.media.ic_public_sound') : $r('app.media.ic_public_keyboard'))
        .width(25)
        .aspectRatio(1)
        .onClick(() => {
          this.isKeyboardMode = !this.isKeyboardMode
        })
      if (this.isKeyboardMode) {
        TextInput({ text: $$this.content })
          .layoutWeight(1)
          .borderRadius(2)
          .height(38)
          .backgroundColor($r('app.color.white'))
          .onSubmit(() => {
            this.onSubmit()
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
      }
    }
    .height(50)
    .backgroundColor($r('app.color.second_back_color'))
    .padding({ right: 12, left: 12 })
    .bindContentCover($$this.showVoiceInput, this.getVoiceInputUI, {
      modalTransition: ModalTransition.NONE
    })
  }
}

export default BottomInput