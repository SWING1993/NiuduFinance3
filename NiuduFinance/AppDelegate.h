//
//  AppDelegate.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/24.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign)BOOL isLoginLock;

//调用登录
+ (BOOL)loginMain;

//检验是否登录
+ (BOOL)checkLogin;

// 检验锁屏后是否登录
+ (BOOL)checkLoginLock;

+ (BOOL)checkTabbarLogin;

+(BOOL)backToMe;

@end

