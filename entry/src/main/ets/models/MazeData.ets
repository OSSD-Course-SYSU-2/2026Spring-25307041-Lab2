import { BlockType } from './Enums'
import { Position } from './Interfaces'

/**
 * 迷宫数据类
 */
export class MazeData {
  width: number
  height: number
  grid: BlockType[][]
  entrance: Position
  exit: Position

  constructor(width: number, height: number) {
    this.width = width
    this.height = height
    this.grid = []
    this.entrance = { x: 0, y: 0 }
    this.exit = { x: 0, y: 0 }
    
    // 初始化网格
    for (let i = 0; i < height; i++) {
      this.grid[i] = []
      for (let j = 0; j < width; j++) {
        this.grid[i][j] = BlockType.INDESTRUCTIBLE
      }
    }
  }

  /**
   * 获取指定位置的方块类型
   */
  getBlock(x: number, y: number): BlockType {
    if (!this.isValidPosition(x, y)) {
      return BlockType.INDESTRUCTIBLE
    }
    return this.grid[y][x]
  }

  /**
   * 设置指定位置的方块类型
   */
  setBlock(x: number, y: number, type: BlockType): void {
    if (this.isValidPosition(x, y)) {
      this.grid[y][x] = type
    }
  }

  /**
   * 检查位置是否有效
   */
  isValidPosition(x: number, y: number): boolean {
    return x >= 0 && x < this.width && y >= 0 && y < this.height
  }
}
