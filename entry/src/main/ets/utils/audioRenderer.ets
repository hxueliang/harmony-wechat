import { audio } from '@kit.AudioKit'
import { fileIo } from '@kit.CoreFileKit';

const stateList: audio.AudioState [] = [
  audio.AudioState.STATE_PREPARED,
  audio.AudioState.STATE_PAUSED,
  audio.AudioState.STATE_STOPPED
]

export class AudioRenderer {
  /** 实例 */
  static renderModel: audio.AudioRenderer
  // 采样配置
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
    channels: audio.AudioChannel.CHANNEL_2,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  };
  /** 播音配置 */
  static audioRendererInfo: audio.AudioRendererInfo = {
    rendererFlags: 0, // 音频渲染器 0 普通  1 低时延 (不支持)
    usage: audio.StreamUsage.STREAM_USAGE_MOVIE
  }
  /** 总体配置 */
  static audioRendererOptions: audio.AudioRendererOptions = {
    streamInfo: AudioRenderer.audioStreamInfo,
    rendererInfo: AudioRenderer.audioRendererInfo
  }

  /**
   * 初始化播放器的方法
   */
  static async init() {
    if (AudioRenderer.renderModel) return
    AudioRenderer.renderModel = await audio.createAudioRenderer(AudioRenderer.audioRendererOptions)
  }

  /**
   * 音频的释放和暂停
   */
  static async stop() {
    if (!AudioRenderer.renderModel) return
    await AudioRenderer.renderModel.stop() // 通知方法
  }

  /**
   * 开始语音播放
   * @param filePath
   * @param callback
   */
  static async start(filePath: string, callback?: () => void) {
    if (!filePath) return
    if (!AudioRenderer.renderModel) return
    if (!stateList.includes(AudioRenderer.renderModel.state)) return // 暂停 停止 准备 就不能播了
    // 此时可以播
    await AudioRenderer.renderModel.start() // 启动播放
    const file = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY) // 读这个文件的buffer 一段段的读取
    const stat = fileIo.statSync(file.fd) // 详细信息
    const bufferSize = await AudioRenderer.renderModel.getBufferSize() // 获取缓冲区的长度
    let buf = new ArrayBuffer(bufferSize) // 创建一个缓冲区对象 长度是音频采集器长度的长度
    let totalSize = 0
    while (totalSize < stat.size) {
      fileIo.readSync(file.fd, buf, {
        offset: totalSize,
        length: bufferSize
      })
      await AudioRenderer.renderModel.write(buf) // 往音频采集器写入缓冲区内容 播完再下一段
      totalSize += bufferSize
    }
    fileIo.closeSync(file.fd) // 关闭文件
    AudioRenderer.stop() // 关闭
    callback && callback()
  }

  /**
   * 释放
   */
  static async release() {
    if (AudioRenderer.renderModel) {
      await AudioRenderer.renderModel.release() // 释放方法
    }
  }
}
