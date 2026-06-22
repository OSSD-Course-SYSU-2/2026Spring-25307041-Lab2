import { GameState } from '../models/Enums'

/**
 * 状态显示组件
 */
@Component
@Preview({
  title: '状态显示 - 默认手机',
  deviceType: 'phone',
  width: 360,
  height: 640,
  colorMode: 'light',
  dpi: 480,
  locale: 'zh_CN',
  orientation: 'portrait',
  roundScreen: false
})
@Preview({
  title: '状态显示 - 平板',
  deviceType: 'tablet',
  width: 768,
  height: 1024,
  colorMode: 'light',
  dpi: 480,
  locale: 'zh_CN',
  orientation: 'portrait',
  roundScreen: false
})
export struct StatusDisplay {
  @Prop gameState: GameState

  build() {
    Row() {
      Text(this.getStatusText())
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.getStatusColor())
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F0F0F0')
    .borderRadius(10)
  }

  /**
   * 获取状态文本
   */
  private getStatusText(): string {
    switch (this.gameState) {
      case GameState.READY:
        return '准备开始'
      case GameState.PLAYING:
        return '游戏进行中'
      case GameState.VICTORY:
        return '🎉 恭喜通关！🎉'
      case GameState.GAME_OVER:
        return '游戏结束'
      default:
        return ''
    }
  }

  /**
   * 获取状态颜色
   */
  private getStatusColor(): ResourceColor {
    switch (this.gameState) {
      case GameState.VICTORY:
        return '#32CD32'
      case GameState.PLAYING:
        return '#4169E1'
      default:
        return '#4A4A4A'
    }
  }
}
