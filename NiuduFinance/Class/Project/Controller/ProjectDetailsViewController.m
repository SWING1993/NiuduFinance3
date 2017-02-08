//
//  ProjectDetailsViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectDetailsViewController.h"
#import "ProjectDetailsTableViewCell.h"
#import "InvestCommitViewController.h"
#import "ProjectIntroduceViewController.h"
#import "InvestRecodeViewController.h"
#import "User.h"
#import "NetWorkingUtil.h"
#import "ProjectProgressView.h"
#import "NSDate+Helper.h"
#import "FinanceDetailsViewController.h"
#import "ProjectIntroduceDetailViewController.h"
#import "RechargeViewController.h"
#import "BindingBankCardViewController.h"
#import "WebPageVC.h"
#import "AppDelegate.h"

@interface ProjectDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    //H
    NSInteger     selectBttonTag;
}

@property (weak, nonatomic) IBOutlet UIButton *investBtn;
@property (weak, nonatomic) IBOutlet UITableView *projectDetailsTableView;
@property (strong, nonatomic) IBOutlet UIView *headerTableView;

//H底部tableview
@property (strong, nonatomic) IBOutlet UIView *tailTableView;
//滑动条
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UIView *xView;

@property (weak, nonatomic) IBOutlet UITableView *ziuHouTableView;


@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *projectRateLab;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *projectPeriodLab;
@property (weak, nonatomic) IBOutlet UILabel *projectPeriodTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *crazyRushLab;
@property (weak, nonatomic) IBOutlet ProjectProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *overplusLab;
@property (weak, nonatomic) IBOutlet UILabel *bidAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *returnMoneyTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *peojectAmountTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *crazyLab;
@property (weak, nonatomic) IBOutlet UILabel *PaymentInstructionsLab;

@property (nonatomic,strong)NSDictionary *projectDetailsDic;

@property (nonatomic,strong)NSDictionary *projectFinanceDic;

@property (nonatomic,strong)NSString *investAmountStr;

@property (nonatomic,strong)NSTimer *timer;

@property (strong, nonatomic) NSMutableArray *bankCardsArr;

@property (nonatomic,strong) NSMutableArray *canUseHongBaoArr;

@property (nonatomic,strong) NSString *hongbaoid;

@property (nonatomic,assign) NSInteger hongBaoCount;

@end

@implementation ProjectDetailsViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"投资详情";
        self.hideBottomBar = NO;
        self.hideNaviBar = NO;
        [self backBarItem];
        
    }
    return self;
}
- (void)setProjectId:(int)projectId
{
    _projectId = projectId;
    NSLog(@"====%d",_projectId);
}

- (void)setProductId:(int)productId
{
    _productId = productId;
    
    [self getFinanceInfoData];
}

- (void)setType:(NSString *)type
{
    _type = type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //H
    selectBttonTag = 111;

    
    _projectFinanceDic = [NSDictionary dictionary];
    _bankCardsArr = [NSMutableArray array];
    
    _hongbaoid = @"0";
    
    _hongBaoCount = 0;
    
    [self getMyBankCard];
    
    [self backBarItem];
    
    [self setTableViewInfo];
    _hongBaoArray = [NSMutableArray array];
    _canUseHongBaoArr = [NSMutableArray array];
    [self setupBarButtomItemWithImageName:@"nav_back_normal.png" highLightImageName:@"nav_back_select.png" selectedImageName:nil target:self action:@selector(backClick) leftOrRight:YES];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hongbaoIndex:) name:@"hongbaoNoti" object:nil];
}



- (IBAction)mtjButton:(id)sender {
    UIButton * btn = sender;
    UIButton * btns = [self.view viewWithTag:selectBttonTag];
    [btns setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0/255.0f green:154/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
    selectBttonTag = btn.tag;
    
    [_xView addSubview:_lineLabel];
    NSInteger x = btn.tag-111;
 
    _lineLabel.frame=CGRectMake(x*(self.view.frame.size.width/3),39, self.view.frame.size.width/3, 2);
    _lineLabel.backgroundColor = Nav019BFF;

    if (btn.tag==111)
    {
        //项目描述
    }
    else if (btn.tag==112)
    {
        //项目图片
    }
    else if (btn.tag==113)
    {
        //投资记录
    }
    
    
}





- (void)hongbaoIndex:(NSNotification *)info{
    
    NSDictionary *dic =  info.userInfo;
    
    if ([[dic objectForKey:@"hongbao"] isKindOfClass:[NSString class]]) {
        _hongbaoid = @"0";
    }else{
        _hongbaoid = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"hongbao"] objectForKey:@"sentid"]];
    }
}


