/**
 * 方块类型枚举
 */
export enum BlockType {
  EMPTY = 0,           // 空地
  INDESTRUCTIBLE = 1,  // 不可摧毁的方块
  DESTRUCTIBLE = 2,    // 可被炸毁的方块
  ENTRANCE = 3,        // 入口
  EXIT = 4             // 出口
}

/**
 * 方向枚举
 */
export enum Direction {
  UP = 0,     // 向上
  DOWN = 1,   // 向下
  LEFT = 2,   // 向左
  RIGHT = 3   // 向右
}

/**
 * 游戏状态枚举
 */
export enum GameState {
  READY = 0,      // 准备开始
  PLAYING = 1,    // 游戏进行中
  VICTORY = 2,    // 胜利
  GAME_OVER = 3   // 游戏结束
}
