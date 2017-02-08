//
//  BaseNavigationController.m
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseNavigationController.h"


@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置头部背景颜色
    
    [UINavigationBar appearance].barTintColor = Nav019BFF;//
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
//    self.navigationBar.translucent = NO;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
