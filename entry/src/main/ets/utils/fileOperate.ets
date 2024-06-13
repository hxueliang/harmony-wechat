import { util } from '@kit.ArkTS'
import { fileIo } from '@kit.CoreFileKit'

/**
 * 文件公共的操作
 */
export class FileCommon {
  /**
   * 创建音频文件
   * @returns 路径
   */
  static createAudioFile() {
    const path = getContext().filesDir + '/' + util.generateRandomUUID() + '.wav'
    const file = fileIo.openSync(path, fileIo.OpenMode.CREATE) // 使用创建模式，打开文件
    fileIo.closeSync(file)
    return path
  }

  /**
   * 删除音频文件
   * @param path 路径
   */
  static deleteAudioFile(path: string) {
    path && fileIo.unlink(path)
  }
}