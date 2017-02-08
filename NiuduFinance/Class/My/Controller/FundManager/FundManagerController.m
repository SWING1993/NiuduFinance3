//
//  FundManagerController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/4.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FundManagerController.h"
#import "PSJumpNumLabel.h"
#import "FundManagerCell.h"
#import "UIView+Extension.h"
#import "NetWorkingUtil.h"
#import "NSString+Adding.h"
#import "PushMoneyViewController.h"
#import "BindingBankCardViewController.h"
#import "User.h"
#import "RealNameCertificationViewController.h"
//#import "RechargeViewController.h"
#import "WebPageVC.h"
#define NAVBAR_CHANGE_POINT 50
@interface FundManagerController ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *custemNavi;
@property (weak, nonatomic) IBOutlet PSJumpNumLabel *moneyLabel;

@property (strong, nonatomic) NetWorkingUtil *httpUtil;
@property (nonatomic,strong)NSDictionary *typeDic1;
@property (nonatomic,strong)NSDictionary *typeDic2;
@property (nonatomic,strong)NSDictionary *typeDic3;

@property (strong, nonatomic) NSMutableArray *bankCardsArr;



@end

#define kHeaderViewHeight 195
static NSString *cellIdentifier = @"FundManagerCell";
@implementation FundManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    
    
    _typeDic1 = [NSDictionary dictionary];
    _typeDic2 = [NSDictionary dictionary];
    _typeDic3 = [NSDictionary dictionary];
    _bankCardsArr = [NSMutableArray array];
    [self getMyBankCard];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES    animated:animated];
//    self.navigationController.navigationBarHidden = YES;
    [self getFundManageData];
}



- (NetWorkingUtil *)httpUtil
{
    if (!_httpUtil) {
        _httpUtil = [NetWorkingUtil netWorkingUtil];
    }
    return _httpUtil;
}


- (void)getFundManageData
{
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestArr4MethodName:@"account/detail" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _typeDic1 = arr[0];
            _typeDic2 = arr[1];
            _typeDic3 = arr[2];
            
            _moneyLabel.jumpValue = [_typeDic1 objectForKey:@"AvailableBalance"];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [self.tableView reloadData];
    } convertClassName:nil key:nil];
}

#pragma mark - Set Up UI
- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"#dedede"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加 header view
    [self.tableView addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(-kHeaderViewHeight);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(kHeaderViewHeight));
    }];
}

#pragma mark - override
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)getMyBankCard
{
    [self.httpUtil requestArr4MethodName:@"fund/bankcard" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
            [_bankCardsArr addObjectsFromArray:arr];
            
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } convertClassName:nil key:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
#pragma mark - Actions
- (IBAction)withdrawAction {
    
    if ([[User userFromFile].isOpenAccount integerValue] == 0) {
        WebPageVC *vc = [[WebPageVC alloc] init];
        vc.title = @"开通汇付账户";
        vc.name = @"huifu/openaccount";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //提现
    WebPageVC *vc = [[WebPageVC alloc] init];
    vc.title = @"提现";
    vc.name = @"withdrawcash";
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)rechargeAction {
    
    if ([[User userFromFile].isOpenAccount integerValue] == 0) {
        WebPageVC *vc = [[WebPageVC alloc] init];
        vc.title = @"开通汇付账户";
        vc.name = @"huifu/openaccount";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //充值
    WebPageVC *vc = [[WebPageVC alloc] init];
    vc.title = @"充值";
    vc.name = @"recharge";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backAction {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY <= -kHeaderViewHeight)
    {
        [_custemNavi mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(contentOffsetY + kHeaderViewHeight));
        }];
    }
    else if (contentOffsetY <= -122)// -195 ~ -122 之间
    {
        CGFloat midValue = kHeaderViewHeight - 122;
        CGFloat offsetValue = midValue + 0.5 - (kHeaderViewHeight + contentOffsetY);
        _moneyLabel.alpha = offsetValue/midValue;
    }else if (contentOffsetY <= -121)
    {
        _moneyLabel.alpha = 0.0;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y <= -260)
    {
        NSString *balanceStr = [NSString stringWithFormat:@"%@",[_typeDic1 objectForKey:@"AvailableBalance"]];
        if (IsStrEmpty(balanceStr)) {
            _moneyLabel.jumpValue = @"0.00";
        }else{
            _moneyLabel.jumpValue = [_typeDic1 objectForKey:@"AvailableBalance"];
        }
        
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _moneyLabel.alpha = 1.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _moneyLabel.alpha = 1.0;
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 2;
    }
    else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FundManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *title;
    NSString *detailText;
    FundManagerCellValueStyle valueStyle = -1;
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        title = @"总资产";
        detailText = [[NSString stringWithFormat:@"%@",[_typeDic3 objectForKey:@"SumBalance"]] strmethodComma];
        _detailText1 = detailText;
        NSLog(@"-----66666----%@",_detailText1);
        valueStyle = FundManagerCellValueStyleBule;
    }
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        title = @"待收金额";
        detailText = [[NSString stringWithFormat:@"%@",[_typeDic2 objectForKey:@"SumReceivable"]] strmethodComma];
        valueStyle = FundManagerCellValueStyleGreen;
    }
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        title = @"投资总额";
        detailText = [[NSString stringWithFormat:@"%@",[_typeDic3 objectForKey:@"BidAmount"]] strmethodComma];
        valueStyle = FundManagerCellValueStyleBule;
    }
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        title = @"已收本息";
        detailText = [[NSString stringWithFormat:@"%@",[_typeDic3 objectForKey:@"SumPrincipal"]] strmethodComma];
        valueStyle = FundManagerCellValueStyleBlack;
    }
    if (indexPath.section == 1 && indexPath.row == 2)
    {
        title = @"累计收益";
        detailText = [[NSString stringWithFormat:@"%@",[_typeDic3 objectForKey:@"SumIncome"]] strmethodComma];
        valueStyle = FundManagerCellValueStyleBlack;
    }
    if (indexPath.section == 1 && indexPath.row == 3)
    {
        title = @"待收利息";
        detailText = [[NSString stringWithFormat:@"%@",[_typeDic2 objectForKey:@"ReceivableInterest"]] strmethodComma];
        valueStyle = FundManagerCellValueStyleGreen;
    }
    if (indexPath.section == 1 && indexPath.row == 4)
    {
        title = @"待收本金";
        detailText = [[NSString stringWithFormat:@"%@",[_typeDic2 objectForKey:@"ReceivablePrincipal"]] strmethodComma];
        valueStyle = FundManagerCellValueStyleGreen;
    }
    [cell setupTitle:title detailText:detailText valueStyle:valueStyle];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

@end
