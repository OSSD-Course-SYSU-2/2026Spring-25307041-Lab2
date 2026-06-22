import { Direction } from './Enums'
import { Position } from './Interfaces'

/**
 * 玩家数据类
 */
export class PlayerData {
  position: Position
  direction: Direction
  isMoving: boolean

  constructor(x: number = 0, y: number = 0) {
    this.position = { x, y }
    this.direction = Direction.DOWN
    this.isMoving = false
  }

  /**
   * 移动到新位置
   */
  moveTo(x: number, y: number): void {
    this.position.x = x
    this.position.y = y
  }

  /**
   * 转向新方向
   */
  turnTo(direction: Direction): void {
    this.direction = direction
  }
}
