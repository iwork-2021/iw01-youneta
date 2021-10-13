//
//  calculateManager.h
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/10.
//  Copyright © 2021 cxx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class calculateModel;

@interface calculateManager : NSObject

+ (instancetype)sharedInstance; //作为一个单例来使用

- (NSString *)getPortraitColletionCellStringAtSection:(NSInteger)x atRow:(NSInteger)y; //返回竖屏状态的按键展示字符串
- (NSString *)getLandscapeColletionCellStringAtSection:(NSInteger)x atRow:(NSInteger)y;
- (NSString *)handlePortraitOperationAtSection:(NSInteger)x atRow:(NSInteger)y model:(calculateModel *)model;
- (NSString *)handleLandscapeOperationAtSection:(NSInteger)x atRow:(NSInteger)y model:(calculateModel *)model;

@end

NS_ASSUME_NONNULL_END
