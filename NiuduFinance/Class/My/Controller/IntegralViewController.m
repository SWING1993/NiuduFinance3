//
//  IntegralViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralHeaderView.h"
#import "ExchangeHBTableViewCell.h"
#import "IntegralLogTableViewCell.h"

#define ExchageShopCellID @"ExchangeHBTableViewCell"
#define IntegralCellID @"IntegralLogTableViewCell"


@interface IntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectButtonArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IntegralHeaderView *headerView;
@property (nonatomic,strong) UIButton *currentButton;

@property (nonatomic,strong) NSDictionary *saveIntegralDic;
@property (nonatomic,strong) NSDictionary *integralDic;
//积分可换购的产品
@property (nonatomic,strong) NSMutableArray *integralProjectArr;
//积分记录
@property (nonatomic,strong) NSMutableArray *logIntegralArr;

@end

@implementation IntegralViewController
{
    int page;
    NSInteger projectNum;
    int itemCounts;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backBarItem];
    self.title = @"我的积分";
    page = 1;
    projectNum = -1;
    [self loadTableView];
    _currentButton = _selectButtonArr[0];
    _integralDic = [NSMutableDictionary dictionary];
    _saveIntegralDic = [NSMutableDictionary dictionary];
    _integralProjectArr = [NSMutableArray array];
    _logIntegralArr = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlert) name:@"getIntegralNoti" object:nil];
    
    
    
}
- (void)showAlert{
    //将获得的积分添加到后台
    [self loadTodaySign];
    
    //刷新页面
    
    
    
}

- (void)loadTableView{
    
    [self setupRefreshWithTableView:_tableView];
//    _tableView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0);
    _tableView.backgroundColor = BlackCCCCCC;
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    
//    [self loadHeaderView];
    
    [self.tableView registerNib:[UINib nibWithNibName:ExchageShopCellID bundle:nil] forCellReuseIdentifier:ExchageShopCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:IntegralCellID bundle:nil] forCellReuseIdentifier:IntegralCellID];
    
   
    [self loadIntegralData];
}

- (void)loadHeaderView{

    IntegralHeaderView *headerView = [[IntegralHeaderView alloc] init];
    [_tableView addSubview:headerView];
    _tableView.tableHeaderView = headerView;
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.top.equalTo(self.tableView).offset(-120);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(120);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectAction:(id)sender {
    
    if (_currentButton == sender) {
        return;
    }else{
        
        [_currentButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    }
    
    _currentButton = sender;
    [_currentButton setTitleColor:NaviColor forState:UIControlStateNormal];
    if (_currentButton == _selectButtonArr[0]) {
        NSLog(@"积分换购");
        
        //加载积分换购数据
        
        [self loadIntegralData];
        
        
    }else if (_currentButton == _selectButtonArr[1]){
        NSLog(@"积分记录");
        
        [self loadIntergralLog];
    }
}

#pragma mark -- 积分记录

- (void)loadIntergralLog{
    self.hideNoMsg = YES;
    _tableView.separatorStyle = YES;
    MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestDic4MethodName:@"integral/log" parameters:@{@"PageIndex":@(page),@"PageSize":@(10)} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            [hud hide:YES];
            self.hideNoNetWork = YES;
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
            
            if (page == 1) {
                [_logIntegralArr  removeAllObjects];
            }
           
           [_logIntegralArr addObjectsFromArray: [dic objectForKey:@"Data"]];
            itemCounts = [[dic objectForKey:@"RecordCount"] intValue];
            if (_integralProjectArr.count == 0) {
                
                self.hideNoNetWork = NO;
                self.noNetWorkView.top = 38;
                self.noNetWorkView.height = SCREEN_HEIGHT - 38;
                self.noNetWorkView.width = SCREEN_WIDTH;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 38;
            self.noNetWorkView.height = SCREEN_HEIGHT - 38;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        
        
        [_tableView reloadData];
        
    }];
    
}

#pragma mark -- 签到

- (void)loadTodaySign{

    [self.httpUtil requestDic4MethodName:@"integral/todaysign" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
       
        if (status == 1 || status == 2) {
             [MBProgressHUD show:@"签到成功" andShowLabel:msg icon:@"successPage"  view:self.view];
            
            
            [self headerRefreshloadData];
           
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 38;
            self.noNetWorkView.height = SCREEN_HEIGHT - 38;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
         [self.tableView reloadData];
        
    }];
}

#pragma mark -- 加载我的积分
- (void)loadIntegralData{
    

    _tableView.separatorStyle = YES;
    MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestDic4MethodName:@"integral/myintegral" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [hud hide:YES];
            self.hideNoNetWork = YES;
            [_tableView.mj_footer resetNoMoreData];

            _saveIntegralDic = dic;
            
            _integralProjectArr = [dic objectForKey:@"IntegralProducts"];
            
            if (_integralProjectArr.count == 0) {
                
                self.hideNoNetWork = NO;
                self.noNetWorkView.top = 120;
                self.noNetWorkView.height = SCREEN_HEIGHT - 120;
                self.noNetWorkView.width = SCREEN_WIDTH;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 38;
            self.noNetWorkView.height = SCREEN_HEIGHT - 38;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        
        
        [_tableView reloadData];
        
    }];
    
}

