//
//  HTagViewModel.h
//  TagImageView
//
//  Created by Jvaeyhcd on 2019/6/19.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTagModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HTagViewStyleSquareRight = 0,
    HTagViewStyleSquareLeft,
    HTagViewStyleObliqueRight,
    HTagViewStyleObliqueLeft,
    HTagViewStyleCount
} HTagViewStyle;

@interface HTagViewModel : NSObject

/**
 tag文本数组
 */
@property (nonatomic, strong) NSMutableArray<HTagModel *> *tagModels;

/**
 标签相对于父视图坐标系中的相对坐标，例如(0.5,0.5)表示父视图的中心
 */
@property (nonatomic, assign) CGPoint coordinate;

/**
 样式
 */
@property (nonatomic, assign) HTagViewStyle style;

/**
 顺序标志
 */
@property (nonatomic, assign) NSInteger index;

/**
 初始化

 @param tagModels tag数组
 @param coordinate 相对父视图坐标
 */
- (instancetype)initWithTagModels:(NSArray <HTagModel *> *)tagModels coordinate:(CGPoint)coordinate;

/**
 根据标签数量进行判断
 */
- (void)resetStyle;

/**
 切换样式
 */
- (void)toggleStyle;

/**
 根据当前style更新角度
 */
- (void)synchronizeAngle;

@end

NS_ASSUME_NONNULL_END
