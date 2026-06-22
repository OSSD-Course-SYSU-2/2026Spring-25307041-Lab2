import { BlockType } from '../models/Enums'
import { MazeData } from '../models/MazeData'
import { GameConfig } from '../models/GameConfig'
import { Position, DirectionOffset } from '../models/Interfaces'

/**
 * 迷宫生成器
 * 使用随机Prim算法生成迷宫
 */
export class MazeGenerator {
  private width: number
  private height: number
  private maze: MazeData

  constructor(width: number = GameConfig.MAZE_WIDTH, height: number = GameConfig.MAZE_HEIGHT) {
    this.width = width
    this.height = height
    this.maze = new MazeData(width, height)
  }

  /**
   * 生成迷宫
   */
  generate(): MazeData {
    let attempts = 0
    const maxAttempts = 10  // 增加重试次数，确保能生成可达的迷宫

    while (attempts < maxAttempts) {
      // 初始化迷宫（所有位置为墙）
      this.initializeMaze()
      
      // 使用Prim算法生成迷宫
      this.generateByPrim()
      
      // 设置入口和出口
      this.setEntranceAndExit()
      
      // 添加可炸毁方块
      this.addDestructibleBlocks()
      
      // 验证路径
      if (this.validatePath()) {
        return this.maze
      }
      
      attempts++
    }

    // 如果多次尝试都失败，返回最后一次生成的迷宫
    return this.maze
  }

  /**
   * 初始化迷宫
   */
  private initializeMaze(): void {
    for (let y = 0; y < this.height; y++) {
      for (let x = 0; x < this.width; x++) {
        this.maze.setBlock(x, y, BlockType.INDESTRUCTIBLE)
      }
    }
  }

  /**
   * 使用Prim算法生成迷宫
   */
  private generateByPrim(): void {
    // 边界列表
    const walls: Position[] = []
    
    // 从(1,1)开始
    const startX = 1
    const startY = 1
    this.maze.setBlock(startX, startY, BlockType.EMPTY)
    
    // 添加起始点周围的墙
    this.addWalls(startX, startY, walls)
    
    // 随机选择墙并打通
    while (walls.length > 0) {
      // 随机选择一面墙
      const randomIndex = Math.floor(Math.random() * walls.length)
      const wall = walls[randomIndex]
      
      // 移除这面墙
      walls.splice(randomIndex, 1)
      
      // 检查这面墙是否可以打通
      if (this.canCarve(wall.x, wall.y)) {
        // 打通墙壁
        this.maze.setBlock(wall.x, wall.y, BlockType.EMPTY)
        
        // 添加新墙到边界列表
        this.addWalls(wall.x, wall.y, walls)
      }
    }
  }

  /**
   * 添加周围的墙到边界列表
   */
  private addWalls(x: number, y: number, walls: Position[]): void {
    const directions: DirectionOffset[] = [
      { dx: 0, dy: -2 },  // 上
      { dx: 0, dy: 2 },   // 下
      { dx: -2, dy: 0 },  // 左
      { dx: 2, dy: 0 }    // 右
    ]

    for (const dir of directions) {
      const newX = x + dir.dx
      const newY = y + dir.dy
      
      if (this.maze.isValidPosition(newX, newY) && 
          this.maze.getBlock(newX, newY) === BlockType.INDESTRUCTIBLE) {
        walls.push({ x: newX, y: newY })
      }
    }
  }

  /**
   * 检查是否可以打通墙壁
   */
  private canCarve(x: number, y: number): boolean {
    // 统计周围空地的数量
    let emptyCount = 0
    const directions: DirectionOffset[] = [
      { dx: 0, dy: -1 },
      { dx: 0, dy: 1 },
      { dx: -1, dy: 0 },
      { dx: 1, dy: 0 }
    ]

    for (const dir of directions) {
      const newX = x + dir.dx
      const newY = y + dir.dy
      
      if (this.maze.isValidPosition(newX, newY) && 
          this.maze.getBlock(newX, newY) === BlockType.EMPTY) {
        emptyCount++
      }
    }

    // 只有当周围恰好有一个空地时才能打通
    return emptyCount === 1
  }

  /**
   * 设置入口和出口
   */
  private setEntranceAndExit(): void {
    // 入口设置在左上角附近
    this.maze.entrance = { x: 1, y: 1 }
    this.maze.setBlock(1, 1, BlockType.ENTRANCE)
    
    // 出口设置在右下角附近
    const exitX = this.width - 2
    const exitY = this.height - 2
    this.maze.exit = { x: exitX, y: exitY }
    this.maze.setBlock(exitX, exitY, BlockType.EXIT)
    
    // 确保出口周围有路径
    this.ensureExitPath(exitX, exitY)
  }