#pragma mark -- 换购提交
- (void)loadExchangeShopData{
    
    [self.httpUtil requestDic4MethodName:@"integral/integralbuy" parameters:@{@"ProductId":[_integralProjectArr[projectNum] objectForKey:@"ProductId"] } result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            
            self.hideNoNetWork = YES;
            [_tableView.mj_footer resetNoMoreData];
            
            [MBProgressHUD showMessag:@"兑换成功" toView:self.view];
            [self headerRefreshloadData];
            
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
        }
        
        
        [_tableView reloadData];
        
    }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (_currentButton == _selectButtonArr[0]) {
        return 120;
    }
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentButton == _selectButtonArr[0]) {
        return _integralProjectArr.count;
    }else{
        return _logIntegralArr.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_currentButton == _selectButtonArr[0]) {
         static NSString *headerId = @"headerViewID";
        _headerView = (IntegralHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
        if (_headerView == nil) {
            _headerView = [[IntegralHeaderView alloc] init];
        }
        
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
        _headerView.dic = _saveIntegralDic;
       
        return _headerView;
    }else{
        return nil;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentButton == _selectButtonArr[0]) {
        return 100;
    }
    
    return 75;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentButton == _selectButtonArr[0]) {
        
        ExchangeHBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExchageShopCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hongbaoDic = _integralProjectArr[indexPath.row];
        cell.exchangeBtn.tag = indexPath.row;
        [cell.exchangeBtn addTarget:self action:@selector(commitExchange:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (_currentButton == _selectButtonArr[1]) {
        
        IntegralLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IntegralCellID];
        cell.dic = _logIntegralArr[indexPath.row];
        return cell;
    }
    
    return nil;
}

#pragma mark --  积分兑换券
- (void)commitExchange:(UIButton *)btn{
    
    
    
    
    projectNum = btn.tag;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否兑换" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loadExchangeShopData];
    }
}

- (void)headerRefreshloadData
{
    page = 1;
    if (_currentButton == _selectButtonArr[0]) {
        
        [self loadIntegralData];
    }
    if (_currentButton == _selectButtonArr[1]) {
        
        
        [self loadIntergralLog];
    }
    
    [_tableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    if (itemCounts < 5) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_tableView.mj_footer resetNoMoreData];
        page ++;
        if (_currentButton == _selectButtonArr[0]) {
            
            [self loadIntegralData];
        }
        if (_currentButton == _selectButtonArr[1]) {
            
            
            [self loadIntergralLog];
        }

        [_tableView.mj_footer endRefreshing];
    }
}
@end
