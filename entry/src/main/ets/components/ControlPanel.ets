import { Direction } from '../models/Enums'
import { GameConfig } from '../models/GameConfig'

/**
 * 控制面板组件
 */
@Component
@Preview({
  title: '控制面板 - 浅色模式',
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
  title: '控制面板 - 横屏模式',
  deviceType: 'phone',
  width: 1024,
  height: 768,
  colorMode: 'light',
  dpi: 480,
  locale: 'zh_CN',
  orientation: 'landscape',
  roundScreen: false
})
@Preview({
  title: '控制面板 - 平板',
  deviceType: 'tablet',
  width: 768,
  height: 1024,
  colorMode: 'light',
  dpi: 480,
  locale: 'zh_CN',
  orientation: 'portrait',
  roundScreen: false
})
export struct ControlPanel {
  onMove: (direction: Direction) => void = () => {}
  onDestroy: () => void = () => {}
  
  @Prop buttonSize: number = GameConfig.BUTTON_SIZE

  build() {
    Column() {
      // 第一行：前进 + 炸毁
      Row() {
        this.ControlButton('↑', () => {
          this.onMove(Direction.UP)
        })
        
        Blank()
          .width(GameConfig.BUTTON_SPACING)
        
        this.ControlButton('💥', () => {
          this.onDestroy()
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 10 })

      // 第二行：左 + 后退 + 右
      Row() {
        this.ControlButton('←', () => {
          this.onMove(Direction.LEFT)
        })
        
        Blank()
          .width(GameConfig.BUTTON_SPACING)
        
        this.ControlButton('↓', () => {
          this.onMove(Direction.DOWN)
        })
        
        Blank()
          .width(GameConfig.BUTTON_SPACING)
        
        this.ControlButton('→', () => {
          this.onMove(Direction.RIGHT)
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding(20)
  }

  /**
   * 控制按钮
   */
  @Builder ControlButton(text: string, onClick: () => void) {
    Button(text)
      .width(this.buttonSize)
      .height(this.buttonSize)
      .fontSize(24)
      .backgroundColor('#4169E1')
      .fontColor(Color.White)
      .borderRadius(10)
      .onClick(() => {
        onClick()
      })
  }
}
