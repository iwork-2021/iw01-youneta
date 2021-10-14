//
//  calculateManager.m
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/10.
//  Copyright © 2021 cxx. All rights reserved.
//

#import "calculateManager.h"
#import "calculateModel.h"

#define RADIANS_TO_DEGREE(radians) ((radians * (180.0) / M_PI))
#define DEGREE_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface calculateManager()

@property (nonatomic, strong) NSArray *portraitOperationArray;
@property (nonatomic, strong) NSArray *landscapeOperationArray;

@end

@implementation calculateManager

#pragma mark *** static ***
static calculateManager *sharedManager = nil;
static NSArray *numberString = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
static NSArray *unaryOperatorString = @[@"+/-", @"%", @"=", @"x^2", @"x^3", @"log10", @"e^x", @"1/x", @"2√x", @"3√x", @"x!", @"ln", @"sin", @"cos", @"tan", @"sinh", @"cosh", @"tanh", @"10^x"];
static NSArray *binaryOperatorString = @[@"+", @"-", @"÷", @"×", @"x^y", @"y√x", @"EE"];
static NSArray *memoryOperationString = @[@"m+", @"m-", @"mc"];
static NSArray *singleNumberString = @[@"mr", @"e", @"π", @"Rand"];
static NSString *divideZeroErrorString = @"除0错误！";
static NSString *calculateNotSupportedString = @"暂不支持的操作";
static NSString *calculateError = @"无效运算";

#pragma mark *** init ***
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[calculateManager alloc]init];
    });
    return sharedManager;
}

- (instancetype)init {
    if(self = [super init]) {
        [self _setupDict];
    }
    return self;
}

#pragma mark *** public methods ***

- (NSString *)getPortraitColletionCellStringAtSection:(NSInteger)x atRow:(NSInteger)y {
    return [[self.portraitOperationArray objectAtIndex:x] objectAtIndex:y];
}

- (NSString *)getLandscapeColletionCellStringAtSection:(NSInteger)x atRow:(NSInteger)y {
    return [[self.landscapeOperationArray objectAtIndex:x] objectAtIndex:y];
}

- (NSString *)handlePortraitOperationAtSection:(NSInteger)x atRow:(NSInteger)y model:(calculateModel *)model{
    NSString *operation = [self getPortraitColletionCellStringAtSection:x atRow:y];
    return [self _handleOperation:operation model:model];
}

- (NSString *)handleLandscapeOperationAtSection:(NSInteger)x atRow:(NSInteger)y model:(calculateModel *)model{
    NSString *operation = [self getLandscapeColletionCellStringAtSection:x atRow:y];
    return [self _handleOperation:operation model:model];
}

#pragma mark *** private methods ***
- (void)_setupDict {
    self.portraitOperationArray = [NSArray arrayWithObjects:
                                   @[@"AC", @"+/-", @"%", @"÷", @"7", @"8", @"9", @"×", @"4", @"5", @"6", @"-", @"1", @"2", @"3", @"+"],
                                   @[@"0", @".", @"="],
                                  nil];
    self.landscapeOperationArray = [NSArray arrayWithObjects:
                                    @[@"(", @")", @"mc", @"m+", @"m-", @"mr", @"AC", @"+/-", @"%", @"÷", @"2nd", @"x^2", @"x^3", @"x^y", @"e^x", @"10^x", @"7", @"8", @"9", @"×", @"1/x", @"2√x", @"3√x", @"y√x", @"ln", @"log10", @"4", @"5", @"6", @"-", @"x!", @"sin", @"cos", @"tan", @"e", @"EE", @"1", @"2", @"3", @"+"],
                                    @[@"Rad", @"sinh", @"cosh", @"tanh", @"π", @"Rand", @"0", @".", @"="],
                                   nil];
}


