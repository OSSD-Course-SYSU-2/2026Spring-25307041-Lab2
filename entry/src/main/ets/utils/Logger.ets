import { hilog } from '@kit.PerformanceAnalysisKit'

const DOMAIN = 0x0000
const TAG = 'MazeGame'

/**
 * 日志工具类
 */
export class Logger {
  /**
   * 信息日志
   */
  static info(message: string): void {
    hilog.info(DOMAIN, TAG, '%{public}s', message)
  }

  /**
   * 警告日志
   */
  static warn(message: string): void {
    hilog.warn(DOMAIN, TAG, '%{public}s', message)
  }

  /**
   * 错误日志
   */
  static error(message: string): void {
    hilog.error(DOMAIN, TAG, '%{public}s', message)
  }

  /**
   * 调试日志
   */
  static debug(message: string): void {
    hilog.debug(DOMAIN, TAG, '%{public}s', message)
  }
}
