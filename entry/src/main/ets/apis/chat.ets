import { ChatResponse } from '../models'
import { httpRequest } from '../utils'

export async function getApiMessage(content: string) {
  try {
    const res = await httpRequest.request(`https://api.ownthink.com/bot?appid=xiaosi&userid=user&spoken=${encodeURI(content)}`)
    const result = JSON.parse(res.result as string) as ChatResponse
    return result
  } catch (err) {
    return Promise.reject(err)
  }
}