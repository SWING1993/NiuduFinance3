//
//  MyIoanViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyIoanViewController.h"
#import "MyIoanCell.h"
#import "RefundDetailViewController.h"
@interface MyIoanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ioanStateButtons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) OptionMyIoanState ioanState;

@property (nonatomic,strong)NSMutableArray *myLoanArr;
@property (nonatomic,assign)NSInteger myLoanPage;
@property (nonatomic,assign)NSInteger myLoanCount;

@property (nonatomic,strong)NSMutableArray *loanRecodeArr;
@property (nonatomic,assign)NSInteger loanRecodePage;
@property (nonatomic,assign)NSInteger loanRecodeCount;

@property (strong, nonatomic) UIButton *currentClikeStateButton;
@end

static NSString * const cellIdentifier = @"MyIoanCell";
@implementation MyIoanViewController


- (void)viewDidAppear:(BOOL)animated
{
    self.hideNaviBar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的借款";
    [self backBarItem];
    
    _myLoanArr = [NSMutableArray array];
    _myLoanPage = 1;
    _myLoanCount = 0;
    
    _loanRecodeArr = [NSMutableArray array];
    _loanRecodePage = 1;
    _loanRecodeCount = 0;
    
    _ioanState = OptionMyIoanStateRefunding;
    _currentClikeStateButton = _ioanStateButtons[0];
    [self setupTableView];
    
    [self getMyLoanData];
    
}
//  还款中
- (void)getMyLoanData
{
    [self.httpUtil requestDic4MethodName:@"account/myloan" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if ([dic isKindOfClass:[NSString class]]) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 38;
                self.noMsgView.height = SCREEN_HEIGHT - 38;
                self.noMsgView.width = SCREEN_WIDTH;
                [MBProgressHUD showError:msg toView:self.view];
            }else{
                if (_myLoanPage == 1) {
                    [_myLoanArr removeAllObjects];
                }
                [_tableView.mj_footer resetNoMoreData];
                NSArray *arr = [dic objectForKey:@"Data"];
                _myLoanCount = arr.count;
                [_myLoanArr addObjectsFromArray:arr];
                
                if (_myLoanArr.count == 0) {
                    self.hideNoMsg = NO;
                    self.noMsgView.top = 38;
                    self.noMsgView.height = SCREEN_HEIGHT - 38;
                    self.noMsgView.width = SCREEN_WIDTH;
                    
                }else{
                    self.hideNoMsg = YES;
                }
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

//  还款记录
- (void)getLoanRecodeData
{
   
    [self.httpUtil requestArr4MethodName:@"project/published" parameters:@{@"Page":@(_loanRecodePage),@"PageSize":@(5)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_loanRecodePage == 1) {
                [_loanRecodeArr removeAllObjects];
            }
            [_tableView.mj_footer resetNoMoreData];
            _loanRecodeCount = arr.count;
            [_loanRecodeArr addObjectsFromArray:arr];
            
            if (_loanRecodeArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 38;
                self.noMsgView.height = SCREEN_HEIGHT - 38;
                self.noMsgView.width = SCREEN_WIDTH;
                
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = 38;
            self.noNetWorkView.height = SCREEN_HEIGHT - 38;
            self.noNetWorkView.width = SCREEN_WIDTH;
        }
        [_tableView reloadData];
    } convertClassName:nil key:@"PublishedPage"];
}

#pragma mark - Set Up UI
- (void)setupTableView{
    
    _tableView.tableFooterView = [UIView new];
    [self setupRefreshWithTableView:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
//    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
}

#pragma mark -  Action
- (IBAction)optionIoanStateAction:(UIButton *)sender {
   
    if (sender == _currentClikeStateButton) {
        return;
    }
    _currentClikeStateButton.selected = NO;
    sender.selected = YES;
    _currentClikeStateButton = sender;
    
    if (sender == _ioanStateButtons[0])
    {
        _ioanState = OptionMyIoanStateRefunding;
        [self getMyLoanData];
    }
    else if(sender == _ioanStateButtons[1])
    {
        _ioanState = OptionMyIoanStateHistory;
        [self getLoanRecodeData];
    }

}

#pragma mark - Setter
- (void)setIoanState:(OptionMyIoanState)ioanState
{
    _ioanState = ioanState;
    // 判断 数据  刷新table view
}

#pragma mark - UITableViewDelegate & UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_ioanState == OptionMyIoanStateRefunding) {
        return _myLoanArr.count;
    }else if (_ioanState == OptionMyIoanStateHistory){
        return _loanRecodeArr.count;
        
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
    MyIoanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (_ioanState == OptionMyIoanStateRefunding) {
        if (_myLoanArr.count > 0) {
            cell.state = @"还款中";
            cell.myIoanDic = _myLoanArr[indexPath.row];
            
        }
    }else if (_ioanState == OptionMyIoanStateHistory){
        if (_loanRecodeArr.count > 0) {
          
            cell.state = @"借款记录";
            cell.myIoanDic = _loanRecodeArr[indexPath.row];
            
        }
    }
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ioanState == OptionMyIoanStateRefunding) {
        RefundDetailViewController *vc = [[RefundDetailViewController alloc] init];
        vc.projectId = [[_myLoanArr[indexPath.row] objectForKey:@"ProjectId"] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)headerRefreshloadData
{
    if (_ioanState == OptionMyIoanStateRefunding) {
        _myLoanPage = 1;
        [self getMyLoanData];
    }else if (_ioanState == OptionMyIoanStateHistory){
        _loanRecodePage = 1;
        [self getLoanRecodeData];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    if (_ioanState == OptionMyIoanStateRefunding) {
        if (_myLoanCount < 5) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _myLoanPage ++;
            [self getMyLoanData];
            [_tableView.mj_footer endRefreshing];
        }
    }else if (_ioanState == OptionMyIoanStateHistory){
        if (_loanRecodeCount < 5) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _loanRecodePage ++;
            [self getLoanRecodeData];
            [_tableView.mj_footer endRefreshing];
        }
    }
}

@end
