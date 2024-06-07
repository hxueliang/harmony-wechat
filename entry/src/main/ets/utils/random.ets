/**
 * 随机一个小写字母
 * @returns a-z
 */
export function getRandomLowerLetter() {
  return String.fromCharCode(97 + Math.random() * (122 - 97 + 1)); // 小写字母 'a' 到 'z'
}

/**
 * 随机一个大写字母
 * @returns A-Z
 */
export function getRandomCapitalLetter() {
  return String.fromCharCode(97 + Math.random() * (122 - 97 + 1)); // 小写字母 'a' 到 'z'
}