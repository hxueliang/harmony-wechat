import { media } from '@kit.MediaKit'

export class AvPlayer {
  avPlayer: media.AVPlayer | null = null // 初始属性

  async init() {
    this.avPlayer = await media.createAVPlayer() // 创建avPlayer
    this.watchCallBack()
  }

  /**
   * 监听状态变化
   */
  watchCallBack() {
    this.avPlayer?.on("stateChange", (state: string) => {
      if (state === 'idle') {
        console.info('AVPlayer state idle called.');
      }
      else if (state === 'initialized') {
        console.info('AVPlayer state initialized called.');
        this.avPlayer?.prepare(); // 准备播放
      }
      else if (state === 'prepared') {
        console.info('AVPlayer state prepared called.');
        this.avPlayer?.play(); // 调用播放接口开始播放
      }
      else if (state === 'playing') {
        console.info('AVPlayer state playing called.');
      }
      else if (state === 'paused') {
        console.info('AVPlayer state paused called.');
      }
      else if (state === 'completed') {
        console.info('AVPlayer state completed called.');
        this.avPlayer?.reset() // 重置
      }
      else if (state === 'stopped') {
        console.info('AVPlayer state stopped called.');
        this.avPlayer?.reset() // 重置
      }
      else if (state === 'released') {
        console.info('AVPlayer state released called.');
        this.avPlayer?.reset() // 重置
      }
      else if (state === 'error') {
        console.info('AVPlayer state error called.');
        this.avPlayer?.reset() // 重置
      }
      else {
        console.info('AVPlayer state unknown called.');
      }
    })
  }

  /**
   * play播放方法
   * @param fileName
   */
  async play(fileName: string) {
    // 资源管理器获取文件的方法
    const fileDes = await getContext().resourceManager.getRawFd(fileName)
    console.log('x_log', JSON.stringify(fileDes))
    this.avPlayer!.fdSrc = fileDes // 赋值url或者fdSrc会造成
  }
}