- (NSDictionary *)projectDetailsDic{

    if (_projectDetailsDic==nil) {
        _projectDetailsDic = [NSDictionary dictionary];

    }
    return _projectDetailsDic;
}

- (void)backClick
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_projectId > 0) {
        [self getProjectDetailsData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePickerViewNoti" object:nil];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark -- 查看是否绑定银行卡
- (void)getMyBankCard
{
    [self.httpUtil requestArr4MethodName:@"fund/bankcard" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
            [_bankCardsArr addObjectsFromArray:arr];
            
            [self.projectDetailsTableView reloadData];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } convertClassName:nil key:nil];
}




//  散标
- (void)getProjectDetailsData
{
    [self.httpUtil requestDic4MethodName:@"project/index" parameters:@{@"ProjectId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _projectDetailsDic = dic;
        
//            [_hongBaoArray removeAllObjects];
            
            if ([[dic objectForKey:@"Bouns"] count] != 0) {
                _hongBaoArray = [dic objectForKey:@"Bouns"];
            
                [self loadHongBaoArray];
            }else{
                _hongbaoid = @"0";
            }
            [self setHeaderInfo];
            
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_projectDetailsTableView reloadData];
    }];
    
    
}

- (void)loadHongBaoArray{
    
    NSString *noUseHongBao = @"不使用现金券";
    [self.canUseHongBaoArr addObject:noUseHongBao];
    
    for (int i=0; i<_hongBaoArray.count; i++) {
        
        NSString *hongBaoStr = [NSString stringWithFormat:@"%@元现金券,投资%@可用",[_hongBaoArray[i] objectForKey:@"bounsvalue"],[_hongBaoArray[i] objectForKey:@"bidamount"]];
        
        [self.canUseHongBaoArr addObject:hongBaoStr];
    }
}

