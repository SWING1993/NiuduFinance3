//
//  ProjectViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/24.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectViewController.h"
#import "ZHBSlideBar.h"
#import "ZHBSlideItemView.h"
#import "UIView+ZHBFrame.h"
#import "iCarousel.h"
#import "ProjectNewTableViewCell.h"
#import "ProjectInvestTableViewCell.h"
#import "ProjectDetailsViewController.h"
#import "HomeTableViewCell.h"
#import "DebtTransferTableViewCell.h"
#import "FinanceDetailsViewController.h"
#import "DebtDetailsViewController.h"
#import "ProjectModel.h"
#import "DebtModel.h"
#import "AppDelegate.h"
#import "User.h"
#import "WebPageVC.h"

@interface ProjectViewController ()<UITableViewDataSource,UITableViewDelegate,iCarouselDelegate,iCarouselDataSource>

/*  通知列表 */
@property (nonatomic, weak) UITableView *projectTableView;
/*  内容view */
@property (nonatomic, weak) iCarousel *iCarouselView;
/*  分类滑动栏 */
//@property (nonatomic, weak) ZHBSlideBar *sliderBar;
/*  分类 */
@property (nonatomic, strong) NSArray *categories;

@property (strong, nonatomic) IBOutlet UIView *headerTableView;


@property (nonatomic,assign)int sort;
@property (nonatomic,assign)NSInteger isNew;

@property (nonatomic,assign)int isNewPageIndex;
@property (nonatomic,assign)NSInteger isNewPageSize;
@property (nonatomic,assign)NSInteger isNewCount;

@property (nonatomic,assign)int noNewPageIndex;
@property (nonatomic,assign)NSInteger noNewPageSize;
@property (nonatomic,assign)NSInteger noNewCount;

@property (nonatomic,assign)int debtPageIndex;
@property (nonatomic,assign)NSInteger debtCount;
@property (nonatomic,assign)NSInteger debtPageSize;


@property (nonatomic,strong)NSMutableArray *isNewMutableArr;
@property (nonatomic,strong)NSMutableArray *noNewMutableArr;
@property (nonatomic,strong)NSMutableArray *financialMutableArr;
@property (nonatomic,strong)NSMutableArray *debtMutableArr;

//h1
@property (weak, nonatomic) IBOutlet UILabel *huiFuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sureImage;

//h2

@end

@implementation ProjectViewController
{
    BOOL isNewOrOld;
    
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"投资";
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _categories = [[NSArray alloc]initWithObjects:@"新手专享",@"散标投资",@"债权转让",nil];
    
    UISegmentedControl * segmentedView =  [[UISegmentedControl alloc] initWithItems:_categories];
    //设置默认选择项索引
    segmentedView.selectedSegmentIndex = 0;
        [segmentedView addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [self.headerTableView addSubview:segmentedView];
    [self.iCarouselView scrollToItemAtIndex:self.categories.count animated:YES];

    [segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(33);
        make.top.mas_equalTo(19);
    }];
    [self.view addSubview:_headerTableView];
    [_headerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(0);
    }];
    
    
    [_headerTableView addSubview:_huiFuLabel];
    [_huiFuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(20);
        make.height.mas_equalTo(13);
//        make.bottom.equalTo(_headerTableView.mas_bottom).with.offset(6);
        make.top.equalTo(segmentedView.mas_bottom).with.offset(6);
    }];
    
    [_headerTableView addSubview:_sureImage];
    [_sureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_huiFuLabel.mas_left).with.offset(-17);
        make.centerY.mas_equalTo(_huiFuLabel);
    }];
    
    
    
    
    _isNew = 1;
    _sort = 0;
    _isNewPageIndex = 1;
    _isNewPageSize = 10;
    _isNewCount = 0;
    _noNewPageIndex = 1;
    _noNewPageSize = 10;
    _noNewCount = 0;
    _debtPageIndex = 1;
    _debtPageSize = 10;
    _debtCount = 0;
    
    _isNewMutableArr = [NSMutableArray array];
    _noNewMutableArr = [NSMutableArray array];
    _financialMutableArr = [NSMutableArray array];
    _debtMutableArr = [NSMutableArray array];
    //@"优选理财"
//    self.categories = @[@"新手专享",@"散标投资",@"债权转让"];
    
    
    [self setupView];
    [self getZhongJianData];
    [self getIsNewData];
    
   [self getDebtData];
    
    
//    //接受从首页发来的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotiFromMainPage:) name:@"mainPageToInvestPageNoti" object:nil];
    
}