  /**
   * 确保出口有路径
   */
  private ensureExitPath(exitX: number, exitY: number): void {
    // 检查出口周围是否有空地
    const directions: DirectionOffset[] = [
      { dx: 0, dy: -1 },
      { dx: 0, dy: 1 },
      { dx: -1, dy: 0 },
      { dx: 1, dy: 0 }
    ]

    let hasPath = false
    for (const dir of directions) {
      const newX = exitX + dir.dx
      const newY = exitY + dir.dy
      
      if (this.maze.isValidPosition(newX, newY) && 
          this.maze.getBlock(newX, newY) === BlockType.EMPTY) {
        hasPath = true
        break
      }
    }

    // 如果没有路径，随机打通一个方向
    if (!hasPath) {
      const randomDir = directions[Math.floor(Math.random() * directions.length)]
      const newX = exitX + randomDir.dx
      const newY = exitY + randomDir.dy
      
      if (this.maze.isValidPosition(newX, newY)) {
        this.maze.setBlock(newX, newY, BlockType.EMPTY)
      }
    }
  }

  /**
   * 添加可炸毁方块
   * 将大部分墙壁设为可炸毁（DESTRUCTIBLE），保留少部分为不可炸毁（INDESTRUCTIBLE）
   */
  private addDestructibleBlocks(): void {
    // 不可炸毁方块的比例（约25%，增加游戏难度）
    const indestructibleRatio = 0.25
    
    // 收集所有墙壁位置，排除入口和出口周围的格子
    const wallPositions: Position[] = []
    for (let y = 0; y < this.height; y++) {
      for (let x = 0; x < this.width; x++) {
        if (this.maze.getBlock(x, y) === BlockType.INDESTRUCTIBLE) {
          // 排除入口和出口周围的格子（确保玩家能移动）
          if (!this.isNearEntranceOrExit(x, y, 1)) {
            wallPositions.push({ x, y })
          }
        }
      }
    }
    
    // 随机打乱墙壁位置
    this.shuffleArray(wallPositions)
    
    // 计算要保留为不可炸毁的数量
    const indestructibleCount = Math.floor(wallPositions.length * indestructibleRatio)
    
    // 保留前 indestructibleCount 个为不可炸毁（橙色）
    // 这些位置保持 INDESTRUCTIBLE 不变
    
    // 其余的转换为可炸毁（黑色）
    for (let i = indestructibleCount; i < wallPositions.length; i++) {
      const pos = wallPositions[i]
      this.maze.setBlock(pos.x, pos.y, BlockType.DESTRUCTIBLE)
    }
    
    // 将入口和出口周围的墙壁设为可炸毁（确保玩家能移动）
    this.setDestructibleNearEntranceAndExit()
    
    console.log(`[MazeGenerator] 可选墙壁: ${wallPositions.length}, 不可炸毁: ${indestructibleCount}`)
  }
  
  /**
   * 将入口和出口周围的墙壁设为可炸毁
   */
  private setDestructibleNearEntranceAndExit(): void {
    const directions: DirectionOffset[] = [
      { dx: 0, dy: -1 },
      { dx: 0, dy: 1 },
      { dx: -1, dy: 0 },
      { dx: 1, dy: 0 }
    ]
    
    // 入口周围
    for (const dir of directions) {
      const x = this.maze.entrance.x + dir.dx
      const y = this.maze.entrance.y + dir.dy
      if (this.maze.isValidPosition(x, y) && 
          this.maze.getBlock(x, y) === BlockType.INDESTRUCTIBLE) {
        this.maze.setBlock(x, y, BlockType.DESTRUCTIBLE)
      }
    }
    
    // 出口周围
    for (const dir of directions) {
      const x = this.maze.exit.x + dir.dx
      const y = this.maze.exit.y + dir.dy
      if (this.maze.isValidPosition(x, y) && 
          this.maze.getBlock(x, y) === BlockType.INDESTRUCTIBLE) {
        this.maze.setBlock(x, y, BlockType.DESTRUCTIBLE)
      }
    }
  }
  
  /**
   * 检查是否靠近入口或出口
   * @param distance 距离阈值
   */
  private isNearEntranceOrExit(x: number, y: number, distance: number): boolean {
    const nearEntrance = Math.abs(x - this.maze.entrance.x) + Math.abs(y - this.maze.entrance.y) <= distance
    const nearExit = Math.abs(x - this.maze.exit.x) + Math.abs(y - this.maze.exit.y) <= distance
    return nearEntrance || nearExit
  }
  
