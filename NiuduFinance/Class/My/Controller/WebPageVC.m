//
//  WebPageVC.m
//  NiuduFinance
//
//  Created by andrewliu on 16/10/14.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "WebPageVC.h"
#import "User.h"

@interface WebPageVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,weak)MBProgressHUD *hud;

@property (nonatomic,strong)NSString *getWebUrl;

@property (nonatomic,assign)BOOL webUrlOk;
@end

@implementation WebPageVC
{
    NSString *webUrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self backBarItem];
    
    [self setWebViewInfo];
    
    _webUrlOk = NO;
    
    [self setupBarButtomItemWithImageName:@"nav_back_normal.png" highLightImageName:nil selectedImageName:@"nav_back_select.png" target:self action:@selector(backBtnClick) leftOrRight:YES];
}

- (void)backBtnClick
{
    
    
    if ([_getWebUrl isEqualToString:[NSString stringWithFormat:@"%@", [self.httpUtil requWebName:@"protocol.jsp" parameters:nil]]] && _webUrlOk == NO) {
        _webUrlOk = YES;
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    [self setWebViewInfo];
}
- (void)setName:(NSString *)name
{
    _name = name;
    
    [self setWebViewInfo];
    
}

- (void)setWebViewInfo
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, - 43 , SCREEN_WIDTH, SCREEN_HEIGHT)];

    if ( [_name isEqualToString:@"recharge"] ) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -43, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    }

    _webView.scrollView.bounces = NO;
    _webView.scalesPageToFit = YES; //自动对页面进行缩放以适应屏幕
    
    [_webView setUserInteractionEnabled:YES];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setDelegate:self];
    [_webView setOpaque:NO];
    NSURLRequest *request;
    if ([self.name isEqualToString:@"recharge"]) {
        
        webUrl = [self.httpUtil requWebName:self.name parameters:nil];
        NSLog(@"=======%@",webUrl);
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    }else if([self.name isEqualToString:@"withdrawcash"]){
        
        webUrl = [self.httpUtil requWebName:self.name parameters:nil];
        NSLog(@"=======%@",webUrl);
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    }else if([self.name isEqualToString:@"huifu/openaccount"]){
    
        webUrl = [self.httpUtil requWebName:self.name parameters:nil];
        
         request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    }else if([self.name isEqualToString:@"bidproject"]&&self.dic != nil){
        
        webUrl = [self.httpUtil requWebName:self.name parameters:nil];
        NSString *urlStr = [NSString stringWithFormat:@"%@&BidAmount=%@&ProjectId=%@&BounsId=%@",webUrl,[self.dic objectForKey:@"bidAmount"],[self.dic objectForKey:@"projectId"],[self.dic objectForKey:@"BounsId" ]];

        request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    }else if ([self.name isEqualToString:@"debtdeal/buy"]&&self.dic != nil){
        webUrl = [self.httpUtil requWebName:self.name parameters:nil];
        NSString *urlStr = [NSString stringWithFormat:@"%@&DebtDealId=%@&Num=%@",webUrl,[self.dic objectForKey:@"DebtDealId"],[self.dic objectForKey:@"Num"]];
        
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    }else if([self.name isEqualToString:@"agreement/debtdeal"]&& self.dic != nil){
    
        webUrl = [self.httpUtil requWebName:self.name parameters:nil];
        NSString *urlStr = [NSString stringWithFormat:@"%@&DebtdealId=%@",webUrl,[self.dic objectForKey:@"DebtDealId"]];
        
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
        
    }else if([self.name isEqualToString:@"agreement/bidproject"] &&self.dic != nil){
    
        webUrl = [self.httpUtil requWebName:self.name parameters:nil];
        NSString *urlStr = [NSString stringWithFormat:@"%@&ProjectId=%@",webUrl,[self.dic objectForKey:@"ProjectId"]];
        
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
        
    }else if([self.name isEqualToString:@"huifu/login"]){
        
        webUrl = [self.httpUtil requWebName:self.name parameters:nil];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    }
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_hud hide:YES];
//    NSLog(@"=====%@",[error description]);
//    [_hud dismissErrorStatusString:@"正在加载..." hideAfterDelay:1.3];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _hud = [MBProgressHUD showStatus:nil toView:self.view];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取当前页面的title
    NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title====%@",title);
    
    //获取当前URL
    _getWebUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"URL===%@",_getWebUrl);
    
    [_hud hide:YES];
    NSLog(@"test===%@", [self.httpUtil requWebName:@"protocol.jsp" parameters:nil]);
    if ([_getWebUrl isEqualToString:[NSString stringWithFormat:@"%@", [self.httpUtil requWebName:@"protocol.jsp" parameters:nil]]]) {
        _webUrlOk = NO;
    }
    
    if ([_getWebUrl isEqualToString:@"http://mertest.chinapnr.com/muser/bankcard/addCardTp"]) {
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    }
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