- (void)segmentChange:(UISegmentedControl*)index
{
    switch (index.selectedSegmentIndex) {
        case 0:{
            [self.iCarouselView scrollToItemAtIndex:0 animated:YES];
            NSLog(@"新手专享");
        }
            break;
        case 1:{
            [self.iCarouselView scrollToItemAtIndex:1 animated:YES];
            NSLog(@"散标投资");
        }
            break;
        case 2:{
            [self.iCarouselView scrollToItemAtIndex:2 animated:YES];
            NSLog(@"债权转让");
            
        }
            break;
        default:
            break;
    }
    
    
}

- (void)getNotiFromMainPage:(NSNotification *)noti{
    
    NSString *index = [noti.userInfo objectForKey:@"index"];
    
    [self.iCarouselView scrollToItemAtIndex:index.integerValue animated:YES];

}

#pragma mark - Private Methods
- (void)setupView {

    [self.view addSubview:_headerTableView];
    
    iCarousel *contentView = [[iCarousel alloc] init];
    contentView.dataSource    = self;
    contentView.delegate      = self;
    contentView.scrollEnabled = NO;
    contentView.type          = iCarouselTypeLinear;
    contentView.pagingEnabled = YES;
    contentView.frame         = CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT  - 90);
    [self.view addSubview:contentView];
    self.iCarouselView = contentView;

}

#pragma mark iCarousel Delegate
- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index {
    return index >= 0 && index < self.categories.count;
}


- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel; {
    self.projectTableView = (UITableView *)carousel.currentItemView;
    self.projectTableView.backgroundColor = [UIColor colorWithHexString:@"#F0EFF5"];
    [_projectTableView reloadData];


}

#pragma mark iCarousel DataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    NSLog(@"%ld",self.categories.count);
    return self.categories.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.iCarouselView.bounds style:UITableViewStyleGrouped];
        tableView.delegate        = self;
        tableView.dataSource      = self;
        tableView.backgroundColor = [UIColor colorWithHexString:@"#F0EFF5"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setupRefreshWithTableView:tableView];
        
        [tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"ProjectNewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectNewTableViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"DebtTransferTableViewCell" bundle:nil] forCellReuseIdentifier:@"DebtTransferTableViewCell"];
        view = tableView;
    }
    return view;
}

