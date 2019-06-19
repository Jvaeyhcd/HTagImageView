//
//  HTagModel.h
//  TagImageView
//
//  Created by Jvaeyhcd on 2019/6/19.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HTagTypeTag = 0,
    HTagTypeAddress,
    HTagTypeBrand,
    HTagTypeGoods,
    HTagTypeMovie,
    HTagTypeUser
} HTagType;

/**
 单个Tag的Model对象
 */
@interface HTagModel : NSObject

/**
 tag的名称
 */
@property (nonatomic, copy) NSString *name;

/**
 tag的值
 */
@property (nonatomic, copy) NSString *value;

/**
 tag类型
 */
@property (nonatomic, assign) HTagType type;

/**
 线条角度
 */
@property (nonatomic, assign) CGFloat angle;

/**
 文本大小
 */
@property (nonatomic, assign) CGSize textSize;

/**
 文本位置
 */
@property (nonatomic, assign) CGPoint textPosition;

/**
 初始化

 @param name tag的名字
 @param value tag的值
 @return 初始化的对象
 */
- (instancetype)initWithName:(NSString *)name value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
