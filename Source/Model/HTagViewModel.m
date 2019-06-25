//
//  HTagViewModel.m
//  TagImageView
//
//  Created by Jvaeyhcd on 2019/6/19.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import "HTagViewModel.h"

// 样式字典
static NSDictionary *STYLE_DICT;

@implementation HTagViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HTagViewStyle" ofType:@"plist"];
            STYLE_DICT = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        });
    }
    return self;
}

- (instancetype)initWithTagModels:(NSArray <HTagModel *> *)tagModels coordinate:(CGPoint)coordinate {
    if (self = [self init]) {
        if (!tagModels) {
            tagModels = [NSMutableArray<HTagModel *> array];
        }
        _tagModels = tagModels.mutableCopy;
        _coordinate = coordinate;
        _style = HTagViewStyleSquareRight;
    }
    return self;
}

#pragma mark - 判断当前style

- (void)resetStyle {
    NSInteger count = _tagModels.count;
    if (count == 0) {
        return;
    }
    
    // 根据标签条数拿出对应的样式数据
    NSDictionary *countStyleDict = STYLE_DICT[[NSString stringWithFormat:@"%@", @(count)]];
    if (!countStyleDict) {
        return;
    }
    
    // allKeys为所有TagViewStyle
    NSArray *allKeys = [countStyleDict allKeys];
    // 遍历TagViewStyle
    for (NSInteger i = 0; i < allKeys.count; i++) {
        NSString *styleStr = allKeys[i];
        // 以此为key拿出对应style的角度
        NSArray *styleArray = countStyleDict[styleStr];
        if (styleArray.count == 0) {
            // 没有角度数据
            continue;
        }
        // 无论有多少条标签，这里都只判断了第一条标签的角度
        NSNumber *angleNumber = (NSNumber*)styleArray[0];
        if(_tagModels[0].angle == [angleNumber floatValue]){
            _style = [styleStr integerValue];
            return;
        }
    }
}

- (void)toggleStyle {
    _style = (_style + 1) % HTagViewStyleCount;
    [self synchronizeAngle];
}

- (void)synchronizeAngle {
    NSInteger count = _tagModels.count;
    if (count == 0) {
        return;
    }
    
    // 根据标签条数拿出对应的样式数据
    NSDictionary *countStyleDict = STYLE_DICT[[NSString stringWithFormat:@"%@", @(count)]];
    if (!countStyleDict) {
        return;
    }
    
    // 根据样式拿出角度数据数组
    NSArray *styleArray = countStyleDict[[NSString stringWithFormat:@"%@", @(_style)]];
    if (styleArray.count < _tagModels.count) {
        return;
    }
    
    // 更新角度
    for (NSInteger i = 0; i < _tagModels.count; i++) {
        NSNumber *angleNumber = (NSNumber*)styleArray[i];
        _tagModels[i].angle = [angleNumber floatValue];
    }
}

#pragma mark - Setter

- (void)setStyle:(HTagViewStyle)style {
    _style = style;
    [self synchronizeAngle];
}

@end
