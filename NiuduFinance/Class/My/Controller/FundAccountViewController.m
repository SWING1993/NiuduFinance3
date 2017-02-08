//
//  FundAccountViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/14.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FundAccountViewController.h"
#import "FundAccountTableViewCell.h"

@interface FundAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *fundAccountTableView;

@property (nonatomic,strong)NSMutableArray *fundAccountArr;

@property (nonatomic,assign)NSInteger pageIndex;

@property (nonatomic,assign)NSInteger fundCount;
@end

@implementation FundAccountViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"资金记录";
        //显示底部tabBar
        self.hideBottomBar = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _pageIndex = 1;
    _fundCount = 0;
    _fundAccountArr = [NSMutableArray array];
    
    [self setTableViewInfo];
    
    [self getFundAccountData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)getFundAccountData
{
    [self.httpUtil requestArr4MethodName:@"account/activity" parameters:@{@"PageIndex":@(_pageIndex),@"PageSize":@(10)} result:^(NSArray *arr, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_pageIndex == 1) {
                [_fundAccountArr removeAllObjects];
            }
            [_fundAccountTableView.mj_footer resetNoMoreData];
            _fundCount = arr.count;
            [_fundAccountArr addObjectsFromArray: arr];
            
            if (_fundAccountArr.count == 0) {
                self.hideNoMsg = NO;
            }else{
                self.hideNoMsg = YES;
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
        }
        [_fundAccountTableView reloadData];
    } convertClassName:nil key:@"Rows"];
}

- (void)setTableViewInfo
{
    //底部刷新
    _fundAccountTableView.tableFooterView = [UIView new];
    [self setupRefreshWithTableView:_fundAccountTableView];
    [_fundAccountTableView registerNib:[UINib nibWithNibName:@"FundAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"FundAccountTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fundAccountArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FundAccountTableViewCell";
    FundAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[FundAccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fundAccountDic = _fundAccountArr[indexPath.row];
    return cell;
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getFundAccountData];
    [_fundAccountTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    if (_fundCount < 10) {
        [_fundAccountTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_fundAccountTableView.mj_footer resetNoMoreData];
        _pageIndex ++;
        [self getFundAccountData];
        [_fundAccountTableView.mj_footer endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
