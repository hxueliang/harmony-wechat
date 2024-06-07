export interface ChatResponse {
  message: string,
  data:ChatData,
}

interface  ChatData {
  type: number,
  info: ChatInfo,
}

interface  ChatInfo {
  text: string,
}