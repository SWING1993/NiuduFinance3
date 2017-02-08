//
//  MyViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/24.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyViewController.h"
#import "MyHeaderView.h"
#import "UIView+Extension.h"
#import "UIImage-Extensions.h"
//#import "MyContentCell.h"
//#import "MySectionHeaderCell.h"
#import "FundManagerController.h"
#import "AccountSafeController.h"
#import "MoreViewController.h"
#import "MyBankCardViewController.h"
#import "MyIoanViewController.h"
#import "FinancialProductViewController.h"
#import "MyCreditorViewController.h"
#import "MyDisperseInvestViewController.h"
#import "RefundPlanViewController.h"
#import "FundAccountViewController.h"
#import "NetWorkingUtil.h"
#import "NSString+Adding.h"
#import "HongBaoViewController.h"
#import "InvitationFriendsVC.h"
#import "IntegralViewController.h"
#import "MyViewTableViewCell.h"
#import "BaseViewController.h"
#import "User.h"
#import "WebPageVC.h"
//H1
#import "MyTailView.h"
#import "MyWeiBuView.h"
#import "MyTailViewCollectionViewCell.h"
#import "MoreWebViewController.h"
//H2
#import <JavaScriptCore/JavaScriptCore.h>
#define kMyHeaderViewHeight 267
#define kMyTailViewHeight 34
#define kMyWeiBuViewHeight 294

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isOpen;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *custemNavi;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) MyHeaderView *tableHeaderView;

//H1
@property (weak, nonatomic) MyTailView *tableTailView;
@property (weak, nonatomic) MyWeiBuView *tableWeiBuView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSArray * cellArry;
@property (nonatomic,strong) NSArray * labelArr;
//H2

@property (nonatomic,strong)NSMutableArray*myViewArr;
@property (nonatomic,strong)NSDictionary *myViewDic;
@end
//设置分割线
static NSString *const sectionHeaderCellIdentifer = @"MySectionHeaderCell";
//设置cell的内容
static NSString *const contentCellIdentifer = @"MyContentCell";
//开通汇付
static NSString *const  isNotOpenAccoutCell = @"MyViewTableViewCell";

@implementation MyViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    //去掉tableview的滑动条
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isflag"];
    _myViewDic = [NSDictionary dictionary];

    UIView * weiView = [UIView new];
    weiView.backgroundColor = [UIColor blackColor];
    weiView.frame = CGRectMake(0, 0, 10, 100);
    [self.tableTailView addSubview:weiView];

//    _tableView.backgroundColor = [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1];
    
//H1
    
    
    _cellArry = [NSArray arrayWithObjects:@"qiandao.png",@"wodetouzi.png",@"jiaoyi.png",@"fuli.png",@"yaoqing.png",@"zijinjilu.png", nil];
    _labelArr = [NSArray arrayWithObjects:@"资金记录",@"我的投资",@"债权交易",@"我的福利",@"邀请有奖",@"积分签到", nil];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, kMyTailViewHeight+10, SCREEN_WIDTH, (SCREEN_WIDTH)/3*2) collectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-4)/3,SCREEN_WIDTH/3);
    self.collectionView.scrollEnabled = NO;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 1, 1, 1);
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1]];
    [_collectionView registerNib:[UINib nibWithNibName:@"MyTailViewCollectionViewCell"  bundle:nil ]forCellWithReuseIdentifier:@"cell"];
    [self.tableView addSubview:self.collectionView];
//H2
    
    
    
}

//h1
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_cellArry count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"cell";
    MyTailViewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.imageview.image = [UIImage imageNamed:_cellArry[indexPath.item]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _labelArr[indexPath.item ]];
//    cell.textLabel.text = [NSString stringWithFormat:@"hhhhhhhh"];
    return cell;
}