- (void)setHeaderInfo
{
   
    [NetWorkingUtil setImage:_projectImageView url:[_projectDetailsDic objectForKey:@"IconUrl"] defaultIconName:nil];
    _projectTitleLab.text = [_projectDetailsDic objectForKey:@"Title"];
    
    if ([[_projectDetailsDic objectForKey:@"AmountTypeId"] integerValue] == 1){
        _projectAmountLab.text = [NSString stringWithFormat:@"%@", [_projectDetailsDic objectForKey:@"Amount"]];
        _peojectAmountTypeLab.text = @"元";
        
    }else{
        _projectAmountLab.text = [NSString stringWithFormat:@"%@", [_projectDetailsDic objectForKey:@"Amount"]];
         _peojectAmountTypeLab.text = @"万";
    }
    
    _projectRateLab.text = [NSString stringWithFormat:@"%.2f",[[_projectDetailsDic objectForKey:@"LoanRate"] floatValue]];
    _projectPeriodLab.text = [NSString stringWithFormat:@"%@",[_projectDetailsDic objectForKey:@"LoanDate"]];
    if ([[_projectDetailsDic objectForKey:@"PeriodTypeId"] integerValue] == 1) {
        _projectPeriodTypeLab.text = @"天";
    }else if ([[_projectDetailsDic objectForKey:@"PeriodTypeId"] integerValue] == 2){
        _projectPeriodTypeLab.text = @"个月";
    }else if ([[_projectDetailsDic objectForKey:@"PeriodTypeId"] integerValue] == 3){
        _projectPeriodTypeLab.text = @"年";
    }
   
    
    _progressView.progressValue = [[_projectDetailsDic objectForKey:@"Progress"] floatValue];
    
    _overplusLab.text =  _overplusLab.text = [NSString stringWithFormat:@"%@元", [_projectDetailsDic objectForKey:@"SurplusAmount"]];
    _bidAmountLab.text = [NSString stringWithFormat:@"%@元",[_projectDetailsDic objectForKey:@"MinAmount"]];
    _returnMoneyTypeLab.text = [_projectDetailsDic objectForKey:@"RepaymentType"];
    _PaymentInstructionsLab.text = [_projectDetailsDic objectForKey:@"PaymentInstructions"];
    if ([[_projectDetailsDic objectForKey:@"IsCanBid"] integerValue] == 0) {
        _investBtn.userInteractionEnabled = NO;
        _investBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }
    
    [_investBtn setTitle:[_projectDetailsDic objectForKey:@"StatusName"] forState:UIControlStateNormal];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeMethodGo:) userInfo:nil repeats:YES];
}
//   判断倒计时
-(void)timeMethodGo:(NSTimer *)timer{
    
    
    if ([_type isEqual:@"理财"]) {
        NSDateComponents *day = [NSDate timeMethodGo:[_projectFinanceDic objectForKey:@"EffectiveDate"]];
        if ([[_projectFinanceDic objectForKey:@"IsFinish"] intValue] == 0) {
            _crazyLab.text = @"疯抢中:";
            _crazyRushLab.text = [NSString stringWithFormat:@" %ld天%ld小时%ld分%ld秒",(long)[day day] , (long)[day hour], (long)[day minute], (long)[day second]];
        }else{
            if ([_statueId intValue] == 1) {
                _crazyLab.text = @"预售中";
            }else{
                _crazyLab.text = @" 已售罄";
            }
            _crazyRushLab.text = @"";
            if (_timer.isValid) {
                [_timer invalidate];
            }
            _timer = nil;
        }
    }else{
        if ([[_projectDetailsDic objectForKey:@"IsFinish"] intValue] == 0) {
            _crazyLab.text = @"开标时间:";
            _crazyRushLab.text = [NSString stringWithFormat:@"%@",[_projectDetailsDic objectForKey:@"RemainTime"]];
        }else{
            if ([_statueId intValue] == 0) {
                _crazyLab.text = @"预审中";
            }else{
                _crazyLab.text = @"已结束";
            }
            _crazyRushLab.text = @"";
            if (_timer.isValid) {
                [_timer invalidate];
            }
            _timer = nil;
        }
    }
}
//  理财
- (void)getFinanceInfoData
{
    [self.httpUtil requestDic4MethodName:@"financialproduct/index" parameters:@{@"ProductId":@(_productId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            _projectFinanceDic = dic;
            
            [self setHeaderFinanceInfo];
//            [self loadHongBaoArray];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        if (_projectFinanceDic != nil) {
            [_projectDetailsTableView reloadData];
        }
    }];
}



- (void)setHeaderFinanceInfo
{
    _projectImageView.image = [UIImage imageNamed:@"home_youxuan"];
    _projectTitleLab.text = [_projectFinanceDic objectForKey:@"Title"];
    
    if ([[_projectFinanceDic objectForKey:@"AmountTypeId"] integerValue] == 1){
        _projectAmountLab.text = [NSString stringWithFormat:@"%@", [_projectFinanceDic objectForKey:@"Amount"]];
        _peojectAmountTypeLab.text = @"元";
    }else{
        _projectAmountLab.text = [NSString stringWithFormat:@"%@", [_projectFinanceDic objectForKey:@"Amount"]];
    }
    _projectRateLab.text = [NSString stringWithFormat:@"%@",[_projectFinanceDic objectForKey:@"Rate"]];
    _projectPeriodLab.text = [NSString stringWithFormat:@"%@",[_projectFinanceDic objectForKey:@"LoanPeriod"]];
    _projectPeriodTypeLab.text = [_projectFinanceDic objectForKey:@"LoanDate"];
    
    
    _progressView.progressValue = [[_projectFinanceDic objectForKey:@"Progress"] floatValue];
    if ([[_projectFinanceDic objectForKey:@"OverplusTypeId"] integerValue] == 1) {
        _overplusLab.text = [NSString stringWithFormat:@"%@元",[_projectFinanceDic objectForKey:@"Overplus"]];
    }else{
        _overplusLab.text = [NSString stringWithFormat:@"%@万元",[_projectFinanceDic objectForKey:@"Overplus"]];
    }
    
    _bidAmountLab.text = [NSString stringWithFormat:@"%@元  (10元/份)",[_projectFinanceDic objectForKey:@"MinAmount"]];
    _returnMoneyTypeLab.text = [_projectFinanceDic objectForKey:@"RepaymentTypeId"];
    
    if ([[_projectFinanceDic objectForKey:@"IsFinish"] integerValue] == 0) {
        _investBtn.userInteractionEnabled = NO;
        _investBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeMethodGo:) userInfo:nil repeats:YES];
}

