//
//  buttonCollectionViewCell.m
//  MyCalculator
//
//  Created by nju on 2021/10/10.
//  Copyright © 2021 cxx. All rights reserved.
//

#import "buttonCollectionViewCell.h"

@interface buttonCollectionViewCell()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation buttonCollectionViewCell

- (void)layoutSubviews {
    [self addSubview:self.textLabel];
    [self setupUI];
}

#pragma mark *** setupUI ***
- (void)setupUI {
    //自动布局设置
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *textLabelCenterX = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *textLabelCenterY = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *textLabelWidth = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *textLabelHeight = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    [self addConstraints:@[textLabelWidth, textLabelHeight, textLabelCenterX, textLabelCenterY]];
}

#pragma mark *** public methods ***
- (void)setTextLabelText:(NSString *)text {
    self.textLabel.text = text;
    [self.textLabel setAdjustsFontSizeToFitWidth:YES];
}

#pragma mark *** getter ***
- (UILabel *)textLabel {
    if(!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"hello";
        _textLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
    }
    return _textLabel;
}

@end
