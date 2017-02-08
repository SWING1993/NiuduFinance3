//
//  InvestRecodeViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "InvestRecodeViewController.h"
#import "InvestRecodeTableViewCell.h"
#import "InvestRecode.h"

@interface InvestRecodeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *investRecodeTableView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong)NSMutableArray *investRecodeArr;
@property (nonatomic,assign)int investPageIndex;
@property (nonatomic,assign)NSInteger investCount;
@end

@implementation InvestRecodeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"投资记录";
    }
    return self;
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
- (void)setProjectId:(int)projectId
{
    _projectId = projectId;
    
    [self getInvestRecodeData];
}

- (void)setProductId:(int)productId
{
    _productId = productId;
    
    [self getFinanceInvestRecodeData];
}

- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
}

- (void)setIsTransfer:(BOOL)isTransfer
{
    _isTransfer = isTransfer;
    
    if (_isTransfer) {
        _dateLabel.text = @"用户名/投资时间";
        _moneyLabel.text = @"投资金额";
    }
}

- (void)setDebtArr:(NSArray *)debtArr
{
    _debtArr = debtArr;
    
    _investRecodeArr = [NSMutableArray arrayWithArray:debtArr];
    
    if (_investRecodeArr.count == 0) {
        self.hideNoMsg = NO;
        self.noMsgView.top = 34;
        self.noMsgView.height = self.view.size.height - 34;
        self.noMsgView.width = self.view.size.width;
        self.noMsgView.mj_x = 0;
        self.noMsgView.mj_y = 34;
    }else{
        self.hideNoMsg = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _investPageIndex = 1;
    _investRecodeArr = [NSMutableArray array];
    _investRecodeTableView.tableFooterView = [UIView new];
    [self setupRefreshWithTableView:_investRecodeTableView];
    [_investRecodeTableView registerNib:[UINib nibWithNibName:@"InvestRecodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"InvestRecodeTableViewCell"];
}

- (void)getInvestRecodeData
{
    [self.httpUtil requestArr4MethodName:_urlStr parameters:@{@"ProjectId":@(_projectId),@"PageIndex":@(_investPageIndex),@"PageSize":@(10)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            if (_investPageIndex == 1) {
                [_investRecodeArr removeAllObjects];
            }
            
            [_investRecodeTableView.mj_footer resetNoMoreData];
            _investCount = arr.count;
            [_investRecodeArr addObjectsFromArray:arr];
            
            if (_investRecodeArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 34;
                self.noMsgView.height = SCREEN_HEIGHT - 34;
                self.noMsgView.width = SCREEN_WIDTH;
            }else{
                self.hideNoMsg = YES;
            }
            
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_investRecodeTableView reloadData];
    } convertClassName:@"InvestRecode" key:@"Data"];
}

- (void)getFinanceInvestRecodeData
{
    [self.httpUtil requestArr4MethodName:_urlStr parameters:@{@"ProductId":@(_productId),@"PageIndex":@(_investPageIndex),@"PageSize":@(10)} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            if (_investPageIndex == 1) {
                [_investRecodeArr removeAllObjects];
            }
            [_investRecodeTableView.mj_footer resetNoMoreData];
            _investCount = arr.count;
            [_investRecodeArr addObjectsFromArray:arr];
            
            if (_investRecodeArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = 34;
                self.noMsgView.height = SCREEN_HEIGHT - 34;
                self.noMsgView.width = SCREEN_WIDTH;
            }else{
                self.hideNoMsg = YES;
            }
            
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_investRecodeTableView reloadData];
    } convertClassName:@"InvestRecode" key:@"Data"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _investRecodeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *cellId = @"InvestRecodeTableViewCell";
    InvestRecodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[InvestRecodeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewScrollPositionNone;
    if (_isTransfer) {
        cell.debtDic = _investRecodeArr[indexPath.row];
    }else{
        cell.investRecode = _investRecodeArr[indexPath.row];
    }
    return cell;
}

- (void)headerRefreshloadData
{
    if (_isTransfer) {
        [_investRecodeTableView.mj_header endRefreshing];
        return;
    }
    _investPageIndex = 1;
    if ([_urlStr isEqual:@"financialproduct/bidinfo"]) {
        [self getFinanceInvestRecodeData];
    }else{
        if (_isTransfer) {
            [_investRecodeTableView.mj_header endRefreshing];
            return;
        }
        [self getInvestRecodeData];
    }
    [_investRecodeTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    if (_isTransfer) {
        [_investRecodeTableView.mj_footer endRefreshing];
        return;
    }
    if (_investCount < 10) {
        [_investRecodeTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_investRecodeTableView.mj_footer resetNoMoreData];
        _investPageIndex ++;
        if ([_urlStr isEqual:@"financialproduct/bidinfo"]) {
            [self getFinanceInvestRecodeData];
        }else{
            [self getInvestRecodeData];
        }
        
        [_investRecodeTableView.mj_footer endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
