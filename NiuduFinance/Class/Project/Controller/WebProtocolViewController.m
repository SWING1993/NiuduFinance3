//
//  WebProtocolViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "WebProtocolViewController.h"


@interface WebProtocolViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSURL *url;

@end

@implementation WebProtocolViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
//        self.title = @"投资协议";
    }
    return self;
}
- (void)setWebAddressStr:(NSString *)webAddressStr
{
    _webAddressStr = webAddressStr;
    
    NSString *urlStr = _webAddressStr;
    _url = [NSURL URLWithString:urlStr];
    
    [self setWebViewInfo];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    
//    [self MyHTMLCreate];
}

- (void)setWebViewInfo
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -43, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _webView.scalesPageToFit = YES; //自动对页面进行缩放以适应屏幕
    
    [_webView setUserInteractionEnabled:YES];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setDelegate:self];
    [_webView setOpaque:NO];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessag:@"玩命加载中..." toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载完毕");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
