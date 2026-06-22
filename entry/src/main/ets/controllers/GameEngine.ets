import { Direction, GameState } from '../models/Enums'
import { MazeData } from '../models/MazeData'
import { PlayerData } from '../models/PlayerData'
import { MazeGenerator } from './MazeGenerator'
import { MovementController } from './MovementController'
import { DestroyController } from './DestroyController'
import { IGameController } from '../models/Interfaces'

/**
 * 游戏引擎
 */
export class GameEngine implements IGameController {
  private mazeData: MazeData
  private playerData: PlayerData
  private gameState: GameState
  private mazeGenerator: MazeGenerator
  private movementController: MovementController
  private destroyController: DestroyController

  constructor() {
    this.gameState = GameState.READY
    this.mazeData = new MazeData(15, 15)
    this.playerData = new PlayerData()
    this.mazeGenerator = new MazeGenerator()
    this.movementController = new MovementController(this.mazeData, this.playerData)
    this.destroyController = new DestroyController(this.mazeData, this.playerData)
  }

  /**
   * 初始化游戏
   */
  initialize(): void {
    // 生成迷宫
    this.mazeData = this.mazeGenerator.generate()
    
    // 创建玩家数据，设置初始位置为入口
    const entrance = this.mazeData.entrance
    this.playerData = new PlayerData(entrance.x, entrance.y)
    
    // 创建控制器
    this.movementController = new MovementController(this.mazeData, this.playerData)
    this.destroyController = new DestroyController(this.mazeData, this.playerData)
    
    // 设置游戏状态为准备开始
    this.gameState = GameState.READY
  }

  /**
   * 开始游戏
   */
  startGame(): void {
    this.gameState = GameState.PLAYING
  }

  /**
   * 重置游戏
   */
  resetGame(): void {
    // 重新生成迷宫
    this.mazeData = this.mazeGenerator.generate()
    
    // 重置玩家位置
    const entrance = this.mazeData.entrance
    this.playerData = new PlayerData(entrance.x, entrance.y)
    
    // 重新创建控制器
    this.movementController = new MovementController(this.mazeData, this.playerData)
    this.destroyController = new DestroyController(this.mazeData, this.playerData)
    
    // 设置游戏状态为准备开始
    this.gameState = GameState.READY
  }

  /**
   * 处理移动
   */
  handleMove(direction: Direction): boolean {
    // 检查游戏状态
    if (this.gameState !== GameState.PLAYING) {
      return false
    }

    // 执行移动
    const success = this.movementController.move(direction)
    
    // 检查胜利条件
    if (success) {
      this.checkVictory()
    }

    return success
  }

  /**
   * 处理炸毁
   */
  handleDestroy(): boolean {
    // 检查游戏状态
    if (this.gameState !== GameState.PLAYING) {
      return false
    }

    // 执行炸毁
    return this.destroyController.destroy()
  }

  /**
   * 检查胜利条件
   */
  private checkVictory(): boolean {
    // 比较玩家位置和出口位置
    if (this.playerData.position.x === this.mazeData.exit.x &&
        this.playerData.position.y === this.mazeData.exit.y) {
      this.gameState = GameState.VICTORY
      return true
    }
    return false
  }

  /**
   * 获取游戏状态
   */
  getGameState(): GameState {
    return this.gameState
  }

  /**
   * 获取迷宫数据
   */
  getMazeData(): MazeData {
    return this.mazeData
  }

  /**
   * 获取玩家数据
   */
  getPlayerData(): PlayerData {
    return this.playerData
  }
}
