//
//  landscapeView.h
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/8.
//  Copyright © 2021年 cxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface landscapeView : UIView

@property (nonatomic, strong) void(^buttonDidClickBlock)(NSInteger x, NSInteger y);
- (void)updateButtonsWhenSwitchingMode:(BOOL)mode;

@end
