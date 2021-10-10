//
//  headerView.h
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/8.
//  Copyright © 2021年 cxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headerView : UIView

- (void)updateResultLabelText:(NSString *)text;
- (void)updateOperationLabelText:(NSString *)text;
- (void)displayMemoryLabelText:(BOOL)flag;

@end
