//
//  HTagModel.m
//  TagImageView
//
//  Created by Jvaeyhcd on 2019/6/19.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import "HTagModel.h"

@implementation HTagModel

- (instancetype)initWithName:(NSString *)name value:(NSString *)value {
    if (self = [super init]) {
        _name = name;
        _value = value;
    }
    return self;
}

@end
