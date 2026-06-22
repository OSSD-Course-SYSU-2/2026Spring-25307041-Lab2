import { BlockType } from '../models/Enums'
import { MazeData } from '../models/MazeData'
import { PlayerData } from '../models/PlayerData'
import { GameConfig } from '../models/GameConfig'

/**
 * 迷宫视图组件
 */
@Component
@Preview({
  title: '迷宫视图 - 默认手机',
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
  title: '迷宫视图 - 平板',
  deviceType: 'tablet',
  width: 768,
  height: 1024,
  colorMode: 'light',
  dpi: 480,
  locale: 'zh_CN',
  orientation: 'portrait',
  roundScreen: false
})
@Preview({
  title: '迷宫视图 - 横屏模式',
  deviceType: 'phone',
  width: 1024,
  height: 768,
  colorMode: 'light',
  dpi: 480,
  locale: 'zh_CN',
  orientation: 'landscape',
  roundScreen: false
})
export struct MazeView {
  @Prop mazeData: MazeData
  @Prop playerData: PlayerData
  @Prop blockSize: number = GameConfig.BLOCK_SIZE
  @Prop updateKey: number = 0  // 用于强制刷新

  build() {
    Stack() {
      // 迷宫网格
      Column() {
        ForEach(this.mazeData.grid, (row: BlockType[], y: number) => {
          Row() {
            ForEach(row, (block: BlockType, x: number) => {
              this.BlockView(block, x, y)
            }, (block: BlockType, x: number) => `${this.updateKey}-${y}-${x}-${block}`)
          }
        }, (row: BlockType[], y: number) => `${this.updateKey}-${y}`)
      }
      
      // 玩家角色
      this.PlayerView()
    }
    .width(this.blockSize * this.mazeData.width)
    .height(this.blockSize * this.mazeData.height)
  }

  /**
   * 方块视图
   */
  @Builder BlockView(block: BlockType, x: number, y: number) {
    Row()
      .width(this.blockSize)
      .height(this.blockSize)
      .backgroundColor(this.getBlockColor(block))
      .border({
        width: 0.5,
        color: '#CCCCCC'
      })
  }

  /**
   * 玩家视图
   */
  @Builder PlayerView() {
    Row()
      .width(this.blockSize * 0.6)
      .height(this.blockSize * 0.6)
      .backgroundColor(GameConfig.COLOR_PLAYER)
      .borderRadius(this.blockSize * 0.3)
      .position({
        x: this.playerData.position.x * this.blockSize + this.blockSize * 0.2,
        y: this.playerData.position.y * this.blockSize + this.blockSize * 0.2
      })
  }

  /**
   * 获取方块颜色
   */
  private getBlockColor(block: BlockType): string {
    switch (block) {
      case BlockType.EMPTY:
        return GameConfig.COLOR_EMPTY
      case BlockType.INDESTRUCTIBLE:
        return GameConfig.COLOR_INDESTRUCTIBLE
      case BlockType.DESTRUCTIBLE:
        return GameConfig.COLOR_DESTRUCTIBLE
      case BlockType.ENTRANCE:
        return GameConfig.COLOR_ENTRANCE
      case BlockType.EXIT:
        return GameConfig.COLOR_EXIT
      default:
        return GameConfig.COLOR_EMPTY
    }
  }
}
