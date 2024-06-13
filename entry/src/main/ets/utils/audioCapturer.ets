import { audio } from '@kit.AudioKit'
import { fileIo } from '@kit.CoreFileKit'

/**
 * 录音单例类
 */
export class AudioCapturer {
  /** 采音对象的单例对象 */
  static audioCapturer: audio.AudioCapturer
  /** 采样配置 */
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
    channels: audio.AudioChannel.CHANNEL_2,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  }
  /** 录音配置 */
  static audioCapturerInfo: audio.AudioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_MIC,
    capturerFlags: 0
  }
  /** 总体配置 */
  static audioCapturerOptions: audio.AudioCapturerOptions = {
    streamInfo: AudioCapturer.audioStreamInfo,
    capturerInfo: AudioCapturer.audioCapturerInfo
  }
  /** 是否正在录制 */
  static recordIng: boolean = false

  /**
   * 初始化音频采集器的方法
   */
  static async init() {
    if (AudioCapturer.audioCapturer) return
    AudioCapturer.audioCapturer = await audio.createAudioCapturer(AudioCapturer.audioCapturerOptions)
  }

  /**
   * 开始录音
   * @param path
   */
  static async start(path: string) {
    try {
      if (!AudioCapturer.audioCapturer) return
      await AudioCapturer.audioCapturer.start() // 开始录音
      AudioCapturer.recordIng = true // 开始录音的标志
      const file = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE) // 如果不存在就创建文件
      let fd = file.fd // 文件标识
      const statFile = fileIo.statSync(fd)
      let sourceBufferSize = statFile.size // 原有文件的buffer的长度 是一个写入文件的基准点
      while (AudioCapturer.recordIng) { // 只要这个标记为开始 那么我就一直采集一直写入文件
        let size = await AudioCapturer.audioCapturer.getBufferSize() // 获取缓冲区的长度
        let buffer = await AudioCapturer.audioCapturer.read(size, true) // 当前这一段的录音的内容
        fileIo.writeSync(fd, buffer, {
          offset: sourceBufferSize, // 偏移量
          length: buffer.byteLength
        })
        sourceBufferSize += buffer.byteLength
      }
    } catch (error) {
      AlertDialog.show({ message: error.message })
    }
  }

  /**
   * 结束录音
   */
  static async stop() {
    AudioCapturer.recordIng = false
    if (!AudioCapturer.audioCapturer) return
    if (
      AudioCapturer.audioCapturer.state === audio.AudioState.STATE_RUNNING ||
        AudioCapturer.audioCapturer.state === audio.AudioState.STATE_PAUSED
    ) {
      await AudioCapturer.audioCapturer.stop() // 停止录音
    }
  }

  /**
   * 释放资源
   */
  static async release() {
    AudioCapturer.recordIng = false
    if (!AudioCapturer.audioCapturer) return
    AudioCapturer.audioCapturer.release()
  }
}
