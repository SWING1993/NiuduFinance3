//
//  FinancialProductViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FinancialProductViewController.h"
#import "PSJumpNumLabel.h"
#import "FinancialProductCell.h"
#import "NetWorkingUtil.h"
#import "BaseViewController.h"
#import <MJRefresh.h>
#import "NoMsgView.h"
#import "NoNetWorkView.h"

@interface FinancialProductViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *custemNavi;
@property (weak, nonatomic) IBOutlet PSJumpNumLabel *totalIncomeLabel;
@property (weak, nonatomic) IBOutlet PSJumpNumLabel *incommingMoneyLabel;

@property (nonatomic,strong)NSDictionary *financeDic;
@property (nonatomic,strong)NSMutableArray *financeArr;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,assign)NSInteger financeCount;

@property (nonatomic,strong)NoMsgView *noMsgView;
@property (nonatomic,strong)NoNetWorkView *noNetWorkView;
@end

static CGFloat const kHeaderViewHeight = 195;
static NSString *const cellIdentifier = @"FinancialProductCell";
@implementation FinancialProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _financeDic = [NSDictionary dictionary];
    _financeArr = [NSMutableArray array];
    _pageIndex = 1;
    _financeCount = 0;
    
    [self setupTableView];
    
    _noMsgView =  [[[NSBundle mainBundle] loadNibNamed:@"NoMsgView" owner:self options:nil] firstObject];
    _noMsgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _noNetWorkView =  [[[NSBundle mainBundle] loadNibNamed:@"NoNetWorkView" owner:self options:nil]firstObject];
    _noNetWorkView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getFinanceProductData];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)getFinanceProductData
{
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"financialproduct/investorder" parameters:@{@"PageIndex":@(_pageIndex)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [_noNetWorkView removeFromSuperview];
            if (_pageIndex == 1) {
                [_financeArr removeAllObjects];
            }
            _financeDic = [dic objectForKey:@"ReceivedInfo"];
            NSArray *arr = [dic objectForKey:@"MyProducts"];
            _financeCount = arr.count;
            [_financeArr addObjectsFromArray:arr];
            
            _totalIncomeLabel.jumpValue = [_financeDic objectForKey:@"Income"];
            _incommingMoneyLabel.jumpValue = [_financeDic objectForKey:@"DueIncome"];
            
            if (_financeArr.count == 0) {
                [self.view addSubview:_noMsgView];
            }else{
                [_noMsgView removeFromSuperview];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            [self.view addSubview:_noNetWorkView];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Set Up UI
- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 10, 0);
    [self setupFooterRefresh:self.tableView];
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"#dedede"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [UIView new];

    //添加 header view
    [self.tableView addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-kHeaderViewHeight);
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

#pragma mark - Actions

- (IBAction)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY <= -kHeaderViewHeight)
    {
        [_custemNavi mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(contentOffsetY + kHeaderViewHeight)).priority(MASLayoutPriorityRequired);
            make.top.equalTo(_headerView.mas_top).offset(contentOffsetY + kHeaderViewHeight).priority(MASLayoutPriorityRequired);
        }];
    }
    else if (contentOffsetY <= -122)// -195 ~ -122 之间
    {
        CGFloat midValue = kHeaderViewHeight - 122;
        CGFloat offsetValue = midValue + 0.5 - (kHeaderViewHeight + contentOffsetY);
        _totalIncomeLabel.alpha = offsetValue/midValue;
    }else if (contentOffsetY <= -121)
    {
        _totalIncomeLabel.alpha = 0.0;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y <= -260)
    {
        NSString *incomeStr = [NSString stringWithFormat:@"%@",[_financeDic objectForKey:@"Income"]];
        if (IsStrEmpty(incomeStr)) {
            _totalIncomeLabel.jumpValue = @"0.00";
        }else{
            _totalIncomeLabel.jumpValue = [_financeDic objectForKey:@"Income"];
        }
        NSString *dueIncomeStr = [NSString stringWithFormat:@"%@",[_financeDic objectForKey:@"DueIncome"]];
        if (IsStrEmpty(dueIncomeStr)) {
            _incommingMoneyLabel.text = @"0.00";
        }else{
            _incommingMoneyLabel.jumpValue = [_financeDic objectForKey:@"DueIncome"];
        }
        
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _totalIncomeLabel.alpha = 1.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _totalIncomeLabel.alpha = 1.0;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _financeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinancialProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.financialDic = _financeArr[indexPath.row];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
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

- (void)footerRefreshloadData
{
    if (_financeCount < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
        _pageIndex ++;
        [self getFinanceProductData];
        [self.tableView.mj_footer endRefreshing];
    }
}

@end