#pragma mark UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (_iCarouselView.currentItemIndex == 0) {
        ProjectModel *model = _isNewMutableArr[indexPath.section];
        if (model.type == 1) {
            return 143;
        }
        
        return 134;
        
    }else if(_iCarouselView.currentItemIndex == 1){
        return 143;
    }

    else if(_iCarouselView.currentItemIndex == 2){
        return 110;
    }
    
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_iCarouselView.currentItemIndex == 0) {
        return _isNewMutableArr.count;
    }else if (_iCarouselView.currentItemIndex == 1){
        return _noNewMutableArr.count;
    }
    else if (_iCarouselView.currentItemIndex == 2){
        return _debtMutableArr.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
//切换数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_iCarouselView.currentItemIndex == 0) {

        isNewOrOld = NO;
        static NSString  *cellId = @"ProjectNewTableViewCell";
        ProjectNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell ==nil) {
            cell = [[ProjectNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewScrollPositionNone;
        [cell setNeedsDisplay];
        
        @try {
            cell.isNewProject = _isNewMutableArr[indexPath.section];
        } @catch (NSException *exception) {
            if (_isNewMutableArr.count-1 <= indexPath.section ) {
                NSLog(@"滑动太快啦吧");
            }
        } @finally {
            
        }
        
        [cell.projectDetailClick addTarget:self action:@selector(projectInvestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.projectDetailClick.tag = indexPath.section;
        return cell;
    }else if (_iCarouselView.currentItemIndex == 1){
        
        isNewOrOld = YES;
        
        static NSString  *cellId = @"ProjectNewTableViewCell";
        ProjectNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell ==nil) {
            cell = [[ProjectNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewScrollPositionNone;

        [cell setNeedsDisplay];
        
        
        @try {
            cell.noNewProject = _noNewMutableArr[indexPath.section];
        } @catch (NSException *exception) {
            if (_noNewMutableArr.count-1 <= indexPath.section ) {
                NSLog(@"滑动太快啦吧");
            }
        } @finally {
            
        }
        
        [cell.projectDetailClick addTarget:self action:@selector(projectInvestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.projectDetailClick.tag = indexPath.section;
        
        return cell;
    }

    else if (_iCarouselView.currentItemIndex == 2){
        static NSString  *cellId = @"DebtTransferTableViewCell";
        DebtTransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell ==nil) {
            
            cell = [[DebtTransferTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewScrollPositionNone;
        @try {
            cell.debtModel = _debtMutableArr[indexPath.section];
        } @catch (NSException *exception) {
            NSLog(@"滑动也太快了吧");
        } @finally {

        }
        
        [cell.debtStateBtn addTarget:self action:@selector(debtStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell setNeedsDisplay];
        cell.debtStateBtn.tag = indexPath.section;
        return cell;
    }
    return nil;
}




//散标详细跳转

- (void)projectInvestBtnClick:(UIButton *)btn{
    
    
    if (isNewOrOld) {
        ProjectDetailsViewController *projectDetailsVC = [ProjectDetailsViewController new];
        
        ProjectModel *project = _noNewMutableArr[btn.tag];
        projectDetailsVC.statueId = [NSString stringWithFormat:@"%d",project.statusId];
        projectDetailsVC.projectId = project.projectId;
        
        [self.navigationController pushViewController:projectDetailsVC animated:YES];
        
    }
    
    else {
        //新手散投详情跳转
        
        ProjectModel *project = _isNewMutableArr[btn.tag];
        ProjectDetailsViewController *projectDetailsVC = [ProjectDetailsViewController new];
        projectDetailsVC.statueId = [NSString stringWithFormat:@"%d",project.statusId];
        if (project.type == 1) {
            projectDetailsVC.projectId = project.projectId;
        }else if (project.type == 2){
            projectDetailsVC.productId = project.projectId;
            projectDetailsVC.type = @"理财";
        }
        projectDetailsVC.IsNewType = @"新手";
        [self.navigationController pushViewController:projectDetailsVC animated:YES];
    }
}


//优选理财跳转

- (void)goodProjectBtnClick:(UIButton *)btn{

    if ([AppDelegate checkLogin]) {
        
        if ([[User userFromFile].isOpenAccount integerValue] == 1) {
        
            if(isNewOrOld) {
                
                ProjectDetailsViewController *projectDetailsVC = [ProjectDetailsViewController new];
                ProjectModel *project = _financialMutableArr[btn.tag];
                projectDetailsVC.statueId = [NSString stringWithFormat:@"%d",project.statusId];
                projectDetailsVC.productId = project.productId;
                projectDetailsVC.type = @"理财";
                [self.navigationController pushViewController:projectDetailsVC animated:YES];
            }else
            {
                //新手优质详情跳转
                ProjectModel *project = _isNewMutableArr[btn.tag];
                ProjectDetailsViewController *projectDetailsVC = [ProjectDetailsViewController new];
                projectDetailsVC.statueId = [NSString stringWithFormat:@"%d",project.statusId];
                if (project.type == 1) {
                    projectDetailsVC.projectId = project.projectId;
                }else if (project.type == 2){
                    projectDetailsVC.productId = project.projectId;
                    projectDetailsVC.type = @"理财";
                }
                projectDetailsVC.IsNewType = @"新手";
                [self.navigationController pushViewController:projectDetailsVC animated:YES];
                
            }
            
        }
        }else{
        
            WebPageVC *vc = [[WebPageVC alloc] init];
            vc.title = @"开通汇付账户";
            vc.name = @"huifu/openaccount";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
}
//   债权跳转
- (void)debtStateBtnClick:(UIButton *)btn
{
    DebtModel *debtModel = _debtMutableArr[btn.tag];
    if (debtModel.sellerUserId == [User shareUser].userId) {
        [MBProgressHUD showMessag:@"不能购买自己发布借款的债权" toView:self.view];
        return;
    }
    
    DebtDetailsViewController *debtDetailsVC = [DebtDetailsViewController new];
    debtDetailsVC.debtID = debtModel.debtDealId;
    
    [self.navigationController pushViewController:debtDetailsVC animated:YES];
}

#pragma mark 新手表&散标data
- (void)getIsNewData
{
    int pageIndex;
    NSInteger pageSize;
    if (_isNew == 1) {
        pageIndex = _isNewPageIndex;
        pageSize = _isNewPageSize;
    }else if (_isNew == 0){
        pageIndex = _noNewPageIndex;
        pageSize = _noNewPageSize;
    }
    
    [self.httpUtil requestArr4MethodName:@"project/list" parameters:@{@"PageIndex":@(pageIndex),@"PageSize":@(pageSize),@"Sort":@(_sort),@"IsNew":@(_isNew)} result:^(NSArray *arr, int status, NSString *msg) {
        
        [self.noNetWorkView removeFromSuperview];
        if (status == 1 || status == 2) {
           
            //刷新
            [_projectTableView.mj_header endRefreshing];
            [_projectTableView.mj_footer endRefreshing];
            if (_isNew == 1) {
                if (_isNewPageIndex == 1) {
                    [_isNewMutableArr removeAllObjects];
                }
                
                _isNewCount = arr.count;
                [_isNewMutableArr addObjectsFromArray:arr];
                
                if(_isNewMutableArr.count == 0) {

                    self.noMsgView.width = SCREEN_WIDTH;
                    self.noMsgView.height = _iCarouselView.frame.size.height;
                    [_projectTableView addSubview:self.noMsgView];
                }else{
                    [self.noMsgView removeFromSuperview];
                }
            }
            else if (_isNew == 0){
                if (_noNewPageIndex == 1) {
                    [_noNewMutableArr removeAllObjects];
                }
                _noNewCount = arr.count;
                [_noNewMutableArr addObjectsFromArray:arr];
                
                if (_noNewMutableArr.count == 0) {

                    self.noMsgView.width = SCREEN_WIDTH;
                    self.noMsgView.height = _iCarouselView.frame.size.height;
                    [_projectTableView addSubview:self.noMsgView];
                }else{
                    [self.noMsgView removeFromSuperview];
                }
            }
        }else{
            if (![msg isEqual:@"尝试除以零。"]) {
                [MBProgressHUD showError:msg toView:self.view];
            }
            if (_isNew == 1){

                self.noNetWorkView.width = SCREEN_WIDTH;
                self.noNetWorkView.height = _iCarouselView.frame.size.height;
            }else{

                self.noNetWorkView.width = SCREEN_WIDTH;
                self.noNetWorkView.height = _iCarouselView.frame.size.height;
            }
            [_projectTableView addSubview:self.noNetWorkView];
            
        }
        [_projectTableView reloadData];
        _isNew = 0;
        _noNewPageIndex = 1;
        _noNewPageSize = 10;
        [self getZhongJianData];
    } convertClassName:@"ProjectModel" key:@"Data"];
}
-(void)getZhongJianData
{
    int pageIndex;
    NSInteger pageSize;
    if (_isNew == 1) {
        pageIndex = _isNewPageIndex;
        pageSize = _isNewPageSize;
    }else if (_isNew == 0){
        pageIndex = _noNewPageIndex;
        pageSize = _noNewPageSize;
    }
    
    [self.httpUtil requestArr4MethodName:@"project/list" parameters:@{@"PageIndex":@(pageIndex),@"PageSize":@(pageSize),@"Sort":@(_sort),@"IsNew":@(_isNew)} result:^(NSArray *arr, int status, NSString *msg) {
        
        [self.noNetWorkView removeFromSuperview];
        if (status == 1 || status == 2) {
            //刷新
            [_projectTableView.mj_header endRefreshing];
            [_projectTableView.mj_footer endRefreshing];
            if (_isNew == 1) {
                if (_isNewPageIndex == 1) {
                    [_isNewMutableArr removeAllObjects];
                }
                
                _isNewCount = arr.count;
                [_isNewMutableArr addObjectsFromArray:arr];
                
                if(_isNewMutableArr.count == 0) {
                    
                    self.noMsgView.width = SCREEN_WIDTH;
                    self.noMsgView.height = _iCarouselView.frame.size.height;
                    [_projectTableView addSubview:self.noMsgView];
                }else{
                    [self.noMsgView removeFromSuperview];
                }
            }
            else if (_isNew == 0){
                if (_noNewPageIndex == 1) {
                    [_noNewMutableArr removeAllObjects];
                }
                _noNewCount = arr.count;
                [_noNewMutableArr addObjectsFromArray:arr];
                
                if (_noNewMutableArr.count == 0) {
                    
                    self.noMsgView.width = SCREEN_WIDTH;
                    self.noMsgView.height = _iCarouselView.frame.size.height;
                    [_projectTableView addSubview:self.noMsgView];
                }else{
                    [self.noMsgView removeFromSuperview];
                }
            }
        }else{
            if (![msg isEqual:@"尝试除以零。"]) {
                [MBProgressHUD showError:msg toView:self.view];
            }
            if (_isNew == 1){
                
                self.noNetWorkView.width = SCREEN_WIDTH;
                self.noNetWorkView.height = _iCarouselView.frame.size.height;
            }else{
                
                self.noNetWorkView.width = SCREEN_WIDTH;
                self.noNetWorkView.height = _iCarouselView.frame.size.height;
            }
            [_projectTableView addSubview:self.noNetWorkView];
            
        }
        [_projectTableView reloadData];
    } convertClassName:@"ProjectModel" key:@"Data"];

}

#pragma mark 理财data
- (void)getFinancialProductData
{
    [self.httpUtil requestArr4MethodName:@"financialproduct/list" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        
        self.hideNoNetWork = YES;
        if (status == 1 || status == 2) {
            if (_financialMutableArr.count > 0) {
                [_financialMutableArr removeAllObjects];
            }
            [_projectTableView.mj_header endRefreshing];
            [_projectTableView.mj_footer endRefreshing];
            
            [_financialMutableArr addObjectsFromArray:arr];
            
            if (_financialMutableArr.count == 0) {
                self.hideNoMsg = NO;
                self.noMsgView.top = _iCarouselView.frame.origin.y;
                self.noMsgView.width = SCREEN_WIDTH;
                self.noMsgView.height = _iCarouselView.frame.size.height;
            }else{
                self.hideNoMsg = YES;
            }
            
        }else{
            if (![msg isEqual:@"尝试除以零。"]) {
                [MBProgressHUD showError:msg toView:self.view];
            }
            self.hideNoNetWork = NO;
            self.noNetWorkView.top = _iCarouselView.frame.origin.y;
            self.noNetWorkView.width = SCREEN_WIDTH;
            self.noNetWorkView.height = _iCarouselView.frame.size.height;
        }
        [_projectTableView reloadData];
    } convertClassName:@"ProjectModel" key:nil];
}
#pragma mark 债权data
- (void)getDebtData
{
    //
    [self.httpUtil requestArr4MethodName:@"debtdeal/list" parameters:@{@"Page":@(_debtPageIndex),@"PageSize":@(_debtPageSize),@"Sort":@(_sort)} result:^(NSArray *arr, int status, NSString *msg) {
        
        [self.noNetWorkView removeFromSuperview];
        if (status == 1 || status == 2) {
            if (_debtPageIndex == 1) {
                [_debtMutableArr removeAllObjects];
            }
            
            [_projectTableView.mj_header endRefreshing];
            [_projectTableView.mj_footer endRefreshing];
            
            _debtCount = arr.count;
            [_debtMutableArr addObjectsFromArray:arr];
            
            if (_debtMutableArr.count == 0) {

                self.noMsgView.width = SCREEN_WIDTH;
                self.noMsgView.height = _iCarouselView.frame.size.height;
                [_projectTableView addSubview:self.noMsgView];
            }else{
                [self.noMsgView removeFromSuperview];
            }
            
        }else{
            if (![msg isEqual:@"尝试除以零。"]) {
                [MBProgressHUD showError:msg toView:self.view];
            }

            self.noNetWorkView.width = SCREEN_WIDTH;
            self.noNetWorkView.height = _iCarouselView.frame.size.height;
            [_projectTableView addSubview:self.noNetWorkView];
        }
        [_projectTableView reloadData];
    } convertClassName:@"DebtModel" key:@"Data"];
}

- (void)headerRefreshloadData
{
    if (_iCarouselView.currentItemIndex == 0) {
        _isNew = 1;
        _isNewPageIndex = 1;
        _isNewPageSize = 10;
        [self getIsNewData];
    }else if (_iCarouselView.currentItemIndex == 1){
        _isNew = 0;
        _noNewPageIndex = 1;
        _noNewPageSize = 10;
        [self getIsNewData];
    }
    
    else if (_iCarouselView.currentItemIndex == 2){
        _debtPageIndex = 1;
        [self getDebtData];
    }
    [_projectTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    
    if (_iCarouselView.currentItemIndex == 0) {
        if (_isNewCount < 10) {
            [_projectTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            _isNewPageIndex ++;
            [self getIsNewData];
            [_projectTableView.mj_footer resetNoMoreData];
        }
    }else if (_iCarouselView.currentItemIndex == 1){
        if (_noNewCount < 10) {
            [_projectTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            _noNewPageIndex ++;
            [self getIsNewData];
            [_projectTableView.mj_footer resetNoMoreData];
        }
    }
    else if (_iCarouselView.currentItemIndex == 2){
        if (_debtCount < 10) {
            [_projectTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            _debtPageIndex ++;
            [self getDebtData];
            [_projectTableView.mj_footer resetNoMoreData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.hideNaviBar = YES;
    
    //改动过  这里是对债权数据的加载
    if (_iCarouselView.currentItemIndex == 2) {
        _debtPageIndex = 1;
        [self getDebtData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hideNaviBar = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
