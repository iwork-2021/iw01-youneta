//
//  calculateModel.m
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/8.
//  Copyright © 2021年 cxx. All rights reserved.
//

#import "calculateModel.h"

@implementation calculateModel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if(self = [super init]) {
        [self setupModel];
        self.memoryFlag = NO;
        self.memoryString = @"0";
        self.modeFlag = NO;
    }
    return self;
}

- (void)setupModel {
    self.resultString = @"0";
    self.ans = @"";
    self.operationString = @"";
    self.lastPressButtonType = calculatorButtonTypeDefault;
}

@end
