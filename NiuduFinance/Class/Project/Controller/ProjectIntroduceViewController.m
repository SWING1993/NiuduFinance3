//
//  ProjectIntroduceViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectIntroduceViewController.h"
#import "ProjectMsgTableViewCell.h"
#import "ProjectBorrowTableViewCell.h"
#import "ProjectCheckTableViewCell.h"
#import "ReturnMoneyTableViewCell.h"
#import "WindDescribeTableViewCell.h"
#import "WindDataTableViewCell.h"
#import "InvestCommitViewController.h"
#import "WindTLModel.h"
#import "ReflectUtil.h"
#import "NSString+Adding.h"

@interface ProjectIntroduceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *projectInvestTableView;
@property (nonatomic,assign)NSInteger number;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableDictionary *offscreenCell;

@property (nonatomic,strong)NSDictionary *borrowerInfoDic;
@property (nonatomic,strong)NSDictionary *creditFileDic;
@property (nonatomic,strong)NSMutableArray *documentTypeAuditsArr;

@property (nonatomic,strong)NSDictionary *riskManagementDic;
@property (nonatomic,strong)NSMutableArray *projectImageArr;

@property (nonatomic,strong)NSMutableArray *repaymentArr;
@end

@implementation ProjectIntroduceViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"项目详情";
    }
    return self;
}

- (void)setProjectId:(int)projectId
{
    _projectId = projectId;
    
    [self getProjectDetailsData];
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hideNaviBar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    _number = 0;
    _borrowerInfoDic = [NSDictionary dictionary];
    _creditFileDic = [NSDictionary dictionary];
    _documentTypeAuditsArr = [NSMutableArray array];
    
    _riskManagementDic = [NSDictionary dictionary];
    _projectImageArr = [NSMutableArray array];
    
    _repaymentArr = [NSMutableArray array];
    
    [self setTableViewInfo];
    
}
//   项目信息
- (void)getProjectDetailsData
{
    [self.httpUtil requestDic4MethodName:@"project/info" parameters:@{@"ProjectId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
            _borrowerInfoDic = [dic objectForKey:@"BorrowerInfo"];
            _creditFileDic = [dic objectForKey:@"CreditFile"];
            _documentTypeAuditsArr = [dic objectForKey:@"DocumentTypeAudits"];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_projectInvestTableView reloadData];
    }];
}
//  风控信息
- (void)getProjectWindData
{
    [self.httpUtil requestDic4MethodName:@"project/riskmanagement" parameters:@{@"ProjectId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _riskManagementDic = dic;
            _projectImageArr = [dic objectForKey:@"ProjectImage"];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_projectInvestTableView reloadData];
    }];
}
//  还款情况
- (void)getReturnDic
{
    [self.httpUtil requestArr4MethodName:@"project/repayment" parameters:@{@"ProjectId":@(_projectId)} result:^(NSArray *arr, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            [_repaymentArr addObjectsFromArray:arr];
            
            if (_repaymentArr.count == 0) {
                self.hideNoMsg = NO;
                
                self.noMsgView.top = 128;
                self.noMsgView.width = SCREEN_WIDTH;
                self.noMsgView.height = SCREEN_HEIGHT - 128;
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_projectInvestTableView reloadData];
    } convertClassName:nil key:nil];
}

