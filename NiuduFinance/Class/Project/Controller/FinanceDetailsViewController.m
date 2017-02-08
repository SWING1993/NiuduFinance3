//
//  FinanceDetailsViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FinanceDetailsViewController.h"
#import "FinanceBuyTableViewCell.h"
#import "FinanceRiskTableViewCell.h"
#import "InvestCommitViewController.h"
#import "NSString+Adding.h"

@interface FinanceDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *financeDetailsTableView;
@property (strong, nonatomic) IBOutlet UIView *headerTableView;
@property (weak, nonatomic) IBOutlet UIButton *investBtn;
@property (weak, nonatomic) IBOutlet UILabel *financeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *financeRateLab;
@property (weak, nonatomic) IBOutlet UILabel *financeBuyLab;
@property (weak, nonatomic) IBOutlet UILabel *financeSellTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *financeIncomeLab;

@property (nonatomic,strong)NSDictionary *financeDetailsDic;
@end

@implementation FinanceDetailsViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"项目详情";
        self.hideBottomBar = YES;
    }
    return self;
}

- (void)setProjectId:(int)projectId
{
    _projectId = projectId;
    
    [self getFinanceDetailsData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    
    
    [self setTableViewInfo];
}

- (NSDictionary *)financeDetailsDic{
    
    if (_financeDetailsDic == nil) {
        _financeDetailsDic = [NSDictionary dictionary];
    }
    return _financeDetailsDic;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.hideNaviBar = NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hideNaviBar = NO;
}

- (void)getFinanceDetailsData
{
    [self.httpUtil requestDic4MethodName:@"financialproduct/index" parameters:@{@"ProductId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
       
        if (status == 1 || status == 2) {
            _financeDetailsDic = dic;
            
            [self setHeaderInfo];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)setHeaderInfo
{
    _financeTitleLab.text = [NSString stringWithFormat:@"%@%@",[_financeDetailsDic objectForKey:@"Title"],[_financeDetailsDic objectForKey:@"Name"]];
    _financeRateLab.text = [NSString stringWithFormat:@"%@%s",[_financeDetailsDic objectForKey:@"Rate"],"%"];
    _financeBuyLab.text = [[[NSString stringWithFormat:@"%@",[_financeDetailsDic objectForKey:@"MaxAmount"]] strmethodComma] stringByAppendingString:@"元"];
    _financeSellTimeLab.text = [_financeDetailsDic objectForKey:@"BeginDate"];
    _financeIncomeLab.text = [_financeDetailsDic objectForKey:@"ExpectDate"];
    if ([[_financeDetailsDic objectForKey:@"IsBid"] integerValue] == 0) {
        _investBtn.userInteractionEnabled = NO;
        _investBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }
}

- (void)setTableViewInfo
{
    _financeDetailsTableView.tableHeaderView = _headerTableView;
    _financeDetailsTableView.tableFooterView = [UIView new];
    
    [_financeDetailsTableView registerNib:[UINib nibWithNibName:@"FinanceRiskTableViewCell" bundle:nil] forCellReuseIdentifier:@"FinanceRiskTableViewCell"];
    [_financeDetailsTableView registerNib:[UINib nibWithNibName:@"FinanceBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"FinanceBuyTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 158;
    }
    return 232;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString  *cellId = @"FinanceRiskTableViewCell";
        FinanceRiskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell ==nil) {
            cell = [[FinanceRiskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewScrollPositionNone;
        return cell;
    }else if (indexPath.section == 1){
        static NSString  *cellId = @"FinanceBuyTableViewCell";
        FinanceBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell ==nil) {
            cell = [[FinanceBuyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewScrollPositionNone;
        return cell;
    }
    return nil;
}
- (IBAction)btnClickEvent:(id)sender {
    InvestCommitViewController *investCommitVC = [InvestCommitViewController new];
    [self.navigationController pushViewController:investCommitVC  animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
