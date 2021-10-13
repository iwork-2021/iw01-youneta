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

#### View
view只实现UI而不涉及数据操作，将根据数据更新UI的方法作为接口暴露出去（例如`headerView`中的`updateResultStringLabel:(NSString *)text`方法），由`controller`来控制调用更新UI。
* portraitView/landscapeView
  对应在竖屏/横屏状态下的按键视图。两个view其实非常相似，都由`collectionView`来布局，区别在于横竖屏的不同，`collectionView`的`cell`的个数、展示label的text等也会不同。
  这里还定义了一个点击回调的block`buttonDidClickBlock`，在`viewController`中赋值，在按钮点击响应方法(`didSelectItemAtIndexPath`)中调用这个block来回调到vc中做相应的操作。
```Objective-C
  @property (nonatomic, strong) void(^buttonDidClickBlock)(NSInteger x, NSInteger y);
```
  在后续总结的时候发现这两个view过于相似，其实可以优化成一个工厂模式，根据横竖屏来生产`cell`不同的按键视图。
  
  
* headerView
  这个视图是计算器的上方结果显示视图，由几个`label`（显示结果、"M"标志、计算符号显示等）构成，内部的布局约束：
``` Objective-C
// headerView.m 
  - (void)setupUI {
    //自动布局设置
    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *resultLabelTop = [NSLayoutConstraint constraintWithItem:self.resultLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *resultLabelBottom = [NSLayoutConstraint constraintWithItem:self.resultLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *resultLabelLeft = [NSLayoutConstraint constraintWithItem:self.resultLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *resultLabelRight = [NSLayoutConstraint constraintWithItem:self.resultLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-50];
    
    [self addConstraints:@[resultLabelTop, resultLabelLeft, resultLabelRight, resultLabelBottom]];

    self.memoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *memoryLabelTop = [NSLayoutConstraint constraintWithItem:self.memoryLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *memoryLabelHeight = [NSLayoutConstraint constraintWithItem:self.memoryLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    NSLayoutConstraint *memoryLabelLeft = [NSLayoutConstraint constraintWithItem:self.memoryLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.resultLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *memoryLabelRight = [NSLayoutConstraint constraintWithItem:self.memoryLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self addConstraints:@[memoryLabelTop, memoryLabelLeft, memoryLabelRight, memoryLabelHeight]];
    
    self.operatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *operatorLabelTop = [NSLayoutConstraint constraintWithItem:self.operatorLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.memoryLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *operatorLabelBottom = [NSLayoutConstraint constraintWithItem:self.operatorLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *operatorLabelLeft = [NSLayoutConstraint constraintWithItem:self.operatorLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.resultLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *operatorLabelRight = [NSLayoutConstraint constraintWithItem:self.operatorLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self addConstraints:@[operatorLabelTop, operatorLabelLeft, operatorLabelRight, operatorLabelBottom]];
    
}
```
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
在横竖屏旋转的生命周期函数中，根据当前屏幕方向来修改可见的视图：
``` Objective-C
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.view.hidden = NO;
    switch ([[UIApplication sharedApplication]statusBarOrientation]) {
        case UIInterfaceOrientationPortrait:
            self.landscapeView.hidden = YES;
            self.portraitView.hidden = NO;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.landscapeView.hidden = YES;
            self.portraitView.hidden = NO;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            self.landscapeView.hidden = NO;
            self.portraitView.hidden = YES;
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.landscapeView.hidden = NO;
            self.portraitView.hidden = YES;
            break;
        default:
            self.landscapeView.hidden = YES;
            self.portraitView.hidden = YES;
            break;
    }
}
```
(3). model与view之间的通信  
在`portraitView`和`landscapeView`初始化的时候，给block赋值：
``` Objective-C
    //回调block赋值
    __weak typeof(self) weakSelf = self;
    _landscapeView.buttonDidClickBlock = ^(NSInteger x, NSInteger y) {
    NSString *result = [[calculateManager sharedInstance] handleLandscapeOperationAtSection:x atRow:y model:weakSelf.model];
    if(![result isEqualToString:@""]) {
        [weakSelf _showAlert:result];
    }
    [weakSelf.headerView updateResultLabelText:weakSelf.model.resultString];
    [weakSelf.headerView updateOperationLabelText:weakSelf.model.operationString];
    [weakSelf.headerView displayMemoryLabelText:weakSelf.model.memoryFlag];
};
```
在block中根据model的改变调用`headerView`的对应更新UI的方法。  
而对于因为UI变化引起的数据变化（例如点击计算器的按钮导致`header`的显示`label`发生变化，这里通过在按钮点击响应回调block中调用`[[calculateManager sharedInstance] handleLandscapeOperationAtSection:x atRow:y model:weakSelf.model]`（这里`calculateManager`是封装的一个根据当前`model`数据和点击的按钮来进行相应输出结果计算和处理的工具类）。


### 2. 计算逻辑实现
这一块主要是放在工具类`calculateManager`中实现。  
这里将其设置为一个单例模式，开放接口`sharedManager`来供调用。
这里我在`model`中保存了一个字段`lastOperation`，这个字段实际上起到的就是一个状态机状态划分的作用。
状态有：`number`（数字键0~9）、`SingleNumber`(pi,e,mr)、`BinaryOperator`(二元运算符)、`UnaryOperator`（一元运算符）、`Default`（初始状态、点击AC之后的状态）。
`currentOperation`则是在点击按钮的响应回调中传入的本次点击的按钮。
这里给出了在设计时的状态map：
| currentOperation(op) \  lastOperation(last_op) | Number(0~9) | SingleNumber(pi,e,mr) | BinaryOperator | UnaryOperator | Default |
| --- | --- | --- | --- | --- | --- |
| Numebr(0~9) | 1. if(res=0): res = op;  2. else: res.append(op) | res = op; | ans = res; res = op; | model.reset();  res=op; | res = op; |
| SingleNumber(pi,e,mr) |
| BinaryOperator |
| UnaryOperator |
| Default |


### 3. 总结反思
1. 先说说我觉得这个项目最大的不足之处，在于计算精度的问题。因为机器码保存浮点数并非是绝对精确的，这就导致了计算结果也未必绝对精确，而且默认状态是保留6位小数，这使得涉及小数的运算都存在一定的误差。而且由于计算都是用double类型来操作，而显示结果则是用`[NSString stringWithFormat:@"%f",result]`来显示转换，导致整数结果也会显示小数点。这里是我觉得整个项目做下来最大的不足。但是我大胆认为这个作业的重点并不在这块而在于MVC设计模式，因此这块我并没有花时间去优化而把主要精力放在MVC模式的设计上。  
2. 第二个存在的问题我认为是在计算逻辑这块，对于整个状态机的状态的划分还是欠缺更加科学、优质的考虑，在实现的过程中逐渐发现有些状态可以合并（例如初始状态和点击了`AC`键之后的状态）、有些状态没必要区分（例如缓存操作`m+`、`m-`、`mc`，这几个操作不会影响其他操作）等等，在设计状态机之初对于这块的思考还是太过急躁粗糙。  

总的来说我认为是一次收获颇多的作业。之所以没有用`swift`语言写而是用`Objective-C`来写，是因为在之前接触了解过OC，对OC的语法以及特性较为熟悉，在后面的作业中对`swift`的掌握更加深入之后会考虑转用`swift`来写。关于没有用`storyboard`来写UI而是采用了纯代码的方式来实现，这里主要是觉得代码控制更加流畅便捷，固然`storyboard`十分直观，但自己实际体验起来反而觉得有点束手束脚，也可以说是个人兴趣原因了。
