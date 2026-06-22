import { Direction, BlockType } from '../models/Enums'
import { MazeData } from '../models/MazeData'
import { PlayerData } from '../models/PlayerData'
import { IMovementController, Position } from '../models/Interfaces'

/**
 * 移动控制器
 */
export class MovementController implements IMovementController {
  private mazeData: MazeData
  private playerData: PlayerData

  constructor(mazeData: MazeData, playerData: PlayerData) {
    this.mazeData = mazeData
    this.playerData = playerData
  }

  /**
   * 移动角色
   */
  move(direction: Direction): boolean {
    // 验证是否可以移动
    if (!this.canMove(direction)) {
      return false
    }

    // 获取目标位置
    const targetPos = this.getTargetPosition(direction)
    
    // 更新玩家位置
    this.updatePosition(targetPos.x, targetPos.y, direction)
    
    return true
  }

  /**
   * 检查是否可以移动
   */
  canMove(direction: Direction): boolean {
    const targetPos = this.getTargetPosition(direction)
    
    // 检查目标位置是否在迷宫范围内
    if (!this.mazeData.isValidPosition(targetPos.x, targetPos.y)) {
      return false
    }

    // 检查目标位置是否可通过
    const blockType = this.mazeData.getBlock(targetPos.x, targetPos.y)
    
    // 只有空地、入口和出口可以通过
    return blockType === BlockType.EMPTY || 
           blockType === BlockType.ENTRANCE || 
           blockType === BlockType.EXIT
  }

  /**
   * 获取目标位置
   */
  private getTargetPosition(direction: Direction): Position {
    const currentX = this.playerData.position.x
    const currentY = this.playerData.position.y

    switch (direction) {
      case Direction.UP:
        return { x: currentX, y: currentY - 1 } as Position
      case Direction.DOWN:
        return { x: currentX, y: currentY + 1 } as Position
      case Direction.LEFT:
        return { x: currentX - 1, y: currentY } as Position
      case Direction.RIGHT:
        return { x: currentX + 1, y: currentY } as Position
      default:
        return { x: currentX, y: currentY } as Position
    }
  }

  /**
   * 更新玩家位置
   */
  private updatePosition(x: number, y: number, direction: Direction): void {
    this.playerData.moveTo(x, y)
    this.playerData.turnTo(direction)
  }
}
