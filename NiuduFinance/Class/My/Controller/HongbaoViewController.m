//
//  HongbaoViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/12.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "HongbaoViewController.h"
#import "MyDisperseInvestCell.h"
//#import "HongBaoCell.h"
#import "BenefitsCell.h"

@interface HongbaoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *StateButtonsArray;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) UIButton *hongbaoStateButton;

@property (assign, nonatomic) HongbaoState hongbaoState;

//测试用
@property (nonatomic,assign)NSInteger allBidPage;
@property (nonatomic,assign)NSInteger allBidCount;
//@property (nonatomic,strong)NSMutableArray *allBidCountArr;
@property (nonatomic,strong) NSDictionary *hongBaoAllDic;
@property (nonatomic,strong) NSMutableArray *hongBaoArr;

@end
//static NSString * const cellIdentifier = @"HongbaoCell";
@implementation HongbaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的福利";
    [self backBarItem];
    [self loadTableView];
    
    
    
    _hongBaoAllDic = [NSDictionary dictionary];
    _hongBaoArr = [NSMutableArray array];
    _allBidPage = 1;
    _allBidCount = 0;
    
    _hongbaoState = HongbaoStateCanUser;
    _hongbaoStateButton = _StateButtonsArray[2];
    
    [self loadCanHongBaoData];
    [_hongbaoStateButton setTitleColor:NaviColor forState:UIControlStateNormal];
    
}


