//
//  TabBarController.m
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "ProjectViewController.h"
#import "MyViewController.h"
#import "InvestViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AppDelegate.h"


@interface TabBarController ()

@end

@implementation TabBarController

//- (void)loadView
//{
//    [super loadView];
    //修改高度
//    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
//    CGFloat tabBarHeight = 49;
//    self.tabBar.frame = CGRectMake(0, height-tabBarHeight, width, tabBarHeight);
//    self.tabBar.clipsToBounds = YES;
//    UIView *transitionView = [[self.view subviews] objectAtIndex:0];
//    transitionView.height = height-tabBarHeight;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set base navigationBar
    [self setAppearanceNaviBar];
    
    [self setupViewControllers];
}

- (void)setAppearanceNaviBar
{
    [[UINavigationBar appearance] setBarTintColor:NaviColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];

    self.tabBar.translucent = NO;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    
}

- (void)setupViewControllers
{
    UIColor *textColor = Nav4169E1;
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.tag = 1;
    [item1 setTitle:@"首页"];
    [item1 setImage:[UIImage imageNamed:@"home"]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"home-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] init];
    item2.tag = 2;
    [item2 setTitle:@"投资"];
    [item2 setImage:[UIImage imageNamed:@"tab-project"]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"tab-Project-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
//    UITabBarItem *item3 = [[UITabBarItem alloc] init];
//    item3.tag = 3;
//    [item3 setTitle:@"借款"];
//    [item3 setImage:[UIImage imageNamed:@"tab-new"]];
//    [item3 setSelectedImage:[[UIImage imageNamed:@"tab-new-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
//                         forState:UIControlStateSelected];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] init];
    item4.tag = 4;
    [item4 setTitle:@"我的"];
    [item4 setImage:[UIImage imageNamed:@"tab-my"]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"tab-my-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    
    HomeViewController *homeController = [[HomeViewController alloc] init];
    BaseNavigationController *homeNavController = [[BaseNavigationController alloc] initWithRootViewController:homeController];
    homeNavController.tabBarItem = item1;
    
    ProjectViewController *projectController = [[ProjectViewController alloc] init];
    BaseNavigationController *projectNavController = [[BaseNavigationController alloc] initWithRootViewController:projectController];
    projectNavController.tabBarItem = item2;
    
//    InvestViewController *investController = [[InvestViewController alloc] init];
//    BaseNavigationController *messageNavController = [[BaseNavigationController alloc] initWithRootViewController:investController];
//    messageNavController.tabBarItem = item3;
    
    MyViewController *myController = [[MyViewController alloc] init];
    BaseNavigationController *myNavController = [[BaseNavigationController alloc] initWithRootViewController:myController];
    myNavController.tabBarItem = item4;
    //messageNavController
    self.viewControllers = [NSArray arrayWithObjects:homeNavController,projectNavController,myNavController, nil];
    self.delegate = self;
    self.selectedIndex = 0;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3) {
        if (![AppDelegate checkTabbarLogin]) {
//            tabBarController.selectedIndex = 0;
        }
    }
}

@end
