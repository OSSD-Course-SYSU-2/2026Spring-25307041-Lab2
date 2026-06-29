<<<<<<< HEAD
# 迷宫小游戏

一个基于HarmonyOS开发的迷宫小游戏，支持角色移动和方块炸毁功能。

## 游戏特性

- 🎮 **随机迷宫生成**：使用Prim算法生成随机迷宫，每次游戏都是新体验
- 🧱 **两种方块类型**：
  - 不可摧毁的方块（深灰色）
  - 可被炸毁的方块（橙色）
- 🚶 **角色移动**：支持前后左右四个方向移动
- 💥 **方块炸毁**：可以一次性炸毁角色周围相邻一格内的所有可炸毁方块
- 🎯 **胜利条件**：从入口（蓝色）到达出口（绿色）
- 📱 **触摸控制**：5个屏幕按钮，适合手机操作

## 游戏玩法

1. **开始游戏**：点击任意控制按钮开始游戏
2. **移动角色**：
   - 点击 ↑ 按钮向上移动
   - 点击 ↓ 按钮向下移动
   - 点击 ← 按钮向左移动
   - 点击 → 按钮向右移动
3. **炸毁方块**：
   - 点击 💥 按钮炸毁角色周围相邻一格内的所有可炸毁方块
   - 可以同时炸毁上、下、左、右四个方向的可炸毁方块
   - 炸毁后的方块变为空地，角色可以移动到该位置
   - 只能炸毁橙色的可炸毁方块
   - 深灰色的不可摧毁方块无法炸毁
4. **到达出口**：从蓝色入口移动到绿色出口即可通关
5. **重新开始**：点击"重新开始"按钮重置游戏
6. 重新开始后会生成新的随机地图
且该程序可以在手机平板和手表上正常运行，考虑到手表比较小，程序在手表上可以上下滑动以保障按键足够大，而且这样还可以引出游戏的“盲走”玩法
<img width="612" height="1320" alt="b2bf996c5d20f828ffe6f53b54899cb" src="https://github.com/user-attachments/assets/a3cdd001-a82e-45b8-a4c8-e38ae2834c57" />
<img width="608" height="1336" alt="00b73a3da4cc38591993b96091d81b8" src="https://github.com/user-attachments/assets/489649d5-ee1c-46da-a10c-426da943749c" />
<img width="607" height="1328" alt="a1c2255915aa5e264e7676cf03d98be" src="https://github.com/user-attachments/assets/bddc24a3-d711-4db3-899e-c16717dac5a9" />
<img width="1196" height="732" alt="f497e7940d4ee0551fedbfc5dd105d3" src="https://github.com/user-attachments/assets/80f6c08d-e6b2-4d4c-9163-43d49474b5ac" />
<img width="598" height="1312" alt="24d78a8f0b91711956baa8bd9fb9907" src="https://github.com/user-attachments/assets/4f6578ad-2224-4525-910a-be2f93c1fbf8" />
<img width="564" height="661" alt="6f7296d02a123d7b9ef8bc1de4c3271" src="https://github.com/user-attachments/assets/7d7d047c-5c00-42d6-8e64-97bf03798b65" />
<img width="572" height="523" alt="b9b67de6e24f54c0949a6160d2c5bea" src="https://github.com/user-attachments/assets/d5a3d3e2-be00-4e72-ae11-aa99ba680d5c" />