  /**
   * 随机打乱数组
   */
  private shuffleArray<T>(array: T[]): void {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1))
      const temp = array[i]
      array[i] = array[j]
      array[j] = temp
    }
  }
  
  /**
   * 确保入口周围有可炸毁方块
   */
  private ensureDestructibleNearEntrance(): void {
    const entrance = this.maze.entrance
    const directions: DirectionOffset[] = [
      { dx: 0, dy: -1 },  // 上
      { dx: 0, dy: 1 },   // 下
      { dx: -1, dy: 0 },  // 左
      { dx: 1, dy: 0 }    // 右
    ]
    
    console.log(`[MazeGenerator] 入口位置: (${entrance.x}, ${entrance.y})`)
    
    // 打印入口周围的方块类型
    for (const dir of directions) {
      const x = entrance.x + dir.dx
      const y = entrance.y + dir.dy
      if (this.maze.isValidPosition(x, y)) {
        const block = this.maze.getBlock(x, y)
        console.log(`[MazeGenerator] 入口周围(${x},${y}): BlockType=${block}`)
      }
    }
    
    // 检查入口周围是否有可炸毁方块
    let hasDestructible = false
    for (const dir of directions) {
      const x = entrance.x + dir.dx
      const y = entrance.y + dir.dy
      if (this.maze.isValidPosition(x, y) && 
          this.maze.getBlock(x, y) === BlockType.DESTRUCTIBLE) {
        hasDestructible = true
        console.log(`[MazeGenerator] 发现入口周围有DESTRUCTIBLE: (${x},${y})`)
        break
      }
    }
    
    // 如果没有，强制将入口周围的一个 INDESTRUCTIBLE 方块设为 DESTRUCTIBLE
    if (!hasDestructible) {
      console.log(`[MazeGenerator] 入口周围没有DESTRUCTIBLE，尝试创建...`)
      for (const dir of directions) {
        const x = entrance.x + dir.dx
        const y = entrance.y + dir.dy
        if (this.maze.isValidPosition(x, y) && 
            this.maze.getBlock(x, y) === BlockType.INDESTRUCTIBLE) {
          this.maze.setBlock(x, y, BlockType.DESTRUCTIBLE)
          console.log(`[MazeGenerator] 已将(${x},${y})设为DESTRUCTIBLE`)
          break
        }
      }
    }
  }

  /**
   * 统计墙壁数量
   */
  private countWalls(): number {
    let count = 0
    for (let y = 0; y < this.height; y++) {
      for (let x = 0; x < this.width; x++) {
        if (this.maze.getBlock(x, y) === BlockType.INDESTRUCTIBLE) {
          count++
        }
      }
    }
    return count
  }

  /**
   * 验证路径可达性
   */
  private validatePath(): boolean {
    // 使用BFS算法验证从入口到出口是否有路径
    const visited: boolean[][] = []
    for (let y = 0; y < this.height; y++) {
      visited[y] = []
      for (let x = 0; x < this.width; x++) {
        visited[y][x] = false
      }
    }

    const queue: Position[] = [this.maze.entrance]
    visited[this.maze.entrance.y][this.maze.entrance.x] = true

    const directions: DirectionOffset[] = [
      { dx: 0, dy: -1 },
      { dx: 0, dy: 1 },
      { dx: -1, dy: 0 },
      { dx: 1, dy: 0 }
    ]

    while (queue.length > 0) {
      const current = queue.shift()!
      
      // 到达出口
      if (current.x === this.maze.exit.x && current.y === this.maze.exit.y) {
        return true
      }

      for (const dir of directions) {
        const newX = current.x + dir.dx
        const newY = current.y + dir.dy
        
        if (this.maze.isValidPosition(newX, newY) && !visited[newY][newX]) {
          const block = this.maze.getBlock(newX, newY)
          // 可以通过空地、入口、出口和可炸毁方块
          if (block === BlockType.EMPTY || 
              block === BlockType.ENTRANCE || 
              block === BlockType.EXIT ||
              block === BlockType.DESTRUCTIBLE) {
            visited[newY][newX] = true
            queue.push({ x: newX, y: newY })
          }
        }
      }
    }

    return false
  }

  /**
   * 获取入口位置
   */
  getEntrance(): Position {
    return this.maze.entrance
  }

  /**
   * 获取出口位置
   */
  getExit(): Position {
    return this.maze.exit
  }
}
