/**
 * 语音录音状态
 */
export enum VoiceInputState {
  /** 取消 */
  CANCEL = -1,
  /** 录入中 */
  VOICING,
  /** 转文本 */
  TRANSFER,
}