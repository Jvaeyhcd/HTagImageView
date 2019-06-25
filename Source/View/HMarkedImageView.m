//
//  HMarkedImageView.m
//  TagImageView
//
//  Created by 超讯研发部 on 2019/6/25.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import "HMarkedImageView.h"

@interface HMarkedImageView()<HTagViewDelegate>

@end

@implementation HMarkedImageView

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    _tagViews = [NSMutableArray array];
    _editable = NO;
    _showed = NO;
    
    // 手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.cancelsTouchesInView = YES;
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - 手势点击

- (void)didTap:(UITapGestureRecognizer *)recognizer {
    if (_editable) {
        // 新建标签
        CGPoint position = [recognizer locationInView:self];
        // 判断是否要新建标签，如果任何标签的文字或中心点包含了这个点，则不创建
        if ([self pointInsideAnyTagView:position]) {
            return;
        }
        // 创建TagViewModel
        CGPoint coordinate = CGPointMake(position.x / self.frame.size.width, position.y / self.frame.size.height);
        HTagViewModel *viewModel = [[HTagViewModel alloc] initWithTagModels:[NSMutableArray<HTagModel *> array] coordinate:coordinate];
        viewModel.index = -1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMarkedImage:)]) {
            [self.delegate didTapMarkedImage:viewModel];
        }
    } else {
        // 显示、隐藏标签
        if (_showed) {
            [self hideTagViews];
        } else {
            [self showTagViews];
        }
    }
}

/**
 判断某个点是否位于某个tagview中

 @param point 点坐标信息
 @return 是或不是
 */
- (BOOL)pointInsideAnyTagView:(CGPoint)point {
    for (HTagView *tagView in _tagViews) {
        BOOL inside = [tagView pointInside:point];
        if (inside) {
            return YES;
        }
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    // 如果当前不可编辑，则拦截所有点击事件，并返回自己，x无需继续往下寻找响应view
    if (!_editable && view) {
        return self;
    }
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL inside = [super pointInside:point withEvent:event];
    return inside;
}

#pragma mark - public

- (void)createTagView:(NSMutableArray<HTagViewModel *> *)viewModels {
    [self.tagViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagViews removeAllObjects];
    
    NSUInteger index = 0;
    for (HTagViewModel *viewModel in viewModels) {
        // 重新编号
        viewModel.index = index;
        index++;
        
        // 生成标签
        HTagView *tagView = [[HTagView alloc] initWithTagModel:viewModel];
        tagView.delegate = self;
        
        // 持有标签
        [self.tagViews addObject:tagView];
        [self addSubview:tagView];
    }
}

- (void)showTagViews {
    for (HTagView *view in self.tagViews) {
        view.viewHidden = NO;
    }
    _showed = YES;
}

- (void)hideTagViews {
    for (HTagView *view in self.tagViews) {
        view.viewHidden = YES;
    }
    _showed = NO;
}

#pragma mark - HTagViewDelegate

- (void)tagViewTextDidTap:(HTagView *)tagView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMarkedImage:)]) {
        [self.delegate didTapMarkedImage:tagView.viewModel];
    }
}

- (void)tagViewLongPress:(HTagView *)tagView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteTagView:)]) {
        [self.delegate deleteTagView:tagView.viewModel];
    }
}

@end
