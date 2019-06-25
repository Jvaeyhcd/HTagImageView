//
//  UIView+HcdView.h
//  TagImageView
//
//  Created by 超讯研发部 on 2019/6/25.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HcdView)

#pragma mark - Frame

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