#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MyTailViewCollectionViewCell * cell = (MyTailViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
//    cell.backgroundColor = [UIColor greenColor];
    NSLog(@"item======%ld",(long)indexPath.item);
    NSLog(@"row=======%ld",(long)indexPath.row);
    NSLog(@"section===%ld",(long)indexPath.section);
    
    if (indexPath.item == 0) {
        FundAccountViewController *fundAccountVC = [FundAccountViewController new];
        [self.navigationController pushViewController:fundAccountVC animated:YES];
    }else if (indexPath.item == 1){
        MyDisperseInvestViewController * disperseInvestVC = [MyDisperseInvestViewController new];
        [self.navigationController pushViewController:disperseInvestVC animated:YES];
    }else if (indexPath.item == 2){
        MyCreditorViewController * creditorVC = [MyCreditorViewController new];
        [self.navigationController pushViewController:creditorVC animated:YES];

    }else if (indexPath.item == 3){
        HongbaoViewController * hongBaoVC = [HongbaoViewController new];
        [self.navigationController pushViewController:hongBaoVC animated:YES];
    }else if (indexPath.item == 4){
        InvitationFriendsVC * invitationVC = [InvitationFriendsVC new];
        [self.navigationController pushViewController:invitationVC animated:YES];
    }else if (indexPath.item == 5){
        IntegralViewController * integralVC = [IntegralViewController new];
        [self.navigationController pushViewController:integralVC animated:YES];
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//h2


- (void)getMyData
{
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"financialproduct/wealthindex" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _myViewDic = dic;
            
            _tableHeaderView.moneyLabel.jumpValue = IsStrEmpty([_myViewDic objectForKey:@"Income"])?@"0.00":[_myViewDic objectForKey:@"Income"];
//
            [self setupNavi];
            
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        if (_myViewDic != nil) {
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
        [self headerRefreshloadData];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    
    NSString *flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"isflag"];
    if ([flag isEqualToString:@"1"]) {
        self.hideNaviBar = YES;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
   
    if ([[User userFromFile].isOpenAccount integerValue] == 0 || [User userFromFile].isOpenAccount == nil) {
        //保存用户信息
        [self updateUserInfo];
    }
    
    
    isOpen = [[User userFromFile].isOpenAccount integerValue];
    [self getMyData];
    
     [self setupTableView];
    
    //跳转  资金记录/回款计划
    if (isOpen) {
        [_tableHeaderView.fundRecodeBtn addTarget:self action:@selector(fundRecodeBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView.returnPlanBtn addTarget:self action:@selector(returnPlanBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //H1   跳转  提现/充值
    if (isOpen) {
        [_tableHeaderView.withdrawalBtn addTarget:self action:@selector(withdrawalBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView.topupBtn addTarget:self action:@selector(topupBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        //公告
        [_tableTailView.mewAnnouncementBtn addTarget:self action:@selector(mewAnnouncementBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    //H2
    
}
//H1
//跳转提现
- (void)withdrawalBtnEvent
{
    WebPageVC *vc = [[WebPageVC alloc] init];
    vc.title = @"提现";
    vc.name = @"withdrawcash";
    [self.navigationController pushViewController:vc animated:YES];
}
//跳转充值
- (void)topupBtnEvent
{
    //充值
    WebPageVC *vc = [[WebPageVC alloc] init];
    vc.title = @"充值";
    vc.name = @"recharge";
    [self.navigationController pushViewController:vc animated:YES];
}
//最新公告
- (void)mewAnnouncementBtnEvent
{
    MoreWebViewController *moreWebVC = [MoreWebViewController new];
    moreWebVC.titleStr = @"公告资讯";
    moreWebVC.webStr = @"/advisory.jsp";
    [self.navigationController pushViewController:moreWebVC animated:YES];
}

//总资金
- (void)zongZiBtnEvent
{
    FundManagerController * funManagerVC = [FundManagerController new];
    [self.navigationController pushViewController:funManagerVC animated:YES];
    
}
//H2
- (void)updateUserInfo{

    if ([User userFromFile].password == nil) {
        return;
    }
    [self.httpUtil requestObj4MethodName:@"user/login" parameters:@{@"UserName":[User userFromFile].userName,@"Password":[User userFromFile].password} result:^(id obj, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            User *user = (User *)obj;
            //存储
            [user saveUser];
            //
            [user saveLogin];
            
        }else{
        }
        
    } convertClassName:@"User" key:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //如果是当前控制器，则隐藏背景；如果不是当前控制器，则显示背景
    if (viewController == self) {
      
        if (true) {
            self.hideNaviBar = YES;
        }else{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        
//        for (UIView *view in [self.navigationController.navigationBar subviews]) {
//            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
//                
//                //最好使用隐藏，指不定什么时候你又想让他出现
////                view.hidden = YES;
//               
//                
//                //如果不想让它一直出现，那么可以移除
//                //                [view removeFromSuperview];
//            }
//        }
    }
//    else {
//        for (UIView *view in [self.navigationController.navigationBar subviews]) {
//            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
//                view.hidden = YES;
//            }
//        }
//    }
}


#pragma mark - SetupUI
- (void)setupNavi
{
//     iconButton
    UIImageView *iconImageView = [[UIImageView alloc]init];
    [NetWorkingUtil setImage:iconImageView url:[_myViewDic objectForKey:@"Avatar"] defaultIconName:@"my_defaultIcon"];
    UIImage *icon = [iconImageView.image imageMakeRoundCornerSize:CGSizeMake(30, 30)];
    [_iconButton setImage:icon forState:UIControlStateNormal];
    isOpen = [[User userFromFile].isOpenAccount integerValue];

}

- (void)setupTableView
{
    //UIEdgeInsetsMake他的作用就是定义一个在scrollview被拽出一个contentOffset 的时候的一个空间配合blocks可以实现下拉刷新中footer部分的停留
    self.tableView.contentInset = UIEdgeInsetsMake(kMyHeaderViewHeight, 0, 0, 0);
    
    // table header view
    MyHeaderView *tableHeaderView = [MyHeaderView viewFromXib];
    if (!isOpen) {
        tableHeaderView.isOpenAccount = NO;
    }else{
        tableHeaderView.isOpenAccount = YES;
    }
    
    [self.tableView addSubview:tableHeaderView];
    self.tableHeaderView = tableHeaderView;
    [tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.top.equalTo(self.tableView).offset(-kMyHeaderViewHeight);
        make.right.equalTo(self.view.mas_right);
        //头部高度
        make.height.mas_equalTo(267);
    }];
    //H1
    MyTailView *tableTailView = [MyTailView viewFromXib];
    
    if (!isOpen) {
        tableTailView.isOpenAccount = NO;
    }else{
        tableTailView.isOpenAccount = YES;
    }
    [self.tableView addSubview:tableTailView];
    
    self.tableTailView = tableTailView;
    [tableTailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.top.equalTo(_tableHeaderView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(34);
    }];

    
    MyWeiBuView * tableWeiBuView = [MyWeiBuView viewFromXib];
    if (!isOpen) {
        tableWeiBuView.isOpenAccount = NO;
    }else{
        tableWeiBuView.isOpenAccount = YES;
    }
    [self.tableView addSubview:tableWeiBuView];
    self.tableWeiBuView = tableWeiBuView;
    [tableWeiBuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.top.equalTo(_collectionView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(91);
    }];
    
    //H2
    // register cell
    
    [self.tableView registerNib:[UINib nibWithNibName:contentCellIdentifer bundle:nil] forCellReuseIdentifier:contentCellIdentifer];
    //分割线
    [self.tableView registerNib:[UINib nibWithNibName:sectionHeaderCellIdentifer bundle:nil] forCellReuseIdentifier:sectionHeaderCellIdentifer];
    
    [self.tableView registerNib:[UINib nibWithNibName:isNotOpenAccoutCell bundle:nil] forCellReuseIdentifier:isNotOpenAccoutCell];
    
}

#pragma mark - override
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions
- (IBAction)iconAction
{
    if ([[User userFromFile].isOpenAccount integerValue] == 0) {
//        WebPageVC *vc = [[WebPageVC alloc] init];
//        vc.title = @"开通汇付账户";
//        vc.name = @"huifu/openaccount";
//        [self.navigationController pushViewController:vc animated:YES];
        AccountSafeController *vc = [[AccountSafeController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        AccountSafeController *vc = [[AccountSafeController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}

- (IBAction)moreAction
{
   
    MoreViewController *vc = [[MoreViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)returnPlanBtnEvent
{
    RefundPlanViewController *vc = [[RefundPlanViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fundRecodeBtnEvent
{
    FundAccountViewController *fundAccountVC = [FundAccountViewController new];
    [self.navigationController pushViewController:fundAccountVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;

    if (contentOffsetY <= -155)// -170 ~ -155 之间
    {
        CGFloat midValue = 170 - 155;
        CGFloat offsetValue = midValue + 0.5 - (kMyHeaderViewHeight + contentOffsetY);
        _custemNavi.alpha = offsetValue/midValue;
    }
    else if (contentOffsetY <= -110)// -155 ~ -110
    {
        _custemNavi.alpha = 0.0;
        CGFloat midValue = 155 - 110;
        CGFloat offsetValue = midValue + 0.7 - (155 + contentOffsetY);
        _tableHeaderView.moneyLabel.alpha = offsetValue/midValue;
    }
    else if (contentOffsetY <= -109)// 调整 alpha
    {
        _tableHeaderView.moneyLabel.alpha = 0.0;
    }
}

//上拉加载数据
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y <= -260)
    {
         _tableHeaderView.moneyLabel.jumpValue = [_myViewDic objectForKey:@"Income"];
        
          _tableHeaderView.isOpenAccount = YES;
        
        [self getMyData];
    }
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isOpen) {
        return 4;
    }else{
        return 1;
    }
    
}
//每个区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isOpen) {
        if (section == 1)
        {
            return 2;
        }
        else
        {
            return 2;
        }
    }else{
        return 1;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (!isOpen) {
        
        MyViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:isNotOpenAccoutCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.commitBtn addTarget:self action:@selector(openTreasure:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:sectionHeaderCellIdentifer forIndexPath:indexPath];

//        [(MySectionHeaderCell*)cell titleLabel].text = @"投资管理";
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifer forIndexPath:indexPath];
        
        NSString *title;
        NSString *iconName;
        NSString *detailText;
        NSString *detailText1;

        BOOL hide;

        if (indexPath.section == 0 && indexPath.row == 0)
        {
            title = @"资金管理";
            iconName = @"my_money";
            NSString *str = [NSString stringWithFormat:@"%@",[_myViewDic objectForKey:@"Balance"]];
            
            if (IsStrEmpty(str)) {
                detailText = @"0";
            }else{
//                detailText = [@"¥" stringByAppendingString:[[NSString stringWithFormat:@"%@",str] strmethodComma]];
                
                
                detailText = [NSString stringWithFormat:@"%@",str];
                _tableHeaderView.availableBalanceLabel.text = detailText;
            }
            
            detailText1 = [[NSString stringWithFormat:@"%@",[_myViewDic objectForKey:@"SumBalance"]] strmethodComma];
            _tableHeaderView.totalAssetsLabel.text = detailText1;
            NSLog(@"------2222222222---------%@",_tableHeaderView.totalAssetsLabel.text);
            
            hide = NO;
        }
        else if(indexPath.section == 0 && indexPath.row == 1)
        {
            title = @"我的银行卡";
            iconName = @"my_mastercard";
            detailText = [NSString stringWithFormat:@"%d张",[[_myViewDic objectForKey:@"CardCount"] intValue]];
            hide = YES;
        }

        
//        [(MyContentCell *)cell setupContentIcon:iconName title:title detailText:detailText hideLine:hide];
    }

    return cell;
}

// 开通财富跳转

- (void)openTreasure:(UIButton *)btn{

    WebPageVC *vc = [[WebPageVC alloc] init];
    vc.title = @"开通汇付账户";
    vc.name = @"huifu/openaccount";
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isOpen) {
       return 44.0;
    }else{
        return SCREEN_HEIGHT - kMyHeaderViewHeight;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 14.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isOpen){
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return;
    }
    
    UIViewController *vc;
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isflag"];
         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isflag"];
        
        vc = [[FundManagerController alloc]init];
        
        self.navigationController.navigationBarHidden = YES;
        
    }
    
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isflag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isflag"];
        vc = [[MyBankCardViewController alloc] init];
        
    }
    else if(indexPath.section == 1 && indexPath.row == 1)
    {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isflag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isflag"];
        vc = [[MyDisperseInvestViewController alloc] init];
    }
    
//    else if(indexPath.section == 1 && indexPath.row == 2)
//    {
//        vc = [[FinancialProductViewController alloc] init];
//    }
    else if(indexPath.section == 1 && indexPath.row == 2)
    {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isflag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isflag"];
        vc = [[MyCreditorViewController alloc] init];
    }
    
    else if(indexPath.section == 2 && indexPath.row == 0){
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isflag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isflag"];
        vc = [[InvitationFriendsVC alloc] init];
    }
    
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isflag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isflag"];
        vc = [[HongbaoViewController alloc] init];
    }else if (indexPath.section == 2 && indexPath.row == 2){
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isflag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isflag"];
        vc = [[IntegralViewController alloc] init];
    }
    
    vc.hidesBottomBarWhenPushed = YES;
   
    [self.navigationController pushViewController:vc animated:YES];
    
   
}


@end
