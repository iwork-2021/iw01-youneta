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
* 竖屏  
![竖屏界面](https://raw.githubusercontent.com/iwork-2021/iw01-youneta/main/screenhot/2.png)
* 横屏  
![横屏界面](https://raw.githubusercontent.com/iwork-2021/iw01-youneta/main/screenhot/3.png)

***
## 实现细节
### 1. MVC设计模式
MVC即Model-View-Controller，model用于存储字段，view实现UI而不涉及数据操作和业务逻辑的操作，controller顾名思义控制UI和数据的通信以及逻辑的实现。
在这个项目里，只有一个`viewController`，主要视图由一个计算器显示屏header和因横竖屏切换而改变的按键视图构成。
#### Model
model其实只起到存储数据的作用，对于数据的简单操作则可以另外实现一个该model类的`category`来完成。
controller持有model，而view则不涉及与model有关的任何操作。
``` Objective-C
@interface calculateModel : UIView

@property (nonatomic, strong) NSString *resultString;
@property (nonatomic, strong) NSString *ans;
@property (nonatomic, strong) NSString *operationString;
@property (nonatomic, strong) NSString *memoryString;
@property (nonatomic) BOOL memoryFlag;
@property (nonatomic) calculatorButtonType lastPressButtonType;

- (void)setupModel; //重置model的方法

@end
```

### View
view只实现UI而不涉及数据操作，将根据数据更新UI的方法作为接口暴露出去（例如`headerView`中的`updateResultStringLabel:(NSString *)text`方法），由`controller`来控制调用更新UI。
* portraitView/landscapeView
  对应在竖屏/横屏状态下的按键视图。两个view其实非常相似，都由`collectionView`来布局，区别在于横竖屏的不同，`collectionView`的`cell`的个数、展示label的text等也会不同。
  在后续总结的时候发现这两个view过于相似，其实可以优化成一个工厂模式，根据横竖屏来生产`cell`不同的按键视图。
* headerView
  
#### (view)Controller
(1). 管理UI  
   * 在设置自动布局时，令`header`的`left`和`right`都设置为与`viewController.view`的对应属性对齐，因此在横竖屏切换、`viewController`的frame发生改变时`header`的frame也会随之变化，以保持整体视图的对齐。
``` Objective-C
//viewController.m - setupUI  
    NSLayoutConstraint *headerViewTop = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];  
    NSLayoutConstraint *headerViewHeight = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.33 constant:0]; //结果显示区的高度占屏幕1/3  
    NSLayoutConstraint *headerViewLeft = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];  
    NSLayoutConstraint *headerViewRight = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];  
    [self.view addConstraints:@[headerViewTop, headerViewHeight, headerViewLeft, headerViewRight]];  
```
   * 关于按键视图，由于用了两个view来分别展示在横屏和竖屏状态下的按键视图，在横竖屏切换的相关生命周期函数（`- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation`）中，根据当前屏幕方向设置对应的view的hidden属性。
   * 在设置约束前提前计算出横竖屏下横竖屏按键视图的正确宽高，然后在设置约束的时候直接设置好正确的约束。这里其实是偷了个懒，虽然可以更加简便地将`left`、`bottom`、`right`和`viewController.view`的相应属性对齐，`top`与`header`的`bottom`对齐，之所以没有这么设置约束的主要原因在于横竖屏按键视图的内部实现使用了`UICollectionView`来布局，在`collectionView`的`frame`发生改变时，`cell`的`frame`因为使用的`dataSource`的代理获取初始化的`size`而没有使用自动布局，因此`cell`的`frame`没有改变导致布局混乱。若要在旋转改变`collectionView`的`frame`后正确修改`cell`的`size`来使布局回归正确，需要主动重新修改`collectionView`的`contentSize`等属性，相较于一劳永逸地在初始化的时候就将`collectionView`的`frame`写死为正确的宽高值的方法相比更为麻烦。但是显然，这样写死`frame`的做法其实某种意义上是一种hard code。
``` Objective-C
    CGFloat realHeight = self.view.frame.size.height > self.view.frame.size.width ? self.view.frame.size.height : self.view.frame.size.width;
    CGFloat realWidth = self.view.frame.size.height < self.view.frame.size.width ? self.view.frame.size.height : self.view.frame.size.width;
    NSLayoutConstraint *portraitViewTop = [NSLayoutConstraint constraintWithItem:self.portraitView   attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *portraitViewHeight = [NSLayoutConstraint constraintWithItem:self.portraitView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:(realHeight * 0.67)];
    NSLayoutConstraint *portraitViewLeft = [NSLayoutConstraint constraintWithItem:self.portraitView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *portraitViewWidth = [NSLayoutConstraint constraintWithItem:self.portraitView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:realWidth];
    [self.view addConstraints:@[portraitViewTop, portraitViewHeight, portraitViewLeft, portraitViewWidth]];  
    
    NSLayoutConstraint *landscapeViewTop = [NSLayoutConstraint constraintWithItem:self.landscapeView   attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *landscapeViewHeight = [NSLayoutConstraint constraintWithItem:self.landscapeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:realWidth * 0.67];
    NSLayoutConstraint *landscapeViewLeft = [NSLayoutConstraint constraintWithItem:self.landscapeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *landscapeViewWidth = [NSLayoutConstraint constraintWithItem:self.landscapeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:realHeight];
    [self.view addConstraints:@[landscapeViewTop, landscapeViewHeight, landscapeViewLeft, landscapeViewWidth]];

```  
(2). 业务逻辑
(3). model与view之间的通信
### 2. 计算逻辑实现
