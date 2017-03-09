//
//  DAOListView.h
//  DemoRoom
//
//  Created by daoleo on 2017/2/25.
//  Copyright © 2017年 daoleo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ListSelectBlock) (NSInteger selectIndex);
typedef void (^ListCellConfigBlock) (UITableViewCell *cell, NSInteger index);

#define kReferFrameNavLeftItem CGRectMake(0, 0, 60, 64)
#define kReferFrameNavRightItem CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0, 60, 64)

@interface DAOListView : UIView
- (instancetype)initWithReferFrame:(CGRect)referFrame
                        titleArray:(NSArray *)titleArray
                          selected:(ListSelectBlock)select;
- (instancetype)initWithReferFrame:(CGRect)referFrame
                         cellCount:(NSInteger)cellCount
                        cellConfig:(ListCellConfigBlock)cellConfig
                          selected:(ListSelectBlock)select;
- (void)show;
- (void)showWithReferFrame:(CGRect)referFrame;
- (void)dismiss;
- (void)dismissAndRemove;
/**
 *  可见的cell数量 默认会根据屏幕高度进行适配，不会超出屏幕边界
 */
@property (nonatomic, assign) NSUInteger visibleCellCount;
/**
 *  cell 高度 默认40
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  list view 宽度 title 模式默认100 cellConfig模式默认150
 */
@property (nonatomic, assign) CGFloat listViewWidth;
/**
 *  默认 NO
 */
@property (nonatomic, assign) BOOL listViewBounces;

@property (nonatomic, strong) UIColor *listViewTriangleColor;
@end
