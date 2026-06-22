import { Direction, GameState } from '../models/Enums'
import { MazeData } from '../models/MazeData'
import { PlayerData } from '../models/PlayerData'
import { GameEngine } from '../controllers/GameEngine'
import { MazeView } from '../components/MazeView'
import { ControlPanel } from '../components/ControlPanel'
import { StatusDisplay } from '../components/StatusDisplay'
import { GameConfig } from '../models/GameConfig'
import { display } from '@kit.ArkUI'

/**
 * 主页面
 */
@Entry
@Component
@Preview({
  title: '主页面 - 默认预览',
  deviceType: 'phone',
  width: 1080,
  height: 2340,
  colorMode: 'light',
  dpi: 480,
  locale: 'zh_CN',
  orientation: 'portrait',
  roundScreen: false
})
struct MainPage {
  @State gameState: GameState = GameState.READY
  @State mazeData: MazeData = new MazeData(GameConfig.MAZE_WIDTH, GameConfig.MAZE_HEIGHT)
  @State playerData: PlayerData = new PlayerData()
  @State blockSize: number = GameConfig.BLOCK_SIZE
  @State buttonSize: number = GameConfig.BUTTON_SIZE  // 按键尺寸
  @State updateKey: number = 0  // 用于强制刷新 MazeView
  
  private gameEngine: GameEngine = new GameEngine()

  aboutToAppear() {
    // 初始化游戏引擎
    this.gameEngine.initialize()
    
    // 获取初始数据
    this.mazeData = this.gameEngine.getMazeData()
    this.playerData = this.gameEngine.getPlayerData()
    this.gameState = this.gameEngine.getGameState()
    
    // 计算方块尺寸
    this.calculateBlockSize()
    
    // 计算按键尺寸
    this.calculateButtonSize()
  }

  build() {
    // 使用Scroll实现可滚动布局，按键在最底部不遮挡地图
    Scroll() {
      Column() {
        // 标题栏
        this.TitleBar()
        
        // 迷宫视图
        MazeView({
          mazeData: this.mazeData,
          playerData: this.playerData,
          blockSize: this.blockSize,
          updateKey: this.updateKey
        })
        .margin({ top: 20 })
        
        // 状态显示
        StatusDisplay({
          gameState: this.gameState
        })
        .margin({ top: 20, left: 20, right: 20 })
        
        // 控制面板
        ControlPanel({
          onMove: (direction: Direction) => {
            this.handleMove(direction)
          },
          onDestroy: () => {
            this.handleDestroy()
          },
          buttonSize: this.buttonSize
        })
        .margin({ top: 30 })
        
        // 重新开始按钮
        Button('重新开始')
          .width(150)
          .height(50)
          .fontSize(18)
          .backgroundColor('#FF6347')
          .fontColor(Color.White)
          .borderRadius(10)
          .margin({ top: 20, bottom: 30 })
          .onClick(() => {
            this.handleReset()
          })
      }
      .width('100%')
      .backgroundColor('#F5F5F5')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)  // 隐藏滚动条
    .edgeEffect(EdgeEffect.Spring)  // 滚动边缘效果
  }

