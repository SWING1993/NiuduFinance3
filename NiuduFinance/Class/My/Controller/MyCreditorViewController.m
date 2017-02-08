//
//  MyCreditorViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/10.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyCreditorViewController.h"

#import "MyCreditorCell.h"
#import "MyCreditorActionViewController.h"
#import "MyCreditorActionViewControllerBackViewController.h"
#import "WebPageVC.h"
@interface MyCreditorViewController ()<UITableViewDelegate ,UITableViewDataSource,MyCreditorCellDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *CreditorStateButtons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *optionedStateButton;
@property (assign, nonatomic) CreditorState creditorState;

@property (nonatomic,strong)NSMutableArray *negotiableArr;
@property (nonatomic,assign)NSInteger negotiablePage;
@property (nonatomic,assign)NSInteger negotiableCount;

@property (nonatomic,strong)NSMutableArray *transferringArr;
@property (nonatomic,assign)NSInteger transferringPage;
@property (nonatomic,assign)NSInteger transferringCount;

@property (nonatomic,strong)NSMutableArray *buyRecordArr;
@property (nonatomic,assign)NSInteger buyRecordPage;
@property (nonatomic,assign)NSInteger buyRecordCount;

@end

static NSString * const cellIdentifier = @"MyCreditorCell";
@implementation MyCreditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"债权交易";
    [self backBarItem];
    //可转让
    _negotiableArr = [NSMutableArray array];
    _negotiablePage = 1;
    _negotiableCount = 0;
    //转让中
    _transferringArr = [NSMutableArray array];
    _transferringPage = 1;
    _transferringCount = 0;
    //买入债权
    _buyRecordArr = [NSMutableArray array];
    _buyRecordPage = 1;
    _buyRecordCount = 0;
    
    _creditorState = CreditorStateCanTransfer;
    _optionedStateButton = _CreditorStateButtons[0];
    [self setupTableView];

    
    [self getNegotiableData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_creditorState == CreditorStateCanTransfer) {
        [_negotiableArr removeAllObjects];
        [self getNegotiableData];
    }else if (_creditorState == CreditorStateRefunding){
        [_transferringArr removeAllObjects];
        [self getTransferringData];
    }
}




- (void)viewDidAppear:(BOOL)animated
{
    self.hideNaviBar = NO;
}
//  可转让
- (void)getNegotiableData
{
     MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestArr4MethodName:@"debtdeal/negotiable" parameters:@{@"Page":@(_negotiablePage)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_negotiablePage == 1) {
                [_negotiableArr removeAllObjects];
            }
            [hud hide:YES];
            _negotiableCount = arr.count;
            [_negotiableArr addObjectsFromArray:arr];
            
            if (_negotiableArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 68;
                self.noMsgView.height = SCREEN_HEIGHT - 38;
                self.noMsgView.width = SCREEN_WIDTH;
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 68;
            self.noNetWorkView.height = SCREEN_HEIGHT - 38;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        [self.tableView reloadData];
    } convertClassName:nil key:@"Data"];
}

//  转让中
- (void)getTransferringData
{
     MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestArr4MethodName:@"debtdeal/transferring" parameters:@{@"Page":@(_transferringPage)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_transferringPage == 1) {
                [_transferringArr removeAllObjects];
            }
            [hud hide:YES];
            _transferringCount = arr.count;
            [_transferringArr addObjectsFromArray:arr];
            
            if (_transferringArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 68;
                self.noMsgView.height = SCREEN_HEIGHT - 38;
                self.noMsgView.width = SCREEN_WIDTH;
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 68;
            self.noNetWorkView.height = SCREEN_HEIGHT - 38;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        [self.tableView reloadData];
    } convertClassName:nil key:@"Data"];
}

//  购买记录
- (void)getBuyRecordData
{
     MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestArr4MethodName:@"debtdeal/buyrecord" parameters:@{@"Page":@(_buyRecordPage),@"PageSize":@(10)} result:^(NSArray *arr, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_buyRecordPage == 1) {
                [_buyRecordArr removeAllObjects];
            }
            [hud hide:YES];
            _buyRecordCount = arr.count;
            [_buyRecordArr addObjectsFromArray:arr];
            
            if (_buyRecordArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 68;
                self.noMsgView.height = SCREEN_HEIGHT - 38;
                self.noMsgView.width = SCREEN_WIDTH;
            }else{
                
                self.hideNoMsg = YES;
                
            }
        }else{
            
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 68;
            self.noNetWorkView.height = SCREEN_HEIGHT - 38;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        
        [self.tableView reloadData];
    } convertClassName:nil key:@"Data"];
}

