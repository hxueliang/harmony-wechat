interface TimeObj {
  year: number
  month: number
  date: number
  hours: number
  minutes: number
  second: number
}

export class TimeObjModel implements TimeObj {
  year: number = 0
  month: number = 0
  date: number = 0
  hours: number = 0
  minutes: number = 0
  second: number = 0

  constructor(model: TimeObj) {
    this.year = model.year
    this.month = model.month
    this.date = model.date
    this.hours = model.hours
    this.minutes = model.minutes
    this.second = model.second
  }
}

export function getTimeObj(time: number | string | Date) {
  if (!(time instanceof Date)) {
    time = new Date(time)
  }
  const dateObj = new Date(time)
  const year = dateObj.getFullYear()
  const month = dateObj.getMonth() + 1
  const date = dateObj.getDate()
  const hours = dateObj.getHours()
  const minutes = dateObj.getMinutes()
  const second = dateObj.getSeconds()
  return new TimeObjModel({
    year,
    month,
    date,
    hours,
    minutes,
    second,
  })
}