//
//  HTagView.m
//  TagImageView
//
//  Created by 超讯研发部 on 2019/6/19.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import "HTagView.h"

#define angleToRadians(angle) ((angle/180.0)*M_PI)

CGFloat const kTextFontSize = 12.0f;
//与底线左右两端的水平距离
CGFloat const kTextLayerHorizontalPadding = 10.0f;
//与下方底线的垂直距离
CGFloat const kTextLayerVerticalPadding = 5.0f;

//底线从圆心伸延的长度
CGFloat const kUnderLineLayerRadius = 25.0f;

CGFloat const kCenterPointRadius = 2.0f;
CGFloat const kShadowPointRadius = 4.0f;

NSString *const kAnimationKeyShow = @"show";
NSString *const kAnimationKeyHide = @"hide";

@interface HTagView()

/**
 拖动时的起始位置
 */
@property (nonatomic, assign) CGPoint startPosition;

/**
 三段文字的textLayer
 */
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *textLayers;

/**
 三段文字下的横线
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *underLineLayers;

/**
 中心点layer
 */
@property (nonatomic, strong) CAShapeLayer *centerPointShapeLayer;

/**
 中心点的阴影layer
 */
@property (nonatomic, strong) CAShapeLayer *shadowPointShapeLayer;

/**
 是否需要更新中心点
 */
@property (nonatomic, assign) BOOL needsUpdateCenter;

/**
 是否需要动画
 */
@property (nonatomic, assign) BOOL animating;

@end

@implementation HTagView

- (instancetype)initWithTagModel:(HTagViewModel *)viewModel {
    if (self = [super initWithFrame:CGRectMake(0, 0, 100, 50)]) {
        _viewModel = viewModel;
        _textLayers = [NSMutableArray array];
        _underLineLayers = [NSMutableArray array];
        _needsUpdateCenter = YES;
        _animating = NO;
        
        // 背景颜色为透明
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        
        [self setupSelfFrame];
        [self setupGesture];
        [self setupLayers];
    }
    return self;
}

#pragma mark - Public

- (BOOL)pointInside:(CGPoint)point {
    
    // 转换为自己的坐标系
    CGPoint position = [self convertPoint:point fromView:self.superview];
    if (![self centerContainsPoint:point inset:0] && ![self textLayerContainsPoint:point inset:CGPointMake(-5, -5)]) {
        return NO;
    }
    return [super pointInside:position withEvent:nil];
}

- (void)setNeedsUpdateCenter {
    _needsUpdateCenter = YES;
    [self setNeedsDisplay];
}

- (void)showWithAnimate:(BOOL)animate {
    
    if(!_viewHidden || _animating){
        return;
    }
    
    _animating = YES;
    CGFloat duration = .3f;
    
    [self animateWithDuration:duration * 3 animationBlock:^{
        NSTimeInterval currentTime = CACurrentMediaTime();
        
        // 原点
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.beginTime = 0;
        animation.duration = duration;
        animation.keyPath = @"opacity";
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @0;
        animation.toValue = @1;
        [self->_centerPointShapeLayer addAnimation:animation forKey:kAnimationKeyShow];
        animation.toValue = @(duration);
        [self->_shadowPointShapeLayer addAnimation:animation forKey:kAnimationKeyShow];
        
        // 线条
        CABasicAnimation *lineAnimation = [CABasicAnimation animation];
        lineAnimation.beginTime = currentTime+duration;
        lineAnimation.duration = duration;
        lineAnimation.keyPath = @"strokeEnd";
        lineAnimation.removedOnCompletion = NO;
        lineAnimation.fillMode = kCAFillModeForwards;
        lineAnimation.fromValue = @0;
        lineAnimation.toValue = @1;
        
        for(CAShapeLayer *shapeLayer in self->_underLineLayers){
            [shapeLayer addAnimation:lineAnimation forKey:kAnimationKeyShow];
        }
        
        // 文字
        CABasicAnimation *textAnimation = [CABasicAnimation animation];
        textAnimation.beginTime = currentTime+duration*2;
        textAnimation.duration = duration;
        textAnimation.keyPath = @"opacity";
        textAnimation.removedOnCompletion = NO;
        textAnimation.fillMode = kCAFillModeForwards;
        textAnimation.fromValue = @0;
        textAnimation.toValue = @1;
        
        for(CATextLayer *textLayer in self->_textLayers){
            [textLayer addAnimation:textAnimation forKey:kAnimationKeyShow];
        }
    } completeBlock:^{
        self->_animating = NO;
        self->_viewHidden = NO;
    }];
}