- (void)setupTableView
{
//    _tableView.contentInset = UIEdgeInsetsMake(9.0,0.0,0.0,0.0);
    _tableView.tableFooterView  = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self setupRefreshWithTableView:_tableView];
}

#pragma mark -  Action
- (IBAction)optionCreditorAction:(UIButton *)sender
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
    if (sender ==_CreditorStateButtons[0])
    {
        self.creditorState = CreditorStateCanTransfer;

        
        [self getNegotiableData];
    }
    else if (sender ==_CreditorStateButtons[1])
    {

        
        [self getTransferringData];
    }
    else if (sender ==_CreditorStateButtons[2])
    {
        
        self.creditorState = CreditorStateHistory;
        [self getBuyRecordData];
    }
}

- (void)gotoProtocol:(UITapGestureRecognizer *)gesture{
    
    
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *indexPatch = [self.tableView indexPathForRowAtPoint:point];
    
    WebPageVC *vc = [[WebPageVC alloc] init];
    vc.title = @"协议";
    vc.name = @"agreement/debtdeal";
    
    
    vc.dic = @{@"DebtDealId":[_buyRecordArr[indexPatch.row] objectForKey:@"DebtDealId"]};
    
    
//    vc.dic = @{@"ProjectId":};
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Setter
- (void)setCreditorState:(CreditorState)creditorState
{
    _creditorState = creditorState;
    [_tableView reloadData];
}

#pragma mark - MyCreditorCellDelegate
- (void)creditorInvestAction:(MyCreditorCell *)cell
{
   
    if (_creditorState == CreditorStateCanTransfer)
    {
        // 转让
        MyCreditorActionViewController *vc = [[MyCreditorActionViewController alloc] init];
        vc.transferInvest = YES;
        vc.projectId = [_negotiableArr[cell.creditorInvestButton.tag] objectForKey:@"ProjectId"];
//        vc.myCreditorDic = _negotiableArr[cell.creditorInvestButton.tag];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if (_creditorState == CreditorStateRefunding)
    {
        // 撤回
        MyCreditorActionViewControllerBackViewController *vc = [[MyCreditorActionViewControllerBackViewController alloc] init];
        vc.transferInvest = NO;
        vc.myCreditorDic = _transferringArr[cell.creditorInvestButton.tag];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_creditorState == CreditorStateCanTransfer) {
        return _negotiableArr.count;
    }else if (_creditorState == CreditorStateRefunding){
        return _transferringArr.count;
    }else if (_creditorState == CreditorStateHistory){
        return _buyRecordArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITapGestureRecognizer *bottomLabelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoProtocol:)];
    MyCreditorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (_creditorState == CreditorStateCanTransfer) {
        if (_negotiableArr.count > 0) {
            [cell creditorState:_creditorState model:_negotiableArr[indexPath.row]];
            cell.creditorInvestButton.tag = indexPath.row;
        }else{
            [cell creditorState:_creditorState model:nil];
        }
        
    }else if (_creditorState == CreditorStateRefunding){
        if (_transferringArr.count > 0) {
            [cell creditorState:_creditorState model:_transferringArr[indexPath.row]];
            cell.creditorInvestButton.tag = indexPath.row;
        }else{
            [cell creditorState:_creditorState model:nil];
        }
    }else if (_creditorState == CreditorStateHistory){
        if (_buyRecordArr.count > 0) {
            
            cell.bottomLeftLabel.userInteractionEnabled = YES;
            
            [cell.bottomLeftLabel addGestureRecognizer:bottomLabelGesture];
            [cell creditorState:_creditorState model:_buyRecordArr[indexPath.row]];
        }else{
            [cell creditorState:_creditorState model:nil];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
}

- (void)headerRefreshloadData
{
    if (_creditorState == CreditorStateCanTransfer) {
        _negotiablePage = 1;
        [self getNegotiableData];
    }else if (_creditorState == CreditorStateRefunding){
        _transferringPage = 1;
        [self getTransferringData];
    }else if (_creditorState == CreditorStateHistory){
        _buyRecordPage = 1;
        [self getBuyRecordData];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    if (_creditorState == CreditorStateCanTransfer) {
        if (_negotiableCount < 10) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _negotiablePage ++;
            [self getNegotiableData];
            [_tableView.mj_footer endRefreshing];
        }
    }else if (_creditorState == CreditorStateRefunding){
        if (_transferringCount < 10) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _transferringPage ++;
            [self getTransferringData];
            [_tableView.mj_footer endRefreshing];
        }
    }else if (_creditorState == CreditorStateHistory){
        if (_buyRecordCount < 10) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _buyRecordPage ++;
            [self getBuyRecordData];
            [_tableView.mj_footer endRefreshing];
        }
    }
}
@end
