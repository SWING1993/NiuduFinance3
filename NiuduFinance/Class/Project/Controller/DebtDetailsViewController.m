//
//  DebtDetailsViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "DebtDetailsViewController.h"
#import "DebtDetailsTableViewCell.h"
#import "DebtNewsTableViewCell.h"
#import "InvestCommitViewController.h"
#import "NSString+Adding.h"
#import "NetWorkingUtil.h"
#import "NSDate+Helper.h"
#import "DebtCommitViewController.h"
#import "User.h"
#import "ProjectProgressView.h"
#import "BackMoneyViewController.h"
#import "RechargeViewController.h"
#import "BindingBankCardViewController.h"
#import "InvestRecodeViewController.h"
#import "ProjectIntroduceDetailViewController.h"
#import "WebPageVC.h"
#import "AppDelegate.h"

@interface DebtDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *debtDetailsTableView;
@property (strong, nonatomic) IBOutlet UIView *headerTableView;
@property (weak, nonatomic) IBOutlet UIButton *investBtn;
@property (weak, nonatomic) IBOutlet UIImageView *debtImageView;
@property (weak, nonatomic) IBOutlet UILabel *debtTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *debtAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *debtRateLab;
@property (weak, nonatomic) IBOutlet UILabel *crazyRushLab;
@property (weak, nonatomic) IBOutlet UILabel *owingAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *debtAmountTypelab;
@property (weak, nonatomic) IBOutlet UILabel *crazyLab;
//进度条
@property (weak, nonatomic) IBOutlet ProjectProgressView *progressView;
//剩余期限
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
//剩余份数
@property (weak, nonatomic) IBOutlet UILabel *SurplusNumLabel;
//剩余期限类型 day month
@property (weak, nonatomic) IBOutlet UILabel *deadLineTypeLabel;

//起投份数
@property (weak, nonatomic) IBOutlet UILabel *intoNumLabel;
//还款类型
@property (weak, nonatomic) IBOutlet UILabel *repaymentTypeLabel;
//待收本息
@property (weak, nonatomic) IBOutlet UILabel *getProfitLabel;
//原年化收益
@property (weak, nonatomic) IBOutlet UILabel *oldRateLabel;
//下个还款日期
@property (weak, nonatomic) IBOutlet UILabel *nextRepaymentDataLabel;


@property (nonatomic,strong) NSString *investTextField;

@property (nonatomic,strong)NSDictionary *debtDealDic;
@property (nonatomic,strong)NSDictionary *projectDic;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSArray *bidsArr;
@property (nonatomic,strong) NSArray *repaymentArr;
//账户余额

@property (nonatomic,strong) NSString *accountNum;

@property (strong, nonatomic) NSMutableArray *bankCardsArr;

@property (nonatomic,strong)NSTimer *timer;
@end

@implementation DebtDetailsViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"转让详情";
        self.hideBottomBar = YES;
    }
    return self;
}

- (void)setDebtID:(int)debtID
{
    _debtID = debtID;
    NSLog(@"=======%d",_debtID);
    
    [self getDebtData];
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hideNaviBar = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_debtID > 0) {
        [self getDebtData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    _bankCardsArr = [NSMutableArray array];
    
    _dic = [NSDictionary dictionary];
    _bidsArr = [NSArray array];
    _repaymentArr = [NSArray array];
    [self getMyBankCard];
    [self setTableViewInfo];
    
    
    [self setupBarButtomItemWithImageName:@"nav_back_normal.png" highLightImageName:@"nav_back_select.png" selectedImageName:nil target:self action:@selector(backClick) leftOrRight:YES];
}

- (void)backClick
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDebtData
{
    [self.httpUtil requestDic4MethodName:@"debtdeal/index" parameters:@{@"DebtID":@(_debtID)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            _dic = dic;
            _debtDealDic = [dic objectForKey:@"DebtDeal"];
            _projectDic = [dic objectForKey:@"Project"];
            _repaymentArr = [dic objectForKey:@"Repayment"];
            _bidsArr = [dic objectForKey:@"Bids"];
            self.accountNum = [dic objectForKey:@"AvailableBalance"];
            
            [self setHeaderInfo];
        }else{
            
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_debtDetailsTableView reloadData];
    }];
}

