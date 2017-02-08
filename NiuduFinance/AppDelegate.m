//
//  AppDelegate.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/24.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#define isFirstRun           @"isFirstRun"

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import "TabBarController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "User.h"
#import "PCCircleViewConst.h"
#import "GestureViewController.h"
#import "WelcomeViewController.h"


@interface AppDelegate ()
{
    NSDate *date;
}
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _isLoginLock = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //IQKeyboardManager
    
    
    
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    NSString *firstRun = [[NSUserDefaults standardUserDefaults] objectForKey:isFirstRun];
    if (!firstRun&&![firstRun isEqualToString:@""]) {//first
        [[NSUserDefaults standardUserDefaults] setObject:@"haveRun" forKey:@"isFirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        WelcomeViewController *welVc =[[WelcomeViewController alloc] init];
        self.window.rootViewController = welVc;
        
    }else{
        
        NSString *isHaveRun = [[NSUserDefaults standardUserDefaults] objectForKey:KHaveLogin];
        if (isHaveRun&&[isHaveRun isEqualToString:@"YES"]) {//自动登录
            [self autoLogin];
        }else{
            TabBarController *tabbarController = [[TabBarController alloc] init];
            self.window.rootViewController = tabbarController;
        }
    }
    
    return YES;
}

- (void)autoLogin
{
    User *user = [User userFromFile];
    NSLog(@"======%@----%@====%ld",user.userName,user.password,(long)user.userId);
    
    if (user.password == nil || user.userName == nil) {
        [user saveExit];
        [user removeUser];
        [AppDelegate loginMain];
    }else{
        // 手势密码本地判断
        if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
            /*
             requestObj4MethodName:@"user/login" parameters:@{@"UserName":_accountTextField.text,@"Password"
             */
            NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
            [util requestObj4MethodName:@"user/login" parameters:@{@"UserName":user.userName,@"Password":user.password} result:^(id obj, int status, NSString *msg) {
                
                if (status != 1) {
                    [user saveExit];
                    [user removeUser];
                    [MBProgressHUD showError:@"网络错误" toView:self.window];
                    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
                }
            } convertClassName:nil key:nil];
            
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            [gestureVc setType:GestureViewControllerTypeLogin];
            self.window.rootViewController = gestureVc;
            
            
        }else{
            
            UIViewController *vc = [UIViewController new];
            self.window.rootViewController = vc;
            
            NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
            [util requestObj4MethodName:@"user/login" parameters:@{@"UserName":user.userName,@"Password":user.password} result:^(id obj, int status, NSString *msg) {
                if (status != 1) {
                    [user saveExit];
                    [user removeUser];
                    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
                }else{
                    [AppDelegate loginMain];
                }
            } convertClassName:nil key:nil];
        }
    }
}

- (void)delayMethod
{
    [AppDelegate loginMain];
}
//检查登录
+ (BOOL)checkLogin
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *isHaveRun = [[NSUserDefaults standardUserDefaults] objectForKey:KHaveLogin];
    if (!isHaveRun || [isHaveRun isEqualToString:@"NO"]) {
        if (app.window.rootViewController.presentingViewController == nil) {
            //  跳转登录
            LoginViewController*loginVC = [[LoginViewController alloc] init];
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            baseNav.navigationBar.barTintColor = Nav019BFF;
            baseNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
            [app.window.rootViewController presentViewController:baseNav animated:YES completion:^{
            }];
        }
        return NO;
    }else{
        return YES;
    }
}
//手势锁
+ (BOOL)checkLoginLock
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *isHaveRun = [[NSUserDefaults standardUserDefaults] objectForKey:KHaveLogin];
    if (!isHaveRun || [isHaveRun isEqualToString:@"NO"]) {
        if (app.window.rootViewController.presentingViewController == nil) {
            //  跳转首页
            [AppDelegate loginMain];
        }
        return NO;
    }else{
        
        return YES;
    }

}

+ (BOOL)loginMain
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    TabBarController *tabbarController = [[TabBarController alloc] init];
    tabbarController.selectedIndex = 0;
    app.window.rootViewController = tabbarController;
    app.isLoginLock = YES;
    return YES;
}

+(BOOL)backToMe{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    TabBarController *tabbarController = [[TabBarController alloc] init];
    tabbarController.selectedIndex = 3;
    app.window.rootViewController = tabbarController;
    return YES;
}

+ (BOOL)checkTabbarLogin
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *isHaveRun = [[NSUserDefaults standardUserDefaults] objectForKey:KHaveLogin];
    if (!isHaveRun || [isHaveRun isEqualToString:@"NO"]) {
        if (app.window.rootViewController.presentingViewController == nil) {
            //  跳转登录
            LoginViewController*loginVC = [[LoginViewController alloc] init];
            loginVC.typeStr = @"tabbar";
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            baseNav.navigationBar.barTintColor = Nav019BFF;
            baseNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
            [app.window.rootViewController presentViewController:baseNav animated:YES completion:^{
            }];
        }
        return NO;
    }else{
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    

    date = [NSDate date];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSTimeInterval secondsInterval= [[NSDate date] timeIntervalSinceDate:date];
    
    if (secondsInterval >= 180) {
        if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length] && _isLoginLock == YES){
            if ([AppDelegate checkLoginLock]) {
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeLock];
                BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:gestureVc];
                baseNav.navigationBar.barTintColor = Nav019BFF;
                baseNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
                [app.window.rootViewController presentViewController:baseNav animated:YES completion:^{
                    
                }];
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
