/**
 * 游戏配置类
 */
export class GameConfig {
  // 迷宫尺寸
  static readonly MAZE_WIDTH: number = 15
  static readonly MAZE_HEIGHT: number = 15
  
  // 方块尺寸
  static readonly BLOCK_SIZE: number = 30
  
  // 可炸毁方块比例
  static readonly DESTRUCTIBLE_RATIO: number = 0.3
  
  // 动画时长（毫秒）
  static readonly MOVE_DURATION: number = 200
  static readonly DESTROY_DURATION: number = 300
  
  // 颜色配置
  static readonly COLOR_EMPTY: string = '#FFFFFF'        // 白色 - 可通过
  static readonly COLOR_INDESTRUCTIBLE: string = '#FF8C00' // 橙色 - 不可通过，不可炸毁
  static readonly COLOR_DESTRUCTIBLE: string = '#4A4A4A'   // 黑色 - 不可通过，可炸毁
  static readonly COLOR_ENTRANCE: string = '#4169E1'     // 蓝色 - 入口
  static readonly COLOR_EXIT: string = '#32CD32'         // 绿色 - 出口
  static readonly COLOR_PLAYER: string = '#FF0000'       // 红色 - 玩家
  
  // 按钮尺寸配置
  static readonly BUTTON_SIZE: number = 60        // 默认按键尺寸
  static readonly MIN_TOUCH_SIZE: number = 44     // 最小触摸尺寸
  static readonly BUTTON_SIZE_TABLET: number = 80 // 平板按键尺寸
  static readonly BUTTON_SIZE_PHONE: number = 60  // 手机按键尺寸
  static readonly BUTTON_SPACING: number = 20     // 按键间距
}