- (void)loadTableView{

    [self setupRefreshWithTableView:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _tableview.backgroundColor = [UIColor colorWithHexString:@"#F0EFF5"];
    _tableview.tableFooterView = [UIView new];
    
    [_tableview registerNib:[UINib nibWithNibName:@"BenefitsCell" bundle:nil] forCellReuseIdentifier:@"BenefitsCell"];

}


#pragma mark -- tableViewdelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _hongBaoArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BenefitsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BenefitsCell"];
    
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell creditorState:_hongbaoState model:_hongBaoArr[indexPath.row]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- Action

- (IBAction)optionStateAction:(UIButton *)sender {
    
//    _hongbaoStateButton.selected = !_hongbaoStateButton.selected;
    _hongBaoArr = [NSMutableArray array];
    _allBidPage = 1;
    _allBidCount = 0;
    [_hongBaoArr removeAllObjects];
    if (sender == _hongbaoStateButton) {
        return;
    }else{
        
        _hongbaoStateButton.selected = NO;
        sender.selected = YES;
        [_hongbaoStateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    _hongbaoStateButton = sender;
    [_hongbaoStateButton setTitleColor:NaviColor forState:UIControlStateNormal];
    if (_hongbaoStateButton == _StateButtonsArray[2]) {
        
        self.hongbaoState = HongbaoStateCanUser;
        
        [self loadCanHongBaoData];
    }
    if (_hongbaoStateButton == _StateButtonsArray[1]) {
       
        self.hongbaoState = HongbaoStateUsed;
        [self loadUsedHongBaoData];
    }
    if (_hongbaoStateButton == _StateButtonsArray[0]) {
        
        self.hongbaoState = HongbaoStateAbandon;
        [self loadAbandonHongBaoData];
    }
}


- (void)setHongbaoState:(HongbaoState)hongbaoState
{
    _hongbaoState = hongbaoState;
//    [_tableview reloadData];
}
//可用的红包
- (void)loadCanHongBaoData{
    MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    
    
    [self.httpUtil requestDic4MethodName:@"bouns/mybouns" parameters:@{@"Page":@(_allBidPage),@"StatusId":@(0)} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            [hud hide:YES];
            self.hideNoNetWork = YES;
            if (_allBidPage == 1&&_hongBaoArr.count != 0) {
                _hongBaoArr = [NSMutableArray array];
            }
            [_tableview.mj_footer resetNoMoreData];
            
            _hongBaoAllDic = dic;
            [_hongBaoArr addObjectsFromArray:[_hongBaoAllDic objectForKey:@"Data"]];
            _allBidCount = [[_hongBaoAllDic objectForKey:@"RecordCount"] integerValue];
            if (_hongBaoArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 53;
                self.noMsgView.height = SCREEN_HEIGHT - 53;
                self.noMsgView.width = SCREEN_WIDTH;
                
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 53;
            self.noNetWorkView.height = SCREEN_HEIGHT - 53;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        [_tableview reloadData];
    }];
   
}
//已近使用的红包
- (void)loadUsedHongBaoData{

    MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestDic4MethodName:@"bouns/mybouns" parameters:@{@"Page":@(_allBidPage),@"StatusId":@(1)} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            [hud hide:YES];
            self.hideNoNetWork = YES;
            if (_allBidPage == 1) {
                _hongBaoArr = [NSMutableArray array];
            }
            [_tableview.mj_footer resetNoMoreData];
            
            _hongBaoAllDic = dic;
            [_hongBaoArr addObjectsFromArray:[_hongBaoAllDic objectForKey:@"Data"]];
            _allBidCount = [[_hongBaoAllDic objectForKey:@"RecordCount"] integerValue];

            if (_hongBaoArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 53;
                self.noMsgView.height = SCREEN_HEIGHT - 53;
                self.noMsgView.width = SCREEN_WIDTH;
                
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 53;
            self.noNetWorkView.height = SCREEN_HEIGHT - 53;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        [_tableview reloadData];
    }];
}

//已近过期的红包
- (void)loadAbandonHongBaoData{
    MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];

    [self.httpUtil requestDic4MethodName:@"bouns/mybouns" parameters:@{@"Page":@(_allBidPage),@"StatusId":@(2)} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            [hud hide:YES];
            self.hideNoNetWork = YES;
            if (_allBidPage == 1) {
                _hongBaoArr = [NSMutableArray array];
            }
            [_tableview.mj_footer resetNoMoreData];
            
            _hongBaoAllDic = dic;
            [_hongBaoArr addObjectsFromArray:[_hongBaoAllDic objectForKey:@"Data"]];
            _allBidCount = [[_hongBaoAllDic objectForKey:@"RecordCount"] integerValue];

            
            if (_hongBaoArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 53;
                self.noMsgView.height = SCREEN_HEIGHT - 53;
                self.noMsgView.width = SCREEN_WIDTH;
                
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 53;
            self.noNetWorkView.height = SCREEN_HEIGHT - 53;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        [_tableview reloadData];
    }];

}


- (void)headerRefreshloadData
{
    _allBidPage = 1;
    if (_hongbaoStateButton == _StateButtonsArray[2]) {
        
        self.hongbaoState = HongbaoStateCanUser;
        [self loadCanHongBaoData];
    }
    if (_hongbaoStateButton == _StateButtonsArray[1]) {
        
        self.hongbaoState = HongbaoStateUsed;
        [self loadUsedHongBaoData];
    }
    if (_hongbaoStateButton == _StateButtonsArray[0]) {
        
        self.hongbaoState = HongbaoStateAbandon;
        [self loadAbandonHongBaoData];
    }
    [_tableview.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    if (_allBidCount < 5) {
        [_tableview.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_tableview.mj_footer resetNoMoreData];
        _allBidPage ++;
        if (_hongbaoStateButton == _StateButtonsArray[2]) {
            
            self.hongbaoState = HongbaoStateCanUser;
            [self loadCanHongBaoData];
        }
        if (_hongbaoStateButton == _StateButtonsArray[1]) {
            
            self.hongbaoState = HongbaoStateUsed;
            [self loadUsedHongBaoData];
        }
        if (_hongbaoStateButton == _StateButtonsArray[0]) {
            
            self.hongbaoState = HongbaoStateAbandon;
            [self loadAbandonHongBaoData];
        }
        [_tableview.mj_footer endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
