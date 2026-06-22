# 迷宫游戏更新说明

## 更新时间
2026-06-09

## 更新内容

### 炸毁功能优化

#### 原功能
- 只能炸毁角色前方的单个可炸毁方块
- 需要根据角色面向方向确定炸毁位置

#### 新功能
- **范围炸毁**：一次性炸毁角色周围相邻一格内的所有可炸毁方块
- **四方向检测**：自动检测上、下、左、右四个方向的可炸毁方块
- **批量处理**：同时炸毁多个方块，提高游戏效率
- **智能判断**：只有周围存在可炸毁方块时才能执行炸毁操作

### 技术实现

#### 修改文件
- `DestroyController.ets` - 炸毁控制器

#### 核心逻辑
```typescript
// 获取周围所有可炸毁的方块位置
private getDestroyTargets(): Position[] {
  const currentX = this.playerData.position.x
  const currentY = this.playerData.position.y
  const targets: Position[] = []
  
  // 检查四个方向的相邻方块
  const directions = [
    { dx: 0, dy: -1 },  // 上
    { dx: 0, dy: 1 },   // 下
    { dx: -1, dy: 0 },  // 左
    { dx: 1, dy: 0 }    // 右
  ]
  
  for (const dir of directions) {
    const newX = currentX + dir.dx
    const newY = currentY + dir.dy
    
    // 检查位置是否有效且为可炸毁方块
    if (this.mazeData.isValidPosition(newX, newY)) {
      const blockType = this.mazeData.getBlock(newX, newY)
      if (blockType === BlockType.DESTRUCTIBLE) {
        targets.push({ x: newX, y: newY })
      }
    }
  }
  
  return targets
}
```

### 游戏体验改进

1. **更高效的开路方式**
   - 一次炸毁可以开辟多条路径
   - 减少重复操作，提高游戏流畅度

2. **更直观的操作**
   - 不需要考虑角色面向方向
   - 只需站在合适位置点击炸毁按钮

3. **更灵活的策略**
   - 可以一次性清除周围的障碍
   - 增加了游戏的策略性和趣味性

### 使用示例

**场景1：十字路口**
```
■ ■ ■ ■ ■
■ □ □ □ ■
■ □ P □ ■
■ □ □ □ ■
■ ■ ■ ■ ■
```
- P为玩家位置
- 如果四个□都是可炸毁方块
- 点击炸毁按钮，四个方块同时被炸毁

**场景2：单侧障碍**
```
■ ■ ■ ■ ■
■ □ P ■ ■
■ ■ ■ ■ ■
```
- 只有左侧有可炸毁方块
- 点击炸毁按钮，只炸毁左侧方块

### 兼容性

- ✅ 完全兼容现有游戏逻辑
- ✅ 不影响移动、胜利判定等其他功能
- ✅ 保持原有的游戏平衡性

### 后续优化建议

1. 添加炸毁动画效果
2. 添加炸毁音效
3. 显示炸毁范围提示
4. 添加炸毁次数限制（可选）

---

**版本**：v1.1  
**更新类型**：功能优化  
**影响范围**：炸毁功能
