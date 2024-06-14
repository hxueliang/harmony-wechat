/**
 * 消息类型
 */
export enum MessageTypeEnum {
  /** 文本 */
  TEXT,
  /** 图片 */
  IMAGE,
  /** 音频 */
  AUDIO,
  /** 视频 */
  VIDEO,
  /** 定位 */
  LOCATION,
  /** 链接 */
  LINK
}

/**
 * 消息类型名称
 */
export const MessageTypeNameList = [
  '文本',
  '图片',
  '语音',
  '视频',
  '位置',
  '链接',
]

/**
 * 显示内容
 */
export const ShowContent = [
  MessageTypeEnum.TEXT,
]

/**
 * 显示类型名称
 */
export const ShowTypeName = [
  MessageTypeEnum.IMAGE,
  MessageTypeEnum.VIDEO,
]

/**
 * 显示类型名称和时长
 */
export const ShowTypeNameAndDuration = [
  MessageTypeEnum.AUDIO,
]

/**
 * 显示类型名称和内容
 */
export const ShowTypeNameAndContent = [
  MessageTypeEnum.LOCATION,
]

/**
 * 显示文件
 */
export const ShowFile = [
  MessageTypeEnum.IMAGE,
  MessageTypeEnum.VIDEO,
]