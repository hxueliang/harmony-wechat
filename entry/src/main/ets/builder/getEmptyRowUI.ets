type numberStr = number | string

@Builder
export function getEmptyRowUI(height: numberStr = 10, width: numberStr = '100%') {
  Row()
    .height(height)
    .width(width)
}