- (NSString *)_handleOperation:(NSString *)operation model:(calculateModel *)model{
    
    if([numberString containsObject:operation]) {
        // 数字键
        switch (model.lastPressButtonType) {
            case calculatorButtonTypeDefault:
            case calculatorButtonTypeSingleNumber:
            case calculatorButtonTypeBinaryOperation:
                model.resultString = operation;
                break;
            case calculatorButtonTypePoint:
            case calculatorButtonTypeNumber:
                if([model.resultString  isEqual: @"0"]) {
                    model.resultString = operation;
                }
                else {
                    model.resultString =  [model.resultString stringByAppendingString:operation];
                }
                break;
            case calculatorButtonTypeUnaryOperation:
                [model setupModel];
                model.resultString = operation;
            default:
                break;
        }
        model.lastPressButtonType = calculatorButtonTypeNumber;
    }
    
    else if([binaryOperatorString containsObject:operation]) {
        // 二元运算符
        switch (model.lastPressButtonType) {
            case calculatorButtonTypeBinaryOperation: break;
            case calculatorButtonTypePoint:
            case calculatorButtonTypeDefault:
            case calculatorButtonTypeUnaryOperation:
            case calculatorButtonTypeSingleNumber:
            case calculatorButtonTypeNumber:
                if([model.operationString  isEqualToString:@""]){
                    model.ans = model.resultString;
                    model.resultString = @"0";
                }
                else{
                    NSString *result = [self _calculateAns:model.ans Operand:model.resultString Operation:model.operationString];
                    model.resultString = result;
                    model.ans = result;
                    model.operationString = @"";
                }
                break;
            default:
                break;
        }
        model.lastPressButtonType = calculatorButtonTypeBinaryOperation;
        model.operationString = operation;
    }
    else if([unaryOperatorString containsObject:operation]) {
        // 一元运算符
        switch (model.lastPressButtonType) {
            case calculatorButtonTypeBinaryOperation:
            {
                NSString *result = [self _calculateAns:model.ans Operand:@"" Operation:operation];
                model.resultString = result;
                model.ans = result;
                model.operationString = @"";
                break;
            }
            case calculatorButtonTypeDefault:
            case calculatorButtonTypeUnaryOperation:
            case calculatorButtonTypeSingleNumber:
            case calculatorButtonTypeNumber:
            {
                
                NSString *result = @"";
                if(![model.operationString isEqualToString:@""]){
                    //如果在这之前有二元运算并未得出结果，先进行该二元运算，得到结果再进行一元运算
                    result = [self _calculateAns:model.ans Operand:model.resultString Operation:model.operationString];
                    if([result isEqualToString:divideZeroErrorString]) {
                        model.resultString = result;
                        break;
                    }
                    result = [self _calculateAns:result Operand:@"" Operation:operation];
                }
                else {
                    result = [self _calculateAns:model.resultString Operand:model.ans Operation:operation];
                }
                
                model.operationString = @"";
                model.resultString = result;
                model.ans = result;
                break;
            }
                
            default:
                break;
        }
        model.lastPressButtonType = calculatorButtonTypeUnaryOperation;
    }
    else if([operation isEqualToString:@"AC"]) {
        [model setupModel];
        model.lastPressButtonType = calculatorButtonTypeDefault;
    }
    else if([operation isEqualToString:@"."]) {
        //小数点
        switch (model.lastPressButtonType) {
            case calculatorButtonTypeSingleNumber:
            case calculatorButtonTypeBinaryOperation:
                model.resultString = @"0.";
                break;
            default:
                if([model.resultString containsString:@"."]);
                else {
                    model.resultString = [model.resultString stringByAppendingString:@"."];
                }
                break;
        }
        model.lastPressButtonType = calculatorButtonTypePoint;
    }
    else if([singleNumberString containsObject:operation]) {
        // 展示单个数字(e, pi, mr)
        switch (model.lastPressButtonType) {
            case calculatorButtonTypeUnaryOperation:
                [model setupModel];
            case calculatorButtonTypeNumber:
            case calculatorButtonTypeBinaryOperation:
            case calculatorButtonTypePoint:
            case calculatorButtonTypeDefault:
            case calculatorButtonTypeSingleNumber:
                model.resultString = [self _calculateAns:model.memoryString Operand:nil Operation:operation];
                break;
            default:
                break;
        }
        model.lastPressButtonType = calculatorButtonTypeSingleNumber;
    }
    else if([memoryOperationString containsObject:operation]) {
        //缓存操作
        [self _handleMemoryOperation:operation model:model];
    }
//    else if([operation isEqualToString:@"2nd"]) {
//        //切换模式
//    }
    else {
        [model setupModel];
        return [calculateNotSupportedString stringByAppendingFormat:@": %@",operation];;
    }
    
    NSLog(@"resultString: %@, ans: %@, opeartion: %@", model.resultString, model.ans, model.operationString);
    if([model.resultString isEqualToString:divideZeroErrorString]) {
        [model setupModel];
        return divideZeroErrorString;
    }
    else if([model.resultString containsString:calculateNotSupportedString]) {
        NSString *error = model.resultString;
        [model setupModel];
        return error;
    }
    return @"";
}

- (NSString *)_calculateAns:(NSString *)ans Operand:(NSString *)operand Operation:(NSString *)operation {
    double ansDouble = [ans doubleValue];
    double operandDouble = 0;
    double result = 0;
    if(operand!=nil &&![operand isEqualToString:@""]) {
        operandDouble = [operand doubleValue];
    }
    
    if([operation isEqualToString:@"+"]) {
        result = ansDouble + operandDouble;

    }
    else if([operation isEqualToString:@"-"]) {
        result = ansDouble - operandDouble;
    }
    else if([operation isEqualToString:@"×"]) {
        result = ansDouble * operandDouble;
    }
    else if([operation isEqualToString:@"÷"]) {
        if(operandDouble == 0){
            return divideZeroErrorString;
        }
        else result = ansDouble / operandDouble;
    }
    else if([operation isEqualToString:@"+/-"]) {
        result = -ansDouble;
    }
    else if([operation isEqualToString:@"%"]) {
        result = ansDouble / 100;
    }
    else if([operation isEqualToString:@"="]) {
        result = ansDouble;
    }
    else if([operation isEqualToString:@"x^2"]) {
        result = ansDouble * ansDouble;
    }
    else if([operation isEqualToString:@"x^3"]) {
        result = ansDouble * ansDouble * ansDouble;
    }
    else if([operation isEqualToString:@"1/x"]) {
        if(ansDouble == 0) {
            return divideZeroErrorString;
        }
        result = 1 / ansDouble;
    }
    else if([operation isEqualToString:@"log10"]) {
        result = log10(ansDouble);
    }
    else if([operation isEqualToString:@"ln"]) {
        result = log(ansDouble);
    }
    else if([operation isEqualToString:@"x^y"]) {
        result = pow(ansDouble, operandDouble);
    }
    else if([operation isEqualToString:@"x!"]) {
        result = 1;
        for(int i = 1; i <= ansDouble; i++) {
            result *= i;
        }
    }
    else if([operation isEqualToString:@"sin"]) {
        //要先转为弧度制
        result = sinl(DEGREE_TO_RADIANS(ansDouble));
    }
    else if([operation isEqualToString:@"cos"]) {
        result = cos(DEGREE_TO_RADIANS(ansDouble));
    }
    else if([operation isEqualToString:@"tan"]) {
        result = tan(DEGREE_TO_RADIANS(ansDouble));
    }
    else if([operation isEqualToString:@"2√x"]) {
        result = sqrt(ansDouble);
    }
    else if([operation isEqualToString:@"3√x"]) {
        result = cbrtf(ansDouble);
    }
    else if([operation isEqualToString:@"y√x"]) {
        result = pow(ansDouble, 1/operandDouble);
    }
    else if([operation isEqualToString:@"sinh"]) {
        result = sinh(ansDouble);
    }
    else if([operation isEqualToString:@"cosh"]) {
        result = cosh(ansDouble);
    }
    else if([operation isEqualToString:@"tanh"]) {
        result = tanh(ansDouble);
    }
    else if([operation isEqualToString:@"e"]) {
        result = exp(1);
    }
    else if([operation isEqualToString:@"e^x"]) {
        result = exp(ansDouble);
    }
    else if([operation isEqualToString:@"π"]) {
        result = M_PI;
    }
    else if([operation isEqualToString:@"10^x"]) {
        result = pow(10, ansDouble);
    }
    else if([operation isEqualToString:@"Rand"]) {
        result = ((double)arc4random()) / UINT32_MAX;
    }
    else if([operation isEqualToString:@"mr"]) {
        result = ansDouble;
    }
    else if([operation isEqualToString:@"EE"]) {
        result = ansDouble * pow(10.0, operandDouble);
    }
    else {
        return [calculateNotSupportedString stringByAppendingFormat:@": %@", operation];
    }
    
    return [NSString stringWithFormat:@"%f", result];
}

- (void)_handleMemoryOperation:(NSString *)operation model:(calculateModel *)model {
    double mDouble = [model.memoryString doubleValue];
    double operationDouble = [model.resultString doubleValue];
    double result = 0;
    if([operation isEqualToString:@"m+"]) {
        result = mDouble + operationDouble;
    }
    else if([operation isEqualToString:@"m-"]) {
        result = mDouble - operationDouble;
    }
    else if([operation isEqualToString:@"mc"]) {
        result = 0;
    }
    
    model.memoryFlag = (result != 0);
    model.memoryString = [NSString stringWithFormat:@"%f", result];
}
@end