- (void)hideWithAnimate:(BOOL)animate {
    
    if(!_viewHidden || _animating){
        return;
    }
    
    _animating = YES;
    CGFloat duration = .3f;
    
    [self animateWithDuration:duration * 3 animationBlock:^{
        
        NSTimeInterval currentTime = CACurrentMediaTime();
        // 原点
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.beginTime = currentTime+duration*2;
        animation.duration = duration;
        animation.keyPath = @"opacity";
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeBackwards;
        animation.fromValue = @1;
        animation.toValue = @0;
        [self->_centerPointShapeLayer addAnimation:animation forKey:kAnimationKeyShow];
        animation.fromValue = @0.3;
        [self->_shadowPointShapeLayer addAnimation:animation forKey:kAnimationKeyShow];
        
        // 下划线
        CABasicAnimation *lineAnimation = [CABasicAnimation animation];
        lineAnimation.beginTime = currentTime+duration;
        lineAnimation.duration = duration;
        lineAnimation.keyPath = @"strokeEnd";
        lineAnimation.removedOnCompletion = NO;
        lineAnimation.fillMode = kCAFillModeBoth;
        lineAnimation.fromValue = @1;
        lineAnimation.toValue = @0;
        
        for(CAShapeLayer *shapeLayer in self->_underLineLayers){
            [shapeLayer addAnimation:lineAnimation forKey:kAnimationKeyShow];
        }
        
        // 文字
        CABasicAnimation *textAnimation = [CABasicAnimation animation];
        textAnimation.beginTime = 0;
        textAnimation.duration = duration;
        textAnimation.keyPath = @"opacity";
        textAnimation.removedOnCompletion = NO;
        textAnimation.fillMode = kCAFillModeBoth;
        textAnimation.fromValue = @1;
        textAnimation.toValue = @0;
        
        for(CATextLayer *textLayer in self->_textLayers){
            [textLayer addAnimation:textAnimation forKey:kAnimationKeyShow];
        }
    } completeBlock:^{
        self->_animating = NO;
        self->_viewHidden = YES;
    }];
}

#pragma mark - Private setup

/**
 计算自身界面大小
 */
- (void)setupSelfFrame {
    // 获取最宽的文本的Size
    CGSize maxWidthSize = [self getMaxTextSize];
    // 控件的宽度 = 2*(斜线的半径+最大文本宽度+文本左边距+文本右边距+控件内边距)
    // 控件的高度 =2*(斜线的半径+最大文本的高度+文本的上边距+文本的底边距+控件的内边距)
    CGFloat width = (kUnderLineLayerRadius + kTextLayerHorizontalPadding + maxWidthSize.width) * 2;
    CGFloat height = (kUnderLineLayerRadius + kTextLayerVerticalPadding + maxWidthSize.height) * 2;
    
    self.bounds = CGRectMake(0, 0, width, height);
}

/**
 初始化手势事件
 */
- (void)setupGesture {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    
    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:longPressGesture];
    [self addGestureRecognizer:panGesture];
}

- (void)setupLayers {
    // 初始化
    _viewHidden = YES;
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_textLayers removeAllObjects];
    [_underLineLayers removeAllObjects];
    _centerPointShapeLayer = nil;
    _shadowPointShapeLayer = nil;
    
    if (!_viewModel) {
        return;
    }
    
    // 生成文字Layer
    for (HTagModel *tag in _viewModel.tagModels) {
        // 文本
        CATextLayer *textLayer = [self setupTextLayerWithTagModel:tag];
        [_textLayers addObject:textLayer];
        
        // 文本高度
        tag.textSize = [textLayer preferredFrameSize];
        textLayer.bounds = CGRectMake(0, 0, tag.textSize.width, tag.textSize.height);
        
        // 线段
        CAShapeLayer *lineLayer = [self setupUnderlineShapeLayerWithTagModel:tag];
        [_underLineLayers addObject:lineLayer];
        
        // 设置文本位置
        textLayer.position = tag.textPosition;
        
        [self.layer addSublayer:textLayer];
        [self.layer addSublayer:lineLayer];
    }
    
    // 圆点阴影
    _shadowPointShapeLayer = [self setupCenterPointShapeLayerWithRadius:kShadowPointRadius];
    _shadowPointShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_shadowPointShapeLayer];
    
    // 圆点
    _centerPointShapeLayer = [self setupCenterPointShapeLayerWithRadius:kCenterPointRadius];
    [self.layer addSublayer:_centerPointShapeLayer];
}

/**
 创建圆点的Layer

 @param kCenterPointRadius 点的半径
 @return 圆点Layer
 */
- (CAShapeLayer *)setupCenterPointShapeLayerWithRadius:(CGFloat)kCenterPointRadius {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kCenterPointRadius * 2, kCenterPointRadius * 2)].CGPath;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.position = CGPointMake(self.layer.bounds.size.width / 2, self.layer.bounds.size.height / 2);
    shapeLayer.opacity = 0;
    
    return  shapeLayer;
}