- (void)setHeaderInfo
{
    [NetWorkingUtil setImage:_debtImageView url:[_projectDic objectForKey:@"IconUrl"] defaultIconName:nil];
    _debtTitleLab.text = [_debtDealDic objectForKey:@"Title"];
    _deadlineLabel.text = [NSString stringWithFormat:@"%@",[_projectDic objectForKey:@"Month"]];
    if ([[_debtDealDic objectForKey:@"PriceForSaleTypeId"] integerValue] == 1){
        _debtAmountLab.text = [NSString stringWithFormat:@"%@",[_debtDealDic objectForKey:@"PriceForSale"]];
        _debtAmountTypelab.text = @"元";
    }else{
        
        _debtAmountLab.text = [NSString stringWithFormat:@"%@",[_debtDealDic objectForKey:@"PriceForSale"]];
         _debtAmountTypelab.text = @"万";
    }
    //剩余份数
    _SurplusNumLabel.text = [NSString stringWithFormat:@"%ld份",[[_debtDealDic objectForKey:@"Surplus"] integerValue]];
    //起购份数
 
    _intoNumLabel.text = [NSString stringWithFormat:@"%ld份 (%.2f元/份)",[[_debtDealDic objectForKey:@"Minbidamount"] integerValue],[[_debtDealDic objectForKey:@"Share"] floatValue]];
    //还款方式
    _repaymentTypeLabel.text = [NSString stringWithFormat:@"%@",[_projectDic objectForKey:@"RepaymentType"]];
    //待收本息
    
    _getProfitLabel.text = [NSString stringWithFormat:@"%@元",[_debtDealDic objectForKey:@"ReceivableAmount"]];
    //原年化收益
    _oldRateLabel.text = [NSString stringWithFormat:@"%.2f％",[[_projectDic objectForKey:@"Rate"] floatValue]];
    
    
    //下个还款日期
    _nextRepaymentDataLabel.text = [NSString stringWithFormat:@"%@",[_debtDealDic objectForKey:@"NextRepayDate"]];
    
    _debtRateLab.text = [NSString stringWithFormat:@"%@",[_debtDealDic objectForKey:@"Rate"]];
    
    _progressView.progressValue = [[_debtDealDic objectForKey:@"Progress"] floatValue];
//    _progressView.isShowProgressText = NO;
    
    _owingAmountLab.text = [NSString stringWithFormat:@"%@元",[_debtDealDic objectForKey:@"OwingPrincipal"]];
    CGFloat discountAmount = [[_debtDealDic objectForKey:@"OwingPrincipal"] floatValue] - [[_debtDealDic objectForKey:@"PriceForSale"] floatValue];
    _discountAmountLab.text = [NSString stringWithFormat:@"%.2f元",discountAmount];
    
    if ([[_debtDealDic objectForKey:@"SellerUserId"] integerValue] == [User shareUser].userId)
    {
        _investBtn.userInteractionEnabled = NO;
        _investBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }
    
    if ([[_debtDealDic objectForKey:@"Surplus"] integerValue] == 0) {
        _investBtn.userInteractionEnabled = NO;
        _investBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeMethodGo:) userInfo:nil repeats:YES];
    _crazyRushLab.text = [NSString stringWithFormat:@"%@",[_debtDealDic objectForKey:@"ValidDate"]];
}

//-(void)timeMethodGo:(NSTimer *)timer
//{
//    NSDateComponents *day = [NSDate timeMethodGo:[_debtDealDic objectForKey:@"ValidDate"]];
//    
//    
//    if ([[_debtDealDic objectForKey:@"StatusId"] intValue] == 1) {
//        _crazyLab.text = @"疯抢中:";
//        _crazyRushLab.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分%ld秒",(long)[day day] , (long)[day hour], (long)[day minute], (long)[day second]];
//    }else{
//        _crazyLab.text = @" 已结束";
//        _crazyRushLab.text = @"";
//        if (_timer.isValid) {
//            [_timer invalidate];
//        }
//        _timer = nil;
//    }
//}

