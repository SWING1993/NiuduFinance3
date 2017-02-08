//
//  MyDisperseInvestViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/11.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyDisperseInvestViewController.h"
#import "MyDisperseInvestCell.h"
#import "MyDisperseInvestViewCell.h"
#import "ReturnDetailsViewController.h"
#import "WebPageVC.h"
@interface MyDisperseInvestViewController ()<UITableViewDelegate ,UITableViewDataSource,MyDisperseInvestViewCellDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *myDisperseInvestStateButtons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *optionedStateButton;
@property (weak, nonatomic) IBOutlet UIView *tableHeardView;

@property (assign, nonatomic) MyDisperseInvestStat disperseInvestStat;

@property (nonatomic,strong)NSMutableArray *inBidArr;
@property (nonatomic,assign)NSInteger inBidPage;
@property (nonatomic,assign)NSInteger inBidCount;

@property (nonatomic,strong)NSMutableArray *backLendArr;
@property (nonatomic,assign)NSInteger backLendPage;
@property (nonatomic,assign)NSInteger backLendCount;

@property (nonatomic,strong)NSMutableArray *allBidCountArr;
@property (nonatomic,assign)NSInteger allBidPage;
@property (nonatomic,assign)NSInteger allBidCount;
@end

//static NSString * const cellIdentifier = @"MyDisperseInvestCell";
static NSString * const cellIdentifier = @"MyDisperseInvestViewCell";
@implementation MyDisperseInvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的投资";
    [self backBarItem];
    _disperseInvestStat = MyDisperseInvestStatRufunding;
    _optionedStateButton = _myDisperseInvestStateButtons[0];
    [self setupTableView];
    
    _inBidArr = [NSMutableArray array];
    _inBidPage = 1;
    _inBidCount = 0;
    
    _backLendArr = [NSMutableArray array];
    _backLendPage = 1;
    _backLendCount = 0;
    
    _allBidCountArr = [NSMutableArray array];
    _allBidPage = 1;
    _allBidCount = 0;
    
//    _tableHeardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 68);
//    [_tableView addSubview:_tableHeardView];
    [self getInBidData];
}



- (void)viewDidAppear:(BOOL)animated
{
    self.hideNaviBar = NO;
    //未结算
    
}
//  投标中 == 未结算
- (void)getInBidData
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestArr4MethodName:@"project/inbids" parameters:@{@"Page":@(_inBidPage)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_inBidPage == 1) {
                [_inBidArr removeAllObjects];
            }
            [hud hide:YES];
            [_tableView.mj_footer resetNoMoreData];
            _inBidCount = arr.count;
            [_inBidArr addObjectsFromArray:arr];
            
            if (_inBidArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 68;
                self.noMsgView.height = SCREEN_HEIGHT - 68;
                self.noMsgView.width = SCREEN_WIDTH;

            }else{
                
                self.hideNoMsg = YES;
            }
            
             [_tableView reloadData];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 68;
            self.noNetWorkView.height = SCREEN_HEIGHT - 68;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
       
        
    } convertClassName:nil key:@"Results"];
}

// 回款中  == 已结算
- (void)getBackLendData
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestArr4MethodName:@"project/backlend" parameters:@{@"Page":@(_backLendPage),@"PageSize":@(5)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_backLendPage == 1) {
                [_backLendArr removeAllObjects];
            }
            [hud hide:YES];
            [_tableView.mj_footer resetNoMoreData];
            _backLendCount = arr.count;
            [_backLendArr addObjectsFromArray:arr];
            
            if (_backLendArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 68;
                self.noMsgView.height = SCREEN_HEIGHT - 68;
                self.noMsgView.width = SCREEN_WIDTH;
                
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 68;
            self.noNetWorkView.height = SCREEN_HEIGHT - 68;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        [_tableView reloadData];
    } convertClassName:nil key:@"Results"];
}

// 投资记录  == 全部
- (void)getAllBidData
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestArr4MethodName:@"project/allbid" parameters:@{@"PageIndex":@(_allBidPage),@"PageSize":@(5)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_allBidPage == 1) {
                [_allBidCountArr removeAllObjects];
            }
            [hud hide:YES];
            [_tableView.mj_footer resetNoMoreData];
            
            _allBidCount = arr.count;
            [_allBidCountArr addObjectsFromArray:arr];
            
            if (_allBidCountArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 68;
                self.noMsgView.height = SCREEN_HEIGHT - 68;
                self.noMsgView.width = SCREEN_WIDTH;
                
            }else{
                
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 68;
            self.noNetWorkView.height = SCREEN_HEIGHT - 68;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        [_tableView reloadData];
    } convertClassName:nil key:@"Data"];
}

