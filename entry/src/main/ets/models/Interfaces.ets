import { Direction, GameState, BlockType } from './Enums'

/**
 * 位置接口
 */
export interface Position {
  x: number
  y: number
}

/**
 * 方向偏移量接口
 */
export interface DirectionOffset {
  dx: number
  dy: number
}

/**
 * 游戏事件接口
 */
export interface GameEvent {
  type: string
  data: string | number | boolean | object | null
  timestamp: number
}

/**
 * 游戏控制器接口
 */
export interface IGameController {
  initialize(): void
  startGame(): void
  resetGame(): void
  getGameState(): GameState
}

/**
 * 移动控制器接口
 */
export interface IMovementController {
  move(direction: Direction): boolean
  canMove(direction: Direction): boolean
}

/**
 * 炸毁控制器接口
 */
export interface IDestroyController {
  destroy(): boolean
  canDestroy(): boolean
}
