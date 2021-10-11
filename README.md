[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=5761906&assignment_repo_type=AssignmentRepo)
# iw01-youneta
iw01-youneta created by GitHub Classroom
# 计算器MyCalculator
## 作业要求：
1. 功能齐全，乱按也可（不会崩溃或得到乱七八糟的结果）
2. 界面风格不限，粉色、绿色、各种主题都可，请尽量发挥想象
3. 参考[实践视频](https://www.bilibili.com/video/BV1Yr4y1c7HW)，实现`Calculator`类作为模型，仔细体会MVC模式的优点
4. 用Markdown编写项目文档，并展示运行截屏

***

## 实现UI展示

![竖屏界面](https://raw.githubusercontent.com/iwork-2021/iw01-youneta/main/screenhot/2.png)
![横屏界面](https://raw.githubusercontent.com/iwork-2021/iw01-youneta/main/screenhot/3.png)

***
## 实现细节
### MVC设计模式
MVC即Model-View-Controller，model用于存储字段，view实现UI而不涉及数据操作和业务逻辑的操作，controller顾名思义控制UI和数据的通信以及逻辑的实现。
在这个项目里，只有一个`viewController`，主要视图由一个计算器显示屏header和因横竖屏切换而改变的按键视图构成。
#### (view)Controller
* 管理UI
** 在设置自动布局时，令`header`的`left`和`right`都设置为与`viewController.view`的对应属性对齐，因此在横竖屏切换、`viewController`的frame发生改变时`header`的frame也会随之变化，以保持整体视图的对齐。
> //viewController.m - setupUI
> &emsp; NSLayoutConstraint *headerViewTop = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];  
> &emsp; NSLayoutConstraint *headerViewHeight = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.33 constant:0]; //结果显示区的高度占屏幕1/3  
> &emsp; NSLayoutConstraint *headerViewLeft = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];  
> &emsp; NSLayoutConstraint *headerViewRight = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];  
> &emsp; [self.view addConstraints:@[headerViewTop, headerViewHeight, headerViewLeft, headerViewRight]];  

** 关于按键视图，由于用了两个view来分别展示在横屏和竖屏状态下的按键视图，在横竖屏切换的相关生命周期函数（`- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation`）中，根据当前屏幕方向设置对应的view的hidden属性。
### 计算逻辑实现
