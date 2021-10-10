//
//  headerView.m
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/8.
//  Copyright © 2021年 cxx. All rights reserved.
//

#import "headerView.h"

@interface headerView() 

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *operatorLabel;
@property (nonatomic, strong) UILabel *memoryLabel;

@end

@implementation headerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark *** init *** 

- (instancetype)init {
    if(self = [super init]) {

    }
    return self;
}

#pragma mark *** life cycle ***
- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.resultLabel];
    [self addSubview:self.memoryLabel];
    [self addSubview:self.operatorLabel];
    [self setupUI];
}


#pragma mark *** setupUI ***

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

#pragma mark *** public methods ***
- (void)updateResultLabelText:(NSString *)text {
    self.resultLabel.text = text;
}

- (void)updateOperationLabelText:(NSString *)text {
    self.operatorLabel.text = text;
}

- (void)displayMemoryLabelText:(BOOL)flag {
    self.memoryLabel.hidden = flag;
}

#pragma mark *** getter ***
- (UILabel *)resultLabel {
    if(!_resultLabel) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.text = @"0";
        _resultLabel.textAlignment = NSTextAlignmentLeft;
        _resultLabel.textColor = [UIColor whiteColor];
        _resultLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:50];
    }
    return _resultLabel;
}

- (UILabel *)operatorLabel {
    if(!_operatorLabel) {
        _operatorLabel = [[UILabel alloc]init];
        _operatorLabel.textAlignment = NSTextAlignmentCenter;
        _operatorLabel.textColor = [UIColor whiteColor];
        _operatorLabel.text = @"";
    }
    return _operatorLabel;
}

- (UILabel *)memoryLabel {
    if(!_memoryLabel) {
        _memoryLabel = [[UILabel alloc] init];
        _memoryLabel.textAlignment = NSTextAlignmentCenter;
        _memoryLabel.textColor = [UIColor whiteColor];
        _memoryLabel.text = @"M";
    }
    return _memoryLabel;
}

@end