- (void)setTableViewInfo
{
    _projectInvestTableView.tableFooterView = [UIView new];
    
    [_projectInvestTableView registerNib:[UINib nibWithNibName:@"ProjectMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectMsgTableViewCell"];
    [_projectInvestTableView registerNib:[UINib nibWithNibName:@"ProjectBorrowTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectBorrowTableViewCell"];
    [_projectInvestTableView registerNib:[UINib nibWithNibName:@"ProjectCheckTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectCheckTableViewCell"];
    [_projectInvestTableView registerNib:[UINib nibWithNibName:@"WindDescribeTableViewCell" bundle:nil] forCellReuseIdentifier:@"WindDescribeTableViewCell"];
    [_projectInvestTableView registerNib:[UINib nibWithNibName:@"WindDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"WindDataTableViewCell"];
    [_projectInvestTableView registerNib:[UINib nibWithNibName:@"ReturnMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReturnMoneyTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_number == 0) {
        return 3;
    }else if (_number == 1){
        if (_projectImageArr.count == 0) {
            return 1;
        }
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_number == 2) {
        return _repaymentArr.count+1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_number == 0) {
        if (indexPath.section == 0) {
            return 351;
        }else if (indexPath.section == 1){
            return 312;
        }else if (indexPath.section == 2){
            if (_documentTypeAuditsArr.count <= 3) {
                return 75;
            }
            return 105;
        }
    }else if (_number == 1){
        if (indexPath.section == 0) {
            
            NSString *riskStr = [NSString stringWithFormat:@"%@",[_riskManagementDic objectForKey:@"RiskManagement"]];
            NSString *contentStr = nil;
            NSScanner * scanner = [NSScanner scannerWithString:riskStr];
            NSString * text = nil;
            while([scanner isAtEnd]==NO)
            {
                //找到标签的起始位置
                [scanner scanUpToString:@"<" intoString:nil];
                //找到标签的结束位置
                [scanner scanUpToString:@">" intoString:&text];
                //替换字符
                contentStr = [riskStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
            }
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"p" withString:@""];
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@">" withString:@""];
            
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"br/" withString:@"\n"];
            
            CGSize riskSize =[contentStr sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedSize:CGSizeMake(SCREEN_WIDTH-20, 15000)];
            return 77 - 21 + riskSize.height;
        }else{
            if (_projectImageArr.count <= 2) {
                return 54 + 110 + 5;
            }else if (_projectImageArr.count <= 4){
                return 54 + 110 * 2 + 12 + 5;
            }else if (_projectImageArr.count <= 6){
                return 54 + 110 * 3 + 12 * 2 + 5;
            }else if (_projectImageArr.count <= 8){
                return 54 + 110 * 4 + 12 * 3 + 5;
            }else if (_projectImageArr.count <= 10){
                return 54 + 110 * 5 + 12 * 4 + 5;
            }
        }
    }else if (_number == 2){
        return 39;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_number == 0) {
        if (indexPath.section == 0) {
            static NSString  *cellId = @"ProjectMsgTableViewCell";
            ProjectMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell ==nil) {
                cell = [[ProjectMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewScrollPositionNone;
            cell.borrowerInfoDic = _borrowerInfoDic;
            return cell;
        }else if (indexPath.section == 1){
            static NSString  *cellId = @"ProjectBorrowTableViewCell";
            ProjectBorrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell ==nil) {
                cell = [[ProjectBorrowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewScrollPositionNone;
            cell.creditFileDic = _creditFileDic;
            return cell;
        }else if (indexPath.section == 2){
            static NSString  *cellId = @"ProjectCheckTableViewCell";
            ProjectCheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell ==nil) {
                cell = [[ProjectCheckTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewScrollPositionNone;
            cell.documentTypeArr = _documentTypeAuditsArr;
            return cell;
        }
    }else if (_number == 1){
        if (indexPath.section == 0) {
            static NSString  *cellId = @"WindDescribeTableViewCell";
            WindDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell ==nil) {
                cell = [[WindDescribeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewScrollPositionNone;
            cell.windDescribeStr = [_riskManagementDic objectForKey:@"RiskManagement"];
            return cell;
        }else{
            static NSString  *cellId = @"WindDataTableViewCell";
            WindDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell ==nil) {
                cell = [[WindDataTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewScrollPositionNone;
            cell.projectImageArr = _projectImageArr;
            return cell;
        }
    }else if (_number == 2){
        static NSString  *cellId = @"ReturnMoneyTableViewCell";
        ReturnMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell ==nil) {
            cell = [[ReturnMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewScrollPositionNone;
        if (_repaymentArr.count > 0 && indexPath.row > 0) {
            cell.repayDic = _repaymentArr[indexPath.row - 1];
        }
        return cell;
    }
    return nil;
}

#pragma mark WindDescribeTableViewCellDelegate
- (void)tableViewCell:(WindDescribeTableViewCell *)cell model:(WindTLModel *)model numberOfLines:(NSUInteger)numberOfLines {
    model.numberOfLines = numberOfLines;
    
    if (numberOfLines == 0) {
        model.state = TLOpenState;
    }else {
        model.state = TLCloseState;
    }
    
    [_projectInvestTableView reloadData];
}

//  项目信息
- (IBAction)projectMsgClick:(id)sender {
    _number = 0;
    self.hideNoMsg = YES;
    [self getProjectDetailsData];
    [_projectInvestTableView reloadData];
}
//  风控信息
- (IBAction)windMsgClick:(id)sender {
    _number = 1;
    self.hideNoMsg = YES;
    [self getProjectWindData];
    [_projectInvestTableView reloadData];
}
//  投资记录
- (IBAction)investCountClick:(id)sender {
    _number = 2;
    self.hideNoMsg = YES;
    [_repaymentArr removeAllObjects];
    [self getReturnDic];
    [_projectInvestTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
