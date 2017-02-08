//
//  BaseViewController.m
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseViewController.h"
#import "PSBarButtonItem.h"
#import "UIColor+SNFoundation.h"
#import "MacroDefine.h"


@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

#pragma mark - Life
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _hideNaviBar = NO;
        _hideBottomBar = NO;
        self.screenLayout = NO;
        self.view.backgroundColor = [UIColor colorWithHexString:@"#F0EFF5"];
        _refershState = RefershStateUp;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _hideNaviBar = NO;
        _hideBottomBar = NO;
        self.screenLayout = NO;
        self.view.backgroundColor = [UIColor colorWithHexString:@"#F0EFF5"];
        _refershState = RefershStateUp;
    }
    return self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    // 隐藏 navi
    //    if (IS_IOS8_LATE)
    //    {
    //        self.navigationController.hidesBarsOnSwipe = YES;
    //    }
    //
    // 启动 手势pop
    if (self.navigationItem.leftBarButtonItem)
    {
//        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Public
- (UIBarButtonItem*)backBarItem
{
    PSBarButtonItem *backItem = [PSBarButtonItem itemWithTitle:nil barStyle:PSNavItemStyleBack target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    return backItem;
}

- (void)backAction
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIBarButtonItem *)setupBarButtomItemWithTitle:(NSString *)title target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft
{
    PSBarButtonItem *item = [PSBarButtonItem itemWithTitle:title barStyle:PSNavItemStyleDone target:target action:action];
    if (isLeft)
    {
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = item;
    }
    return item;
}

- (UIBarButtonItem *)setupBarButtomItemWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImaegName target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft
{
    PSBarButtonItem *item = [PSBarButtonItem itemWithImageName:normalImageName highLightImageName:highImageName selectedImageName:selectedImaegName target:target action:action];
    if (isLeft)
    {
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = item;
    }
    return item;
}

#pragma mark - Setter & Getter
- (void)setHideNaviBar:(BOOL)hideNaviBar
{
    _hideNaviBar = hideNaviBar;
    if (_hideNaviBar)
    {
        self.navigationController.navigationBarHidden = YES;
        
    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
       
    }
}

- (void)setHideBottomBar:(BOOL)hideBottomBar
{
    _hideBottomBar = hideBottomBar;
    if (_hideBottomBar)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
}

- (void)setScreenLayout:(BOOL)screenLayout
{
    _screenLayout = screenLayout;
    
    if (_screenLayout)
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    else
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (NetWorkingUtil *)httpUtil
{
    if (!_httpUtil) {
        _httpUtil = [NetWorkingUtil netWorkingUtil];
    }
    return _httpUtil;
}
//刷新
- (void)setupHeaderRefresh:(UITableView *)tableView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshloadData)];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    tableView.mj_header = header;
}

- (void)setupFooterRefresh:(UITableView *)tableView
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshloadData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    // 设置文字
    [footer setTitle:@"正在刷新..." forState:MJRefreshStateIdle];
    [footer setTitle:@"正在刷新..." forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    footer.arrowView.alpha = 0.0;
    tableView.mj_footer = footer;
}

- (void)setupRefreshWithTableView:(UITableView *)tableView
{
    [self setupHeaderRefresh:tableView];
    [self setupFooterRefresh:tableView];
}

- (void)headerRefreshloadData
{
    
}

- (void)footerRefreshloadData
{
    
}
//设置暂无数据
- (void)setHideNoMsg:(BOOL)hideNoMsg
{
    _hideNoMsg = hideNoMsg;
    if (!self.noMsgView.superview)
    {
        [self.view addSubview:_noMsgView];
    }
    _noMsgView.hidden = _hideNoMsg;
}

- (NoMsgView *)noMsgView
{
    if (!_noMsgView)
    {
        _noMsgView =  [[[NSBundle mainBundle] loadNibNamed:@"NoMsgView" owner:self options:nil] firstObject];
        _noMsgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    _noMsgView.centerX = self.view.center.x;
    return _noMsgView;
}

- (void)setHideNoNetWork:(BOOL)hideNoNetWork
{
    _hideNoNetWork = hideNoNetWork;
    if (!self.noNetWorkView.superview)
    {
        [self.view addSubview:_noNetWorkView];
    }
    _noNetWorkView.hidden = _hideNoNetWork;
}

- (NoNetWorkView *)noNetWorkView
{
    if (!_noNetWorkView)
    {
        _noNetWorkView =  [[[NSBundle mainBundle] loadNibNamed:@"NoNetWorkView" owner:self options:nil] firstObject];
        _noNetWorkView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    _noNetWorkView.centerX = self.view.center.x;
    return _noNetWorkView;
}

@end