- (void)setupTableView
{
    _tableView.contentInset = UIEdgeInsetsMake(9.0,0.0,0.0,0.0);
    _tableView.tableFooterView  = [UIView new];
    [self setupRefreshWithTableView:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark -  Action
- (IBAction)optionStateAction:(UIButton *)sender
{
    if (sender == _optionedStateButton)
    {
        return;
    }
    else
    {
        _optionedStateButton.selected = NO;
        sender.selected = YES;
    }
    _optionedStateButton = sender;
    if (sender ==_myDisperseInvestStateButtons[0])
    {
        self.disperseInvestState = MyDisperseInvestStateRufunding;
       
        [self getInBidData];
       
    }
    else if (sender ==_myDisperseInvestStateButtons[1])
    {
        self.disperseInvestState = MyDisperseInvestStateBidding;
         [self getBackLendData];
    }
    else if (sender ==_myDisperseInvestStateButtons[2])
    {
        self.disperseInvestState = MyDisperseInvestStateHistory;
        [self getAllBidData];
    }
}

#pragma mark - Setter
- (void)setDisperseInvestState:(MyDisperseInvestStat)disperseInvestStat
{
    _disperseInvestStat = disperseInvestStat;
//    [_tableView reloadData];
}

#pragma mark - MyDispreseInvestCellDelegate

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_disperseInvestStat == MyDisperseInvestStateRufunding) {
        
        return _inBidArr.count;
    }else if (_disperseInvestStat == MyDisperseInvestStateBidding){
        return _backLendArr.count;
    }else if (_disperseInvestStat == MyDisperseInvestStateHistory){
        return _allBidCountArr.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITapGestureRecognizer *bottomLabelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoProtocol:)];
    MyDisperseInvestViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    //已结算


    if (_disperseInvestStat == MyDisperseInvestStateBidding) {
        if (_backLendArr.count > 0) {
            [cell.xieYiBtn addGestureRecognizer:bottomLabelGesture];
            [cell creditorState:_disperseInvestStat model:_backLendArr[indexPath.row]];
        }else{
            [cell creditorState:_disperseInvestStat model:nil];
        }
    }else if (_disperseInvestStat == MyDisperseInvestStateRufunding){
        if (_inBidArr.count > 0) {
            [cell.xieYiBtn addGestureRecognizer:bottomLabelGesture];
            [cell creditorState:_disperseInvestStat model:_inBidArr[indexPath.row]];
        }else{
            [cell creditorState:_disperseInvestStat model:nil];
        }
    }else if (_disperseInvestStat == MyDisperseInvestStateHistory){
        if (_allBidCountArr.count > 0) {
            [cell.xieYiBtn addGestureRecognizer:bottomLabelGesture];
            [cell creditorState:_disperseInvestStat model:_allBidCountArr[indexPath.row]];
        }else{
            [cell creditorState:_disperseInvestStat model:nil];
        }
    }
    return cell;
}

//查看协议

- (void)gotoProtocol:(UITapGestureRecognizer *)gesture{
    
    
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *indexPatch = [self.tableView indexPathForRowAtPoint:point];
    
    WebPageVC *vc = [[WebPageVC alloc] init];
    vc.title = @"协议";
    vc.name = @"agreement/bidproject";
    
    if (_disperseInvestStat == MyDisperseInvestStateBidding) {
        vc.dic = @{@"ProjectId":[_backLendArr[indexPatch.row] objectForKey:@"ProjectId"]};
    }
    
    if (_disperseInvestStat == MyDisperseInvestStateRufunding) {
        vc.dic = @{@"ProjectId":[_inBidArr[indexPatch.row] objectForKey:@"ProjectId"]};
    }
    if (_disperseInvestStat == MyDisperseInvestStateHistory) {
        NSLog(@"%@",_allBidCountArr[indexPatch.row]);
        NSString *str = [_allBidCountArr[indexPatch.row] objectForKey:@"ProjectId"];
        if (str == nil || str.length == 0 || [str isEqualToString:@""] || [str isEqualToString:@"(null)"])
        {
            
        }
        else
        {
            vc.dic = @{@"ProjectId":[_allBidCountArr[indexPatch.row] objectForKey:@"ProjectId"]};

        }
       
    }
    
    //    vc.dic = @{@"ProjectId":};
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_disperseInvestStat == MyDisperseInvestStateHistory) {
//        return 128;
//    }
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_disperseInvestStat == MyDisperseInvestStateRufunding) {
        ReturnDetailsViewController *returnDetailsVC = [ReturnDetailsViewController new];
        returnDetailsVC.projectId = [[_inBidArr[indexPath.row] objectForKey:@"ProjectId"] intValue];
        [self.navigationController pushViewController:returnDetailsVC animated:YES];
    }
    if (_disperseInvestStat == MyDisperseInvestStateBidding) {
        ReturnDetailsViewController *returnDetailsVC = [ReturnDetailsViewController new];
        returnDetailsVC.projectId = [[_backLendArr[indexPath.row] objectForKey:@"ProjectId"] intValue];
        [self.navigationController pushViewController:returnDetailsVC animated:YES];
    }
    if (_disperseInvestStat == MyDisperseInvestStateHistory) {
        ReturnDetailsViewController *returnDetailsVC = [ReturnDetailsViewController new];
        returnDetailsVC.projectId = [[_allBidCountArr[indexPath.row] objectForKey:@"ProjectId"] intValue];
        [self.navigationController pushViewController:returnDetailsVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)headerRefreshloadData
{
    if (_disperseInvestStat == MyDisperseInvestStateBidding) {
        _inBidPage = 1;
       
        [self getBackLendData];
    }else if (_disperseInvestStat == MyDisperseInvestStateRufunding){
        _backLendPage = 1;
         [self getInBidData];
    }else if (_disperseInvestStat == MyDisperseInvestStateHistory){
        _allBidPage = 1;
        [self getAllBidData];
    }
    
    [_tableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    if (_disperseInvestStat == MyDisperseInvestStateBidding) {
        if (_inBidCount < 10) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _inBidPage ++;
            [self getInBidData];
            [_tableView.mj_footer endRefreshing];
        }
    }else if (_disperseInvestStat== MyDisperseInvestStateRufunding){
        if (_backLendCount < 5) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _backLendPage ++;
            [self getBackLendData];
            [_tableView.mj_footer endRefreshing];
        }
    }else if (_disperseInvestStat== MyDisperseInvestStateHistory){
        if (_allBidCount < 5) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _allBidPage ++;
            [self getAllBidData];
            [_tableView.mj_footer endRefreshing];
        }
    }
}


@end
