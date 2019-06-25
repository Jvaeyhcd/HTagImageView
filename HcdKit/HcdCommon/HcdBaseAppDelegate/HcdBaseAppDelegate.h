//
//  HcdBaseAppDelegate.h
//  TagImageView
//
//  Created by 超讯研发部 on 2019/6/25.
//  Copyright © 2019 Jvaeyhcd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HcdBaseAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

// 实例
+ (instancetype)sharedAppDelegate;
// 获取TabBarController
- (UITabBarController *)tabBarController;
// 获取当前navigationcontroller
- (UINavigationController *)navigationViewController;

@end

NS_ASSUME_NONNULL_END
