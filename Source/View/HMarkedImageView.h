//
//  HMarkedImageView.h
//  TagImageView
//
//  Created by 超讯研发部 on 2019/6/25.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTagView.h"
#import "HTagViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HMarkedImageViewDelegate <NSObject>

@optional
/**
 点击了TagImageView

 @param viewModel viewModel模型
 */
- (void)didTapMarkedImage:(HTagViewModel *)viewModel;

/**
 删除了某个Tag

 @param viewModel tag的viewModel
 */
- (void)deleteTagView:(HTagViewModel *)viewModel;

@end


@interface HMarkedImageView : UIImageView

/**
 标签视图数组
 */
@property (nonatomic, strong) NSMutableArray<HTagView *> *tagViews;

/**
 是否可以编辑（添加删除标签）
 */
@property (nonatomic, assign) BOOL editable;

/**
 是否已经显示标签
 */
@property (nonatomic, assign, getter=isShowed) BOOL showed;

@property (nonatomic, weak) id<HMarkedImageViewDelegate> delegate;

/**
 创建标签

 @param viewModels 标签model数组
 */
- (void)createTagView:(NSMutableArray<HTagViewModel *> *)viewModels;

/**
 显示标签
 */
- (void)showTagViews;

/**
 隐藏标签
 */
- (void)hideTagViews;

@end

NS_ASSUME_NONNULL_END
