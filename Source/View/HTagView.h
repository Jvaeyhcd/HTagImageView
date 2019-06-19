//
//  HTagView.h
//  TagImageView
//
//  Created by 超讯研发部 on 2019/6/19.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTagViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HTagView;

@protocol HTagViewDelegate <NSObject>

@optional

/**
 点击了tag的中心点

 @param tagView tagView
 */
- (void)tagViewCenterDidTap:(HTagView *)tagView;

/**
 tagView的文字被点击了

 @param tagView tagView
 */
- (void)tagViewTextDidTap:(HTagView *)tagView;

/**
 长按tagView

 @param tagView tagView
 */
- (void)tagViewLongPress:(HTagView *)tagView;

@end

@interface HTagView : UIView

/**
 tagView的ViewModel
 */
@property (nonatomic, strong) HTagViewModel *viewModel;

/**
 tagView的delegate
 */
@property (nonatomic, weak) id<HTagViewDelegate>delegate;

/**
 界面是否隐藏
 */
@property (nonatomic, assign) BOOL viewHidden;

/**
 利用viewModel初始化

 @param viewModel viewModel
 @return 初始化的对象
 */
- (instancetype)initWithTagModel:(HTagViewModel *)viewModel;

/**
 判断point是否在frame中

 @param point 点坐标
 @return 是否在当前fram中
 */
- (BOOL)pointInside:(CGPoint)point;

/**
 设置更新圆点坐标
 */
- (void)setNeedsUpdateCenter;

/**
 显示界面

 @param animate 是否有动画
 */
- (void)showWithAnimate:(BOOL)animate;

/**
 隐藏界面

 @param animate 是否有动画
 */
- (void)hideWithAnimate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
