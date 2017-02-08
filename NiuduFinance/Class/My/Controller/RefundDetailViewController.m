//
//  RefundDetailViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RefundDetailViewController.h"
#import "RefundDetailCell.h"
#import "RefundViewController.h"
#import "NetWorkingUtil.h"


@interface RefundDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *loanTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *ioanImageView;
@property (weak, nonatomic) IBOutlet UILabel *ioanAmountLabel;// 555.00元
@property (weak, nonatomic) IBOutlet UILabel *yearRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unRefundAmountLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *returnMoneyBtn;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (nonatomic,strong)NSDictionary *projectDic;

@property (nonatomic,strong)NSMutableArray *projectArr;

@property (nonatomic,strong)NSString *balanceStr;

@property (nonatomic,strong)NSDictionary *currentRepayMentDic;
@end
static NSString *const cellIdentifer = @"RefundDetailCell";
@implementation RefundDetailViewController

- (void)setProjectId:(NSInteger)projectId
{
    _projectId = projectId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"还款";
    
    _projectDic = [NSDictionary dictionary];
    _projectArr = [NSMutableArray array];
    _currentRepayMentDic = [NSDictionary dictionary];
    
    [self backBarItem];
    [self setupTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_projectId) {
        [_projectArr removeAllObjects];
        [self getReturnDetailsData];
    }
}

- (void)getReturnDetailsData
{
    [self.httpUtil requestDic4MethodName:@"account/repayment" parameters:@{@"ProjectId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _balanceStr = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"Balance"] floatValue]];
            _currentRepayMentDic = [dic objectForKey:@"CurrentRepayMent"];
            _projectDic = [dic objectForKey:@"Project"];
            NSArray *arr = [dic objectForKey:@"RepayMentList"];
            [_projectArr addObjectsFromArray:arr];
            
            [self setHeaderInfo];
            
            if ([[dic objectForKey:@"CurrentPeriod"] integerValue] == [[dic objectForKey:@"Period"] integerValue]) {
                _returnMoneyBtn.userInteractionEnabled = NO;
                _returnMoneyBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
            }else{
                _returnMoneyBtn.userInteractionEnabled = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_tableView reloadData];
    }];
}

- (void)setHeaderInfo
{
    [NetWorkingUtil setImage:_ioanImageView url:[_projectDic objectForKey:@"IconUrl"] defaultIconName:nil];
    _loanTitleLab.text = [_projectDic objectForKey:@"Title"];
    _ioanAmountLabel.text = [NSString stringWithFormat:@"%@元",[_projectDic objectForKey:@"Amount"]];
    _yearRateLabel.text = [NSString stringWithFormat:@"%@%s",[_projectDic objectForKey:@"Rate"],"%"];
    if ([[_projectDic objectForKey:@"PeriodTypeId"] integerValue] == 1) {
        _timeLabel.text = [NSString stringWithFormat:@"%@天",[_projectDic objectForKey:@"LoanPeriod"]];
    }else if ([[_projectDic objectForKey:@"PeriodTypeId"] integerValue] == 2){
        _timeLabel.text = [NSString stringWithFormat:@"%@个月",[_projectDic objectForKey:@"LoanPeriod"]];
    }else if ([[_projectDic objectForKey:@"PeriodTypeId"] integerValue] == 3){
        _timeLabel.text = [NSString stringWithFormat:@"%@年",[_projectDic objectForKey:@"LoanPeriod"]];
    }
    
    _unRefundAmountLabel.text = [NSString stringWithFormat:@"%.2f元",[[_projectDic objectForKey:@"PrepaymentAmount"] floatValue]];
}

- (void)setupTableView
{
    _tableView.tableHeaderView = _tableHeaderView;
    [self setupHeaderRefresh:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    _tableView.separatorColor = [UIColor colorWithHexString:@"#DEDEDE"];
    [_tableView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
}

#pragma mark - Action
- (IBAction)refundAction {
    RefundViewController *vc = [[RefundViewController alloc] init];
    vc.balance = _balanceStr;
    vc.refundDic = _currentRepayMentDic;
    vc.refundProjectDic = _projectDic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projectArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    if (_projectArr.count > 0) {
        cell.refundDetailsDic = _projectArr[indexPath.row];
    }
    return cell;
}

- (void)headerRefreshloadData
{
    [_projectArr removeAllObjects];
    [self getReturnDetailsData];
    [_tableView.mj_header endRefreshing];
}

@end