- (void)setTableViewInfo
{
    _projectDetailsTableView.tableHeaderView = _headerTableView;
    
    _projectDetailsTableView.tableFooterView = _tailTableView;
    
    [_projectDetailsTableView registerNib:[UINib nibWithNibName:@"ProjectDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectDetailsTableViewCell"];
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
    return 193;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *cellId = @"ProjectDetailsTableViewCell";
    ProjectDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[ProjectDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.delegate = self;
    if ([_type isEqual:@"理财"]) {
        if (IsStrEmpty([_projectFinanceDic objectForKey:@"AvailableBalance"])) {
            cell.availableBalanceStr = @"0";
        }else{
            cell.availableBalanceStr = [NSString stringWithFormat:@"%@",[_projectFinanceDic objectForKey:@"AvailableBalance"]];
        }
        
        cell.type = @"理财";
        cell.investTextField.userInteractionEnabled = YES;
        if (_hongBaoArray.count == 0) {
            cell.hongbaoTextField.text = @"无可用现金券";
        }else{
            cell.hongbaoTextField.text = [NSString stringWithFormat:@"%ld个现金券可用",_hongBaoArray.count];
        }
        
//        cell.hongbaoArray = self.canUseHongBaoArr;
        cell.dic = _projectFinanceDic;
    }else{
        
        if (![_projectDetailsDic objectForKey:@"AvailableBalance"]) {
            cell.availableBalanceStr = @"0";
        }else{
            cell.availableBalanceStr = [NSString stringWithFormat:@"%@",[_projectDetailsDic objectForKey:@"AvailableBalance"]];
        
        }
        cell.dic = _projectDetailsDic;
        cell.investTextField.userInteractionEnabled = YES;
        cell.investTextField.delegate = self;
        if (_hongBaoArray.count == 0) {
            cell.hongbaoTextField.text = @"无可用现金券";
            cell.hongBaoButton.userInteractionEnabled = NO;
        }else{
            
            if (IsStrEmpty(_investAmountStr)) {
                
                cell.hongbaoTextField.text = [NSString stringWithFormat:@"%ld个现金券可用",_hongBaoArray.count];
                cell.hongBaoButton.userInteractionEnabled = YES;
            }else{
                if (_hongBaoCount == 0) {
                    cell.hongbaoTextField.text = @"无可用现金券";
                    cell.hongBaoButton.userInteractionEnabled = NO;
                }else{
                    cell.hongbaoTextField.text = [NSString stringWithFormat:@"%ld个现金券可用",_hongBaoCount];
                    cell.hongBaoButton.userInteractionEnabled = YES;
                }
            }
            cell.getHongBaoArray = _hongBaoArray;
            cell.hongbaoArray = self.canUseHongBaoArr;
        }
    }
    [cell.investTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (void)textFieldChange:(UITextField *)textField
{
    _investAmountStr = textField.text;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextBeginHidePickerViewNoti" object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _hongBaoCount = 0;
    
    if (!IsStrEmpty(_investAmountStr)) {
        
        NSString *loanDateStr = @"";
        
        if ([[_projectDetailsDic objectForKey:@"PeriodTypeId"] integerValue] == 1) {
            loanDateStr = [NSString stringWithFormat:@"%ld",[[_projectDetailsDic objectForKey:@"LoanDate"] integerValue] / 30];
        }else if ([[_projectDetailsDic objectForKey:@"PeriodTypeId"] integerValue] == 2){
            loanDateStr = [NSString stringWithFormat:@"%@",[_projectDetailsDic objectForKey:@"LoanDate"]];
        }else if ([[_projectDetailsDic objectForKey:@"PeriodTypeId"] integerValue] == 3){
            loanDateStr = [NSString stringWithFormat:@"%ld",[[_projectDetailsDic objectForKey:@"LoanDate"] integerValue] * 12];
        }
        
        for (int i = 0; i < _hongBaoArray.count; i ++) {
            if ([_investAmountStr integerValue] >=[[_hongBaoArray[i] objectForKey:@"bidamount"] integerValue] && [loanDateStr integerValue] >= [[_hongBaoArray[i] objectForKey:@"loanperiod"] integerValue]) {
                
                _hongBaoCount ++;
            }
        }
    }
    [self.projectDetailsTableView reloadData];
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
        
        if ([[_projectDetailsDic objectForKey:@"IsNewLender"] integerValue] == 1 &&  [[_projectDetailsDic objectForKey:@"IsBid"] integerValue] == 1) {
            [MBProgressHUD showMessag:@"您已不是新手了，不能投资新手专享标" toView:self.view];
            return;
        }
        
        if (IsStrEmpty(_investAmountStr)) {
            [MBProgressHUD showMessag:@"请输入投资金额" toView:self.view];
            return;
        }
        
        if ([[_projectDetailsDic objectForKey:@"BorrowerId"] integerValue] == [User shareUser].userId) {
            [MBProgressHUD showMessag:@"不能给自己投标" toView:self.view];
            return;
        }
        
        if ([_investAmountStr floatValue] < [[_projectDetailsDic objectForKey:@"MinAmount"] floatValue]) {
            [MBProgressHUD showMessag:@"投标金额低于起投金额,不能投标" toView:self.view];
            return;
        }else{
            
            if ([_investAmountStr floatValue] > [[_projectDetailsDic objectForKey:@"MaxAmount"] floatValue]) {
                [MBProgressHUD showMessag:@"投标金额高于最大投标金额,不能投标" toView:self.view];
                return;
            }else{
                
                if ([_investAmountStr integerValue]%10 != 0) {
                    [MBProgressHUD showMessag:@"投标金额不是10的倍数,不能投标" toView:self.view];
                    return;
                }
                
            }
        }
        
        if ([_investAmountStr integerValue] >  [[_projectDetailsDic objectForKey:@"AvailableBalance"] integerValue]){
            
            
            [MBProgressHUD showMessag:@"余额不足,请先充值" toView:self.view];
            return;
            
//            if ([[_projectDetailsDic objectForKey:@"SurplusAmount"] integerValue] > [[_projectDetailsDic objectForKey:@"AvailableBalance"] floatValue]) {
//               
//                
//            }else{
//                
//                if ([_investAmountStr floatValue] > [[_projectDetailsDic objectForKey:@"AvailableBalance"] floatValue]) {
//                    
//                    [MBProgressHUD showMessag:@"余额不足,请先充值" toView:self.view];
//                    return;
//                }
//            }
        }
        
        if (_timer.isValid) {
            [_timer invalidate];
        }
        _timer = nil;
        
        WebPageVC *vc = [WebPageVC new];
        vc.name = @"bidproject";
        
        if ([_investAmountStr integerValue] > [[_projectDetailsDic objectForKey:@"SurplusAmount"] integerValue]) {
            _investAmountStr = [NSString stringWithFormat:@"%@",[_projectDetailsDic objectForKey:@"SurplusAmount"]];
        }
        NSDictionary *dic = @{@"projectId":[_projectDetailsDic objectForKey:@"ProjectId"],@"bidAmount":_investAmountStr,@"BounsId":_hongbaoid};
        vc.dic = dic;
        vc.title = @"投资确认";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 投资记录
- (IBAction)investCountClick:(id)sender {
    
    InvestRecodeViewController *investRecodeVC = [InvestRecodeViewController new];
    investRecodeVC.urlStr = @"project/bidinfo";
    investRecodeVC.projectId = _projectId;
    [self.navigationController pushViewController:investRecodeVC animated:YES];
}

//  项目详情

- (IBAction)projectDetailsClick:(id)sender {
    
    ProjectIntroduceDetailViewController *projectIntroduceVC = [ProjectIntroduceDetailViewController new];
    projectIntroduceVC.projectId = _projectId;
    NSLog(@"test==%d",_projectId);
    [self.navigationController pushViewController:projectIntroduceVC animated:YES];
}

- (void)projectTableViewCell:(ProjectDetailsTableViewCell *)cell supportProject:(id)project
{
    if ([AppDelegate checkLogin]) {
        
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
