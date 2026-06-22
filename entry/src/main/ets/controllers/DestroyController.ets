import { BlockType } from '../models/Enums'
import { MazeData } from '../models/MazeData'
import { PlayerData } from '../models/PlayerData'
import { IDestroyController, Position, DirectionOffset } from '../models/Interfaces'

/**
 * 炸毁控制器
 */
export class DestroyController implements IDestroyController {
  private mazeData: MazeData
  private playerData: PlayerData

  constructor(mazeData: MazeData, playerData: PlayerData) {
    this.mazeData = mazeData
    this.playerData = playerData
  }

  /**
   * 炸毁方块
   * 炸毁角色周围相邻一格内的所有可炸毁方块
   */
  destroy(): boolean {
    // 获取周围所有可炸毁的方块位置
    const destroyTargets = this.getDestroyTargets()
    
    // 如果没有可炸毁的方块，返回false
    if (destroyTargets.length === 0) {
      return false
    }
    
    // 炸毁所有可炸毁的方块
    for (const target of destroyTargets) {
      this.updateMaze(target.x, target.y)
    }
    
    return true
  }

  /**
   * 检查是否可以炸毁
   */
  canDestroy(): boolean {
    // 检查周围是否有可炸毁的方块
    const destroyTargets = this.getDestroyTargets()
    return destroyTargets.length > 0
  }

  /**
   * 获取周围所有可炸毁的方块位置
   */
  private getDestroyTargets(): Position[] {
    const currentX = this.playerData.position.x
    const currentY = this.playerData.position.y
    const targets: Position[] = []
    
    // 检查四个方向的相邻方块
    const directions: DirectionOffset[] = [
      { dx: 0, dy: -1 },  // 上
      { dx: 0, dy: 1 },   // 下
      { dx: -1, dy: 0 },  // 左
      { dx: 1, dy: 0 }    // 右
    ]
    
    for (const dir of directions) {
      const newX = currentX + dir.dx
      const newY = currentY + dir.dy
      
      // 检查位置是否有效
      if (this.mazeData.isValidPosition(newX, newY)) {
        const blockType = this.mazeData.getBlock(newX, newY)
        // 如果是可炸毁方块，添加到目标列表
        if (blockType === BlockType.DESTRUCTIBLE) {
          targets.push({ x: newX, y: newY } as Position)
        }
      }
    }
    
    return targets
  }

  /**
   * 更新迷宫数据
   */
  private updateMaze(x: number, y: number): void {
    // 将目标位置设置为空地，角色可以移动到该位置
    this.mazeData.setBlock(x, y, BlockType.EMPTY)
  }
}
