//
//  calculateModel.h
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/8.
//  Copyright © 2021年 cxx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, calculatorButtonType) {
    calculatorButtonTypeDefault,
    calculatorButtonTypeNumber, //数字键
    calculatorButtonTypeBinaryOperation, //二元运算符
    calculatorButtonTypeUnaryOperation, //一元运算符
    calculatorButtonTypeEqual, //等于号
    calculatorButtonTypeClear, //AC键
    calculatorButtonTypePoint, //小数点
};

typedef NS_ENUM(NSUInteger, calculatorStatus) {
    calculatorStatusDefault,
    calculatorStatusEnteringNumber,
};

@interface calculateModel : UIView

@property (nonatomic, strong) NSString *resultString;
@property (nonatomic, strong) NSString *ans;
@property (nonatomic, strong) NSString *operationString;
@property (nonatomic, strong) NSString *memoryString;
@property (nonatomic) BOOL memoryFlag;
@property (nonatomic) calculatorButtonType lastPressButtonType;

- (void)setupModel;

@end