  /**
   * 标题栏
   */
  @Builder TitleBar() {
    Row() {
      Text('迷宫小游戏')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFF')
    .shadow({
      radius: 5,
      color: '#CCCCCC',
      offsetX: 0,
      offsetY: 2
    })
  }

  /**
   * 处理移动
   */
  private handleMove(direction: Direction): void {
    // 如果游戏未开始，先开始游戏
    if (this.gameState === GameState.READY) {
      this.gameEngine.startGame()
      this.gameState = GameState.PLAYING
    }
    
    // 执行移动
    const success = this.gameEngine.handleMove(direction)
    
    if (success) {
      // 更新玩家数据
      this.playerData = this.gameEngine.getPlayerData()
      
      // 检查游戏状态
      const newGameState = this.gameEngine.getGameState()
      if (newGameState === GameState.VICTORY) {
        this.gameState = GameState.VICTORY
        // 显示胜利提示
        setTimeout(() => {
          this.showVictoryDialog()
        }, 100)
      }
    }
  }

  /**
   * 处理炸毁
   */
  private handleDestroy(): void {
    // 如果游戏未开始，先开始游戏
    if (this.gameState === GameState.READY) {
      this.gameEngine.startGame()
      this.gameState = GameState.PLAYING
    }
    
    // 调试：打印玩家位置周围的方块类型
    const playerPos = this.playerData.position
    console.log(`[Destroy] 玩家位置: (${playerPos.x}, ${playerPos.y})`)
    
    // 检查四个方向的方块类型
    const dx = [0, 0, -1, 1]
    const dy = [-1, 1, 0, 0]
    const dirNames = ['上', '下', '左', '右']
    
    for (let i = 0; i < 4; i++) {
      const x = playerPos.x + dx[i]
      const y = playerPos.y + dy[i]
      if (this.mazeData.isValidPosition(x, y)) {
        const block = this.mazeData.getBlock(x, y)
        console.log(`[Destroy] ${dirNames[i]}方(${x},${y}): BlockType=${block}`)
      }
    }
    
    // 执行炸毁
    const success = this.gameEngine.handleDestroy()
    console.log(`[Destroy] 炸毁结果: ${success}`)
    
    if (success) {
      // 强制触发状态更新：深拷贝 mazeData
      const oldMazeData = this.gameEngine.getMazeData()
      const newMazeData = new MazeData(oldMazeData.width, oldMazeData.height)
      // 深拷贝 grid 数组
      for (let y = 0; y < oldMazeData.height; y++) {
        for (let x = 0; x < oldMazeData.width; x++) {
          newMazeData.setBlock(x, y, oldMazeData.getBlock(x, y))
        }
      }
      newMazeData.entrance = oldMazeData.entrance
      newMazeData.exit = oldMazeData.exit
      // 重新赋值触发 @State 更新
      this.mazeData = newMazeData
      // 更新 updateKey 强制刷新 MazeView
      this.updateKey++
      console.log(`[Destroy] UI 已更新, updateKey=${this.updateKey}`)
    }
  }

  /**
   * 处理重置
   */
  private handleReset(): void {
    // 重置游戏
    this.gameEngine.resetGame()
    
    // 更新所有状态数据
    this.mazeData = this.gameEngine.getMazeData()
    this.playerData = this.gameEngine.getPlayerData()
    this.gameState = this.gameEngine.getGameState()
    this.updateKey++  // 强制刷新
  }

  /**
   * 计算方块尺寸（自适应屏幕）
   */
  private calculateBlockSize(): void {
    try {
      // 获取屏幕宽度并转换为 vp 单位
      const displayInfo = display.getDefaultDisplaySync()
      const screenWidth = px2vp(displayInfo.width)
      const margin = 40 // 左右边距
      const availableWidth = screenWidth - margin
      
      // 计算方块尺寸
      this.blockSize = Math.floor(availableWidth / this.mazeData.width)
      
      console.log(`[MainPage] 屏幕宽度: ${screenWidth}vp, 方块尺寸: ${this.blockSize}`)
    } catch (error) {
      // 使用默认值
      console.error(`[MainPage] 获取屏幕尺寸失败`)
      this.blockSize = 24
    }
    
    // 限制最小和最大尺寸（适应不同设备）
    if (this.blockSize < 15) {
      this.blockSize = 15
    } else if (this.blockSize > 50) {
      this.blockSize = 50
    }
  }

  /**
   * 计算按键尺寸（自适应设备）
   */
  private calculateButtonSize(): void {
    try {
      // 获取屏幕宽度并转换为 vp 单位
      const displayInfo = display.getDefaultDisplaySync()
      const screenWidth = px2vp(displayInfo.width)
      
      // 根据屏幕宽度判断设备类型
      if (screenWidth >= 600) {
        // 平板设备
        this.buttonSize = GameConfig.BUTTON_SIZE_TABLET  // 80
      } else {
        // 手机设备
        this.buttonSize = GameConfig.BUTTON_SIZE_PHONE   // 60
      }
      
      console.log(`[MainPage] 屏幕宽度: ${screenWidth}vp, 按键尺寸: ${this.buttonSize}`)
    } catch (error) {
      // 使用默认值
      console.error(`[MainPage] 获取屏幕尺寸失败，使用默认按键尺寸`)
      this.buttonSize = GameConfig.BUTTON_SIZE
    }
    
    // 确保不小于最小触摸尺寸
    if (this.buttonSize < GameConfig.MIN_TOUCH_SIZE) {
      this.buttonSize = GameConfig.MIN_TOUCH_SIZE
    }
  }

  /**
   * 显示胜利对话框
   */
  private showVictoryDialog(): void {
    AlertDialog.show({
      title: '🎉 恭喜通关！',
      message: '你成功走出了迷宫！',
      confirm: {
        value: '再玩一次',
        action: () => {
          this.handleReset()
        }
      }
    })
  }
}
