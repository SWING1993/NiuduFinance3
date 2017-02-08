//
//  RechargeWebViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/10/14.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RechargeWebViewController.h"

@interface RechargeWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,weak)MBProgressHUD *hud;

@end

@implementation RechargeWebViewController
{
    NSString *webUrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    [self backBarItem];
    
    [self loadData];
    
    
}

- (void)loadData{

    webUrl = [self.httpUtil requWebName:@"recharge" parameters:nil];
    
    
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    [self setWebViewInfo];
}
- (void)setWebViewInfo
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _webView.scalesPageToFit = YES; //自动对页面进行缩放以适应屏幕
    
    [_webView setUserInteractionEnabled:YES];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setDelegate:self];
    [_webView setOpaque:NO];
    NSURLRequest *request;
    if ([self.name isEqualToString:@"recharge"]) {
     
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.83:8083/recharge?userId=11"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    }else if([self.name isEqualToString:@"withdrawcash"]){
        
        
         request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.83:8083/withdrawcash?userId=11"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    }
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_hud dismissErrorStatusString:[error description] hideAfterDelay:1.3];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _hud = [MBProgressHUD showStatus:nil toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
