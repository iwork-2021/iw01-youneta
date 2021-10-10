//
//  ViewController.m
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/8.
//  Copyright © 2021年 cxx. All rights reserved.
//

#import "ViewController.h"
#import "portraitView.h"
#import "landscapeView.h"
#import "headerView.h"
#import "calculateManager.h"
#import "calculateModel.h"
@interface ViewController ()
@property (nonatomic, strong) portraitView *portraitView;
@property (nonatomic, strong) landscapeView *landscapeView;
@property (nonatomic, strong) headerView *headerView;
@property (nonatomic, strong) calculateModel *model;
@end

@implementation ViewController

#pragma mark *** life cycle ***

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.portraitView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.landscapeView];
    [self setupUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** rotate ***
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.view.hidden = YES;
}

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
//    [self setupUI];
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
}

#pragma mark *** setupUI ***
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.portraitView.translatesAutoresizingMaskIntoConstraints = NO;
    self.landscapeView.translatesAutoresizingMaskIntoConstraints = NO;
    //设置自动布局
//    NSArray *constraints = self.view.constraints;
//    [self.view removeConstraints:constraints];
    CGFloat realHeight = self.view.frame.size.height > self.view.frame.size.width ? self.view.frame.size.height : self.view.frame.size.width;
    CGFloat realWidth = self.view.frame.size.height < self.view.frame.size.width ? self.view.frame.size.height : self.view.frame.size.width;
    
    NSLayoutConstraint *headerViewTop = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *headerViewHeight = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.33 constant:0]; //结果显示区的高度占屏幕1/3
    NSLayoutConstraint *headerViewLeft = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *headerViewRight = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraints:@[headerViewTop, headerViewHeight, headerViewLeft, headerViewRight]];
    
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
    
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
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
    
//    newConstraints =  self.view.constraints;
}

#pragma mark *** toast ***
- (void)_showAlert:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:conform];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark *** gettter ***
- (portraitView *) portraitView {
    if(!_portraitView) {
        _portraitView = [[portraitView alloc] init];
        //回调block赋值
        __weak typeof(self) weakSelf = self; //防止block中的循环引用
        _portraitView.buttonDidClickBlock = ^(NSInteger x, NSInteger y) {
            NSString *result = [[calculateManager sharedInstance] handlePortraitOperationAtSection:x atRow:y model:weakSelf.model];
            if(![result isEqualToString:@""]) {
                [weakSelf _showAlert:result];
            }
            [weakSelf.headerView updateResultLabelText:weakSelf.model.resultString];
            [weakSelf.headerView updateOperationLabelText:weakSelf.model.operationString];
        };
    }
    return _portraitView;
}

- (landscapeView *) landscapeView {
    if(!_landscapeView) {
        _landscapeView = [[landscapeView alloc] init];
        //回调block赋值
        __weak typeof(self) weakSelf = self;
        _landscapeView.buttonDidClickBlock = ^(NSInteger x, NSInteger y) {
            NSString *result = [[calculateManager sharedInstance] handleLandscapeOperationAtSection:x atRow:y model:weakSelf.model];
            if(![result isEqualToString:@""]) {
                [weakSelf _showAlert:result];
            }
            [weakSelf.headerView updateResultLabelText:weakSelf.model.resultString];
            [weakSelf.headerView updateOperationLabelText:weakSelf.model.operationString];
        };
    }
    return _landscapeView;
}

- (headerView *)headerView {
    if(!_headerView) {
        _headerView = [[headerView alloc]init];
        _headerView.backgroundColor = [UIColor blackColor];
    }
    return _headerView;
}

- (calculateModel *)model {
    if(!_model) {
        _model = [[calculateModel alloc]init];
    }
    return _model;
}

@end