/**
 创建文本图层

 @param model HTagModel
 @return 文本图层CATextLayer
 */
- (CATextLayer *)setupTextLayerWithTagModel:(HTagModel *)model {
    if (!model) {
        return nil;
    }
    if (model.name.length == 0 && model.value == 0) {
        return nil;
    }
    
    CATextLayer *textLayer = [CATextLayer layer];
    
    UIFont *font = [UIFont systemFontOfSize:kTextFontSize];
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer.opacity = 0;
    
    // 设置border
    textLayer.borderWidth = 1;
    textLayer.borderColor = [UIColor whiteColor].CGColor;
    textLayer.cornerRadius = 4;
    
    NSString *text;
    if (model.name.length != 0) {
        text = [NSString stringWithFormat:@"%@ %@", model.name, model.value];
    } else {
        text = [NSString stringWithFormat:@"%@", model.value];
    }
    textLayer.string = text;
    
    return textLayer;
}

/**
 创建线的图层

 @param model HTagModel
 @return 线的图层CAShapeLayer
 */
- (CAShapeLayer *)setupUnderlineShapeLayerWithTagModel:(HTagModel *)model {
    CGPoint centerPoint = CGPointMake(self.layer.bounds.size.width / 2, self.layer.bounds.size.height / 2);
    CGPoint startPoint = centerPoint;
    CGPoint endPoint;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    // 计算路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:centerPoint];
    
    //画出圆弧半径
    if (!(model.angle == 180.f || model.angle == -180.f || model.angle == 0)) {
        CGPoint arcPoint = [self arcPointWithCenter:centerPoint radius:kUnderLineLayerRadius angle:model.angle];
        [path addLineToPoint:arcPoint];
        startPoint = arcPoint;
    }
    //画出直线
    if (model.angle < 90.f && model.angle > -90.f) {
        // 角度在第一四象限，向右画
        endPoint = CGPointMake(startPoint.x+model.textSize.width+kTextLayerHorizontalPadding, startPoint.y);
        [path addLineToPoint:endPoint];
    } else {
        // 角度在第二三象限，向左画
        endPoint = CGPointMake(startPoint.x-model.textSize.width-kTextLayerHorizontalPadding, startPoint.y);
        [path addLineToPoint:endPoint];
    }
    
    lineLayer.path = path.CGPath;
    lineLayer.shadowPath = path.CGPath;
    lineLayer.strokeEnd = 0;
    
    // 计算文本位置
    CGFloat textPositionX = (startPoint.x + endPoint.x)/2;
    CGFloat textPositionY = endPoint.y - kTextLayerVerticalPadding - model.textSize.height / 2;
    model.textPosition = CGPointMake(textPositionX, textPositionY);
    
    return lineLayer;
}

#pragma mark - 手势&点击判断

