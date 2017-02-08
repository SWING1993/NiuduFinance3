//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+(void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    
    // 设置图片
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon] ]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1.5秒之后再消失
    [hud hide:YES afterDelay:2];
    
}
+ (void)show:(NSString *)text andShowLabel:(NSString *)showLabel icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = nil;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon] ]];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 75, 70, 30)];
    
    successLabel.text = text;
    [successLabel setTextColor:[UIColor whiteColor]];
    successLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [imageView addSubview:successLabel];
    
    UILabel *showLabelText = [[UILabel alloc] initWithFrame:CGRectMake(90, 120, 100, 30)];
    
    showLabelText.text = showLabel;
    [showLabelText setTextColor:[UIColor blackColor]];
    showLabelText.font = [UIFont boldSystemFontOfSize:18];
    
    [imageView addSubview:showLabelText];

    
    // 设置图片
    hud.customView = imageView;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1.5秒之后再消失
    [hud hide:YES afterDelay:2];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (MB_INSTANCETYPE)showStatus:(NSString *)status toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = status;
    [view addSubview:hud];
    [hud show:YES];
    return hud;
}

+ (BOOL)dismissHUDForView:(UIView *)view {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        return YES;
    }
    return NO;
}

+ (BOOL)dismissHUDForView:(UIView *)view withError:(NSString *)error {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.detailsLabelText = error;
        hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1.0秒之后再消失
        [hud hide:YES afterDelay:2.0];
        return YES;
    }
    return NO;
}

+ (BOOL)dismissHUDForView:(UIView *)view withsuccess:(NSString *)success {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.detailsLabelText = success;
        hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1.0秒之后再消失
        [hud hide:YES afterDelay:2.0];
        return YES;
    }
    return NO;
}

#pragma mark 显示一些信息
+ (void)showMessag:(NSString *)message toView:(UIView *)view {
    [self show:message icon:nil view:view];
}

// custem
+ (MB_INSTANCETYPE)mb_ProgressHUDStatusToView:(UIView*)view statusString:(NSString*)statusString
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD* hud = [[self alloc] initWithView:view];;
    //    hud.animationType = MBProgressHUDAnimationZoom;
    hud.removeFromSuperViewOnHide = YES;
    hud.minShowTime = .3;
    hud.detailsLabelText = statusString;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    [view addSubview:hud];
    [hud show:YES];
    return hud;
}

- (void)dismissErrorStatusString:(NSString*)statusString hideAfterDelay:(NSTimeInterval)delay
{
    self.detailsLabelText = statusString;
    self.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    // 设置图片
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
    // 再设置模式
    self.mode = MBProgressHUDModeCustomView;
    [self hide:YES afterDelay:delay];
}

- (void)dismissSuccessStatusString:(NSString *)statusString hideAfterDelay:(NSTimeInterval)delay
{
    self.detailsLabelText = statusString;
    self.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    // 设置图片
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
    // 再设置模式
    self.mode = MBProgressHUDModeCustomView;
    [self hide:YES afterDelay:delay];
}

- (void)dismissMsgStatusString:(NSString *)statusString hideAfterDelay:(NSTimeInterval)delay
{
    self.detailsLabelText = statusString;
    self.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    // 设置图片
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",nil]]];
    // 再设置模式
    self.mode = MBProgressHUDModeCustomView;
    [self hide:YES afterDelay:delay];
}

@end
