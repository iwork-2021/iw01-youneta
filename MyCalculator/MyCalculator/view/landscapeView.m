//
//  landscapeView.m
//  MyCalculator
//
//  Created by chenxiangxiu on 2021/10/8.
//  Copyright © 2021年 cxx. All rights reserved.
//

#import "landscapeView.h"
#import "buttonCollectionViewCell.h"
#import "calculateManager.h"

@interface landscapeView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(strong, nonatomic) UICollectionView  *buttonCollectionView;
@property(nonatomic) BOOL mode;
@end

//cell的标识
static NSString *cellIdentifier = @"buttonCollectionViewCell";

@implementation landscapeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark *** init ***
- (instancetype)init {
    if(self = [super init]){
        self.buttonDidClickBlock = nil;
        self.mode = NO;
    }
    return self;
}

#pragma mark *** life cycle ***
- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.buttonCollectionView];
    [self setupUI];
}

#pragma mark *** setupUI ***
- (void)setupUI {

    //自动布局设置
    self.buttonCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *collectionViewTop = [NSLayoutConstraint constraintWithItem:self.buttonCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *collectionViewBottom = [NSLayoutConstraint constraintWithItem:self.buttonCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *collectionViewLeft = [NSLayoutConstraint constraintWithItem:self.buttonCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *collectionViewRight = [NSLayoutConstraint constraintWithItem:self.buttonCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self addConstraints:@[collectionViewTop, collectionViewBottom, collectionViewLeft, collectionViewRight]];

    
}

#pragma mark *** getter ***
- (UICollectionView *)buttonCollectionView {
    if(!_buttonCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _buttonCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _buttonCollectionView.delegate = self;
        _buttonCollectionView.dataSource = self;
        [_buttonCollectionView registerClass:[buttonCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        _buttonCollectionView.backgroundColor = [UIColor clearColor];
        _buttonCollectionView.scrollEnabled = NO;
    }
    return _buttonCollectionView;
}

#pragma mark *** UICollectionView dataSource ***
// size of each cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = collectionView.frame.size.height / 5 - 1;
    CGFloat cellWidth = collectionView.frame.size.width / 10 - 1;
    if(indexPath.section == 1 && indexPath.row == 6) return CGSizeMake(cellWidth * 2 + 1, cellHeight); // ”0“按键
    else return CGSizeMake(cellWidth, cellHeight);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //考虑到有异形到cell（按键“0”），因此将整个collectionview分成两个部分，0按键所在到一行作为第二个section）
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 40;
            break;
        case 1:
            return 9;
            break;
        default:return 0;
            break;
    }
}

// 同section行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
// 同section列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

// 不同section之间的偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);//分别为上、左、下、右
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if([cell isKindOfClass:[buttonCollectionViewCell class]]){
        NSString *cellText = [[calculateManager sharedInstance]getLandscapeColletionCellStringAtSection:indexPath.section atRow:indexPath.row mode:self.mode];
        [((buttonCollectionViewCell *)cell) setTextLabelText:cellText];
    }
    cell.backgroundColor = [self _colorForEachCell:indexPath];
    cell.layer.cornerRadius = cell.frame.size.height / 3;
    cell.layer.masksToBounds = YES;
    return cell;
}

#pragma mark *** UICollectionView delegate ***
// cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.buttonDidClickBlock(indexPath.section, indexPath.row);
}

// cell的点击高亮设置
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = [UIColor lightGrayColor];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = [self _colorForEachCell:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark *** publick methods ***
- (void)updateButtonsWhenSwitchingMode:(BOOL)mode {
    self.mode = mode;
    for (int i = 0; i < self.buttonCollectionView.numberOfSections; i++) {
        for(int j = 0; j<[self.buttonCollectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            buttonCollectionViewCell *cell = ((buttonCollectionViewCell *)[self.buttonCollectionView cellForItemAtIndexPath:indexPath]);
            if([cell respondsToSelector:@selector(setTextLabelText:)]){
                [cell setTextLabelText:[[calculateManager sharedInstance] getLandscapeColletionCellStringAtSection:i atRow:j mode:mode]];
            }
            [self.buttonCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            
        }
    }
//    [self.buttonCollectionView reloadData];
}

#pragma mark *** private methods ***
- (UIColor *)_colorForEachCell:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row % 10 == 9) return [UIColor orangeColor];
    }
    else if(indexPath.section == 1) {
        if(indexPath.row == 8) return [UIColor orangeColor];
    }
    return [UIColor grayColor];
}

@end