- (void)didTap:(UITapGestureRecognizer *)recognizer {
    
    // 动画或隐藏后不响应点击事件
    if (_animating || _viewHidden) {
        return;
    }
    
    CGPoint position = [recognizer locationInView:self];
    if ([self textLayerContainsPoint:position inset:CGPointMake(0, 0)]) {
        // 点击文本
        if (self.delegate && [self.delegate respondsToSelector:@selector(tagViewTextDidTap:)]) {
            [self.delegate tagViewTextDidTap:self];
            return;
        }
    }
    
    if ([self centerContainsPoint:position inset:0]) {
        // 切换了样式
        [_viewModel toggleStyle];
        // 重绘自己
        [self setupLayers];
        self.viewHidden = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tagViewCenterDidTap:)]) {
            [self.delegate tagViewCenterDidTap:self];
            return;
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    
    // 动画或隐藏后不响应点击事件
    if (_animating || _viewHidden) {
        return;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint position = [recognizer locationInView:self];
            if([self centerContainsPoint:position inset:0] || [self textLayerContainsPoint:position inset:CGPointMake(-5, -5)]){
                NSLog(@"long tap on text or center");
                if (self.delegate && [self.delegate respondsToSelector:@selector(tagViewLongPress:)]) {
                    [self.delegate tagViewLongPress:self];
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            break;
        }
        case UIGestureRecognizerStateEnded: {
            break;
        }
        default:
            break;
    }
}

- (void)didPan:(UIPanGestureRecognizer *)recognizer {
    
    // 动画或隐藏后不响应点击事件
    if (_animating || _viewHidden) {
        return;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint position = [recognizer locationInView:self];
            //滑动，需要加上10个点预判
            if(![self centerContainsPoint:position inset:10.f] && ![self textLayerContainsPoint:position inset:CGPointMake(-15, -15)]){
                _startPosition = CGPointZero;
                return;
            }
            //保存初始点击位置
            _startPosition = [recognizer locationInView:self.superview];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            if (CGPointEqualToPoint(_startPosition, CGPointZero)) {
                return;
            }
            //计算偏移量并更新自己的center
            CGPoint position = [recognizer locationInView:self.superview];
            
            CGFloat moveX = position.x - _startPosition.x;
            CGFloat moveY = position.y - _startPosition.y;
            
            CGFloat origX = self.superview.bounds.size.width * _viewModel.coordinate.x;
            CGFloat origY = self.superview.bounds.size.height * _viewModel.coordinate.y;
            
            CGFloat currentX = MIN(MAX(origX + moveX, 0), self.superview.bounds.size.width - self.layer.bounds.size.width / 2);
            CGFloat currentY = MIN(MAX(origY + moveY, 0), self.superview.bounds.size.height - self.layer.bounds.size.height / 2);
            
            self.center = CGPointMake(currentX, currentY);
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            if (CGPointEqualToPoint(_startPosition, CGPointZero)) {
                return;
            }
            //最后保存中心点的相对坐标
            CGFloat x,y;
            x = self.center.x / self.superview.bounds.size.width;
            y = self.center.y / self.superview.bounds.size.height;
            
            
            CGPoint coordinate = CGPointMake(x, y);
            _viewModel.coordinate = coordinate;
            
            break;
        }
        default:
            break;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(![self centerContainsPoint:point inset:0] && ![self textLayerContainsPoint:point inset:CGPointMake(-5, -5)]){
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - Setter

- (void)setViewModel:(HTagViewModel *)viewModel {
    if(_viewModel == viewModel){
        return;
    }
    _viewModel = viewModel;
    
    [self setupLayers];
}

- (void)setViewHidden:(BOOL)viewHidden {
    if (_viewHidden == viewHidden) {
        return;
    }
    if (_viewHidden) {
        [self showWithAnimate:YES];
    } else {
        [self hideWithAnimate:YES];
    }
}

#pragma mark - private Helper

/**
 根据角度计算原上某点坐标

 @param centerPoint 中心点坐标
 @param radius 半径
 @param angle 角度
 @return 圆上的点
 */
- (CGPoint)arcPointWithCenter:(CGPoint)centerPoint
                       radius:(CGFloat)radius
                        angle:(CGFloat)angle {
    CGFloat x, y;
    CGFloat radians = angleToRadians(angle);
    x = centerPoint.x + cos(radians) * radius;
    y = centerPoint.y + sin(radians) * radius;
    
    return CGPointMake(roundf(x), roundf(y));
}

/**
 获取宽度最长的textSize

 @return 标签中最长的为标准的尺寸
 */
- (CGSize)getMaxTextSize {
    
    CGSize maxWidthSize = CGSizeZero;
    for (HTagModel *tagModel in _viewModel.tagModels) {
        NSString *text;
        if (tagModel.name.length != 0) {
            text = [NSString stringWithFormat:@"%@ %@", tagModel.name, tagModel.value];
        } else {
            text = [NSString stringWithFormat:@"%@", tagModel.value];
        }
        
        UIFont *font = [UIFont systemFontOfSize:kTextFontSize];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
        if (textSize.width > maxWidthSize.width) {
            maxWidthSize = textSize;
        }
    }
    
    return maxWidthSize;
}

/**
 点position是否在半径为kUnderLineLayerRadius的中心圆内

 @param position 点坐标
 @param insetRadius 内边距半径
 @return 是否点击了中心点
 */
- (BOOL)centerContainsPoint:(CGPoint)position inset:(CGFloat)insetRadius {
    CGPoint centerPosition = CGPointMake(self.layer.bounds.size.width / 2, self.layer.bounds.size.height / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPosition
                                                        radius:kUnderLineLayerRadius + insetRadius
                                                    startAngle:0
                                                      endAngle:M_PI * 2
                                                     clockwise:YES];
    return [path containsPoint:position];
}

/**
 点position是否在某一个textLayer内

 @param point 点坐标
 @param insetXY XY内边距
 @return 是否点击在某个textLayer内
 */
- (BOOL)textLayerContainsPoint:(CGPoint)point inset:(CGPoint)insetXY {
    BOOL longPressOnText = NO;
    for(CATextLayer *textLayer in _textLayers){
        if(textLayer.presentationLayer.opacity == 0){
            continue;
        }
        CGRect textRect = CGRectInset(textLayer.frame, insetXY.x, insetXY.y);
        if(CGRectContainsPoint(textRect, point)){
            longPressOnText = YES;
            break;
        }
    }
    return longPressOnText;
}

- (void)animateWithDuration:(CGFloat)duration
             animationBlock:(void(^)(void))doBlock
              completeBlock:(void(^)(void))completeBlock {
    
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if(completeBlock){
            completeBlock();
        }
        [CATransaction commit];
    }];
    if(doBlock){
        doBlock();
    }
    [CATransaction commit];
    
}

@end