- (void)setTableViewInfo
{
    _debtDetailsTableView.tableHeaderView = _headerTableView;
    _debtDetailsTableView.tableFooterView = [UIView new];
    
    [_debtDetailsTableView registerNib:[UINib nibWithNibName:@"DebtDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DebtDetailsTableViewCell"];
//    [_debtDetailsTableView registerNib:[UINib nibWithNibName:@"DebtNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DebtNewsTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *cellId = @"DebtDetailsTableViewCell";
    DebtDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell ==nil) {
        
        cell = [[DebtDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.delegate = self;
    
    [cell.investTextField addTarget:self action:@selector(investTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    if (!IsStrEmpty(self.accountNum)) {
        cell.availableBalanceStr = self.accountNum;
    }

    cell.dic = _dic;
    
    return cell;
}

- (void)investTextFieldChange:(UITextField *)textField{

    _investTextField = textField.text;
}

- (IBAction)btnClickEvent:(id)sender {
    
    if ([AppDelegate checkLogin]){
        if ([[User userFromFile].isOpenAccount integerValue] == 0) {
            WebPageVC *vc = [[WebPageVC alloc] init];
            vc.title = @"开通汇付账户";
            vc.name = @"huifu/openaccount";
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        if (IsStrEmpty(_investTextField)) {
            [MBProgressHUD showMessag:@"请输入投资份数" toView:self.view];
            return;
        }
        
        if ([_investTextField integerValue] < [[_debtDealDic objectForKey:@"Minbidamount"] integerValue]) {
            [MBProgressHUD showMessag:@"投资份数低于起购份数,不能购买" toView:self.view];
            return;
        }
        
        if ([_investTextField integerValue] < [[_debtDealDic objectForKey:@"Surplus"] integerValue]){
            if ([[_debtDealDic objectForKey:@"Surplus"] integerValue] * [[_debtDealDic objectForKey:@"Share"] floatValue] > [self.accountNum floatValue]) {
                [MBProgressHUD showMessag:@"余额不足,请先充值" toView:self.view];
                return;
            }else{
                if ([_investTextField integerValue] * [[_debtDealDic objectForKey:@"Share"] floatValue] > [self.accountNum floatValue]) {
                    [MBProgressHUD showMessag:@"余额不足,请先充值" toView:self.view];
                    return;
                }
            }
        }
        
        if (_timer.isValid) {
            [_timer invalidate];
        }
        
        _timer = nil;
        
        //提交时的数据请求
        WebPageVC *vc = [[WebPageVC alloc] init];
        vc.title = @"债权确认";
        vc.name = @"debtdeal/buy";
        if ([_investTextField integerValue] > [[_debtDealDic objectForKey:@"Surplus"] integerValue]) {
            _investTextField = [NSString stringWithFormat:@"%@",[_debtDealDic objectForKey:@"Surplus"]];
        }
        vc.dic = @{@"DebtDealId":[_debtDealDic objectForKey:@"Id"],@"Num":_investTextField};
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)projectTableViewCell:(DebtDetailsTableViewCell *)cell supportProject:(id)project
{
    if ([AppDelegate checkLogin]) {
        //开通汇付
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
    

}
#pragma mark -- 查看是否绑定银行卡
- (void)getMyBankCard
{
    [self.httpUtil requestArr4MethodName:@"fund/bankcard" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
            [_bankCardsArr addObjectsFromArray:arr];
            
            [self.debtDetailsTableView reloadData];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } convertClassName:nil key:nil];
}

//转账记录

- (IBAction)transferMoneyButton:(id)sender {
    
    
    
    InvestRecodeViewController *investRecodeVC = [InvestRecodeViewController new];
    
//    investRecodeVC.urlStr = @"financialproduct/bidinfo";
//    investRecodeVC.productId = _debtID;
//    investRecodeVC.title = @"转账记录";
    investRecodeVC.isTransfer = YES;
    
    investRecodeVC.debtArr = _bidsArr;

    [self.navigationController pushViewController:investRecodeVC animated:YES];
}


//项目详情
- (IBAction)projectDetailButton:(id)sender {
    ProjectIntroduceDetailViewController *projectIntroduceVC = [ProjectIntroduceDetailViewController new];
//    projectIntroduceVC.projectId = _debtID;
    projectIntroduceVC.title = @"项目详情";
    projectIntroduceVC.debtProjectDic = _projectDic;
    [self.navigationController pushViewController:projectIntroduceVC animated:YES];
}

//回款计划
- (IBAction)backMoneyPlayButton:(id)sender {
    
    BackMoneyViewController *backMoeyVC = [[BackMoneyViewController alloc] init];
//    backMoeyVC.debtId = _debtID;
    backMoeyVC.title = @"回款计划";
    backMoeyVC.backPlayArr = _repaymentArr;
    [self.navigationController pushViewController:backMoeyVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
