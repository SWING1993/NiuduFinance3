//
//  MyBankCardViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/8.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "AddBankCardViewController.h"
#import "NetWorkingUtil.h"
#import "User.h"
#import "RealNameCertificationViewController.h"
#import "BankCardTableViewCell.h"

@interface MyBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *bankCardsArr;
@property (nonatomic,strong)NSDictionary *bankCardDic;


//h1

//单笔
@property (nonatomic, strong) UILabel * singleLabel;
//单日
@property (nonatomic, strong) UILabel * singleDayLabel;


//单笔价格
@property (nonatomic, strong) UILabel * singlLabel;
//单日价格
@property (nonatomic, strong) UILabel * singlDayLabel;
//h2

@end
static NSString * const cellIdentifer = @"BankCardTableViewCell";
@implementation MyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
    
    _bankCardsArr = [NSMutableArray array];
    
    _singleLabel     = [UILabel new];
    _singlLabel      = [UILabel new];
    _singleDayLabel  = [UILabel new];
    _singlDayLabel   = [UILabel new];
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.hideNaviBar = NO;
    [_bankCardsArr removeAllObjects];
    [self getMyBankCard];
//    [self geMyBankCard];
    
}

//- (void)getMyBankCard
//{
//    
//    [self.httpUtil requestArr4MethodNam:@"v2/accept/user/getUserInfo" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
//        if (status == 1 || status == 2) {
//            [MBProgressHUD showError:msg toView:self.view];
//            self.hideNoNetWork = NO;
//            
//        }else{
//            self.hideNoNetWork = YES;
//            [_bankCardsArr addObjectsFromArray:arr];
//            
//            NSLog(@"%@",_bankCardsArr);
//            
//            if (_bankCardsArr.count == 0) {
//                self.hideNoMsg = NO;
//            }else{
//                self.hideNoMsg = YES;
//            }
//
//        }
//        [_tableView reloadData];
//    } convertClassName:nil key:nil];
//}



- (void)getMyBankCard
{

    [self.httpUtil requestDic4MethodNam:@"v2/accept/user/getUserInfo" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        
        NSLog(@"%d",status);
        NSLog(@"%@",dic);

    }];
    
}
//- (void)geMyBankCard
//{
//
//    [self.httpUtil requestArr4MethodNam:@"v2/accept/user/queryPayQuota" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
//        if (status == 1 || status == 2) {
//            [MBProgressHUD showError:msg toView:self.view];
//            self.hideNoNetWork = NO;
//            
//        }else{
////            NSDictionary * dic = [NSDictionary new];
////            dic = [dic  ];
//            
//            self.hideNoNetWork = YES;
//            [_bankCardsArr addObjectsFromArray:arr];
//            NSLog(@"%@",_bankCardsArr);
////            for (NSDictionary * dict in _bankCardsArr) {
////                [_bankCardsArr addObject:[dict objectForKey:@""]];
////            }
//            
//            
//            if (_bankCardsArr.count == 0) {
//                self.hideNoMsg = NO;
//            }else{
//                self.hideNoMsg = YES;
//            }
//        }
//        [_tableView reloadData];
//    } convertClassName:nil key:nil];
//}



#pragma mark - Set Up UI
- (void)setupTableView{
    _tableView.tableFooterView = [UIView new];
    [self setupHeaderRefresh:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F0EFF5"];
    _tableView.separatorColor = _tableView.backgroundColor;
    
    [_tableView registerNib:[UINib nibWithNibName:@"BankCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"BankCardTableViewCell"];
}

- (void)setupNavi
{
    self.title = @"我的银行卡";
    [self backBarItem];
    //注释添加BarButton
//    [self setupBarButtomItemWithTitle:@"添加" target:self action:@selector(addBankCard) leftOrRight:NO];
}

#pragma mark - Action
- (void)addBankCard
{
    //跳转
    if ([User userFromFile].idValidate == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有实名认证，是否去实名认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        AddBankCardViewController *vc = [[AddBankCardViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        RealNameCertificationViewController *vc = [[RealNameCertificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section){
            case 0:
                 return _bankCardsArr.count;
                 break;
            case 1:
                 return 2;
                 break;
            default:
                 return 0;
                 break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[BankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }



    if (indexPath.section == 0 && indexPath.row == 0) {
        NSDictionary *dic = _bankCardsArr[indexPath.row];

        NSLog(@"%@",dic);
        [NetWorkingUtil setImage:cell.bankCardImageView url:[dic objectForKey:@"bankicon"] defaultIconName:nil];
        //银行卡号
        cell.bankCardNameLab.text = [dic objectForKey:@"bankName"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.bankCardNumberLab.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"bankCode"] stringByReplacingCharactersInRange:NSMakeRange(4, 11) withString:@"****"]];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){

        [cell addSubview:_singleLabel];
        _singleLabel.text = @"单笔限额(万元)";
        [_singleLabel setFont:[UIFont systemFontOfSize:16]];
        [_singleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@15);
            make.height.mas_equalTo(17);
        }];
        
        
        [cell addSubview:_singlLabel];
        _singlLabel.text = @"20.00";
        [_singlLabel setTextAlignment:2];
        [_singlLabel setFont:[UIFont systemFontOfSize:15]];
        [_singlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.mas_right).with.offset(-15);
            make.top.equalTo(@17);
            make.height.mas_equalTo(12);
        }];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){

        [cell addSubview:_singleDayLabel];
        _singleDayLabel.text = @"单笔限额(万元)";
        [_singleDayLabel setFont:[UIFont systemFontOfSize:16]];
        [_singleDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@15);
            make.height.mas_equalTo(17);
        }];
        
        [cell addSubview:_singlDayLabel];
        _singlDayLabel.text = @"2000.00";
        [_singlDayLabel setTextAlignment:2];
        [_singlDayLabel setFont:[UIFont systemFontOfSize:15]];
        [_singlDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.mas_right).with.offset(-15);
            make.top.equalTo(@17);
            make.height.mas_equalTo(12);
        }];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row==0) {
        return 93;
    }else{
        return 45;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}

- (void)headerRefreshloadData
{
    [_tableView.mj_header endRefreshing];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _bankCardsArr[indexPath.row];
    [self.httpUtil requestDic4MethodName:@"bankcard/delete" parameters:@{@"BankCardId":[dic objectForKey:@"BankCardId"]} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [_bankCardsArr removeAllObjects];
            [self getMyBankCard];
            [MBProgressHUD showMessag:msg toView:self.view];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}
@end
