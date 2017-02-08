//
//  HomeViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/24.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "AdScrollView.h"
#import "ProjectDetailsViewController.h"
#import "ReflectUtil.h"
#import "ProjectModel.h"
#import "AppDelegate.h"
#import "NSString+Adding.h"
#import "ProjectNewTableViewCell.h"
#import "SDCycleScrollView.h"
#import "PageWebViewController.h"
#import "MoreWebViewController.h"


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
//    静
    NSInteger             selectButtonTag;
    
}
//底部tableview
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
//头部view
@property (strong, nonatomic) IBOutlet UIView *headerTableView;
//头部view的最底下
@property (weak, nonatomic) IBOutlet UIView *bottonView;
//头部view的图片view
@property (weak, nonatomic) IBOutlet UIView *headerView;
//banner图片数组
@property (nonatomic,strong)NSMutableArray *bannerImageArr;

@property (nonatomic,strong)NSMutableArray *recProductArr;

//三个button新手专享/散标投资/债权转让
//静
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
//@property (weak, nonatomic) IBOutlet UIButton *userEnjoyButton;
//@property (weak, nonatomic) IBOutlet UIButton *investButton;
//@property (weak, nonatomic) IBOutlet UIButton *financiaButton;
//牛伯伯记文章view
@property (weak, nonatomic) IBOutlet UIView *articleView;
@property (strong, nonatomic) IBOutlet UIView *tailTableView;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectButtonTag=111;
    _bannerImageArr = [NSMutableArray array];

    _recProductArr = [NSMutableArray array];
    

    [self setTableViewInfo];

    //刷新
    [_homeTableView.mj_header beginRefreshing];
    
    //对实现新手,理财,投资跳转添加手势
    
//    [self addBottomView];
    

    UIView * tailView = [UIView new];
    
    [_homeTableView addSubview:tailView];
    
}

- (void)addBottomView{
    

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bottonView.frame.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    
    recommendLabel.text = @"精选推荐";
    [recommendLabel setTextColor:[UIColor blackColor]];
    
    recommendLabel.font = [UIFont systemFontOfSize:18];
    
    [view addSubview:recommendLabel];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 95, 5, 80, 40)];
    moreButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
//    moreButton.backgroundColor = [UIColor redColor];
    
    [moreButton setTitle:@"更多 >" forState:UIControlStateNormal];
//    moreButton.backgroundColor = [UIColor purpleColor];
    moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    moreButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal ];
    
    [moreButton addTarget:self action:@selector(userEnjoyGusture) forControlEvents:UIControlEventTouchUpInside];
    moreButton.userInteractionEnabled = YES;
    view.userInteractionEnabled = YES;
//    self.bottonView.userInteractionEnabled = YES;
    [view addSubview:moreButton];
    
    [_bottonView addSubview:view];
}
 
- (IBAction)userInvestFinanciaButton:(id)sender {
    UIButton *button=sender;
    UIButton *buttons=[self.view viewWithTag:selectButtonTag];
    [buttons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0/255.0f green:154/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
    selectButtonTag=button.tag;
    NSInteger x=button.tag-111;
    _lineLabel.frame=CGRectMake(x*(SCREEN_WIDTH/3), 261, SCREEN_WIDTH/3, 2);
    _lineLabel.backgroundColor = Nav019BFF;
    
    if (button.tag==111)
    {
//点击新手专享
        NSLog(@"11111111111111被点击了");
    }
    else if (button.tag==112)
    {
//点击散标投资
        NSLog(@"22222222222222被点击了");
    }
    else if (button.tag==113)
    {
//点击债权转让
        NSLog(@"33333333333333被点击了");
    }
}

- (IBAction)anccmentBtn:(id)sender {
    
    MoreWebViewController *moreWebVC = [MoreWebViewController new];
    moreWebVC.titleStr = @"公告资讯";
    moreWebVC.webStr = @"/advisory.jsp";
    [self.navigationController pushViewController:moreWebVC animated:YES];
    
}


#pragma mark -- 实现新手,理财,投资跳转
- (void)userEnjoyGusture{

    
}

- (void)financiaGusture{

}

- (void)investGusture{


}



- (void)getHomeData
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"home/index" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
            [hud hide:YES];
            self.hideNoNetWork = YES;

            _bannerImageArr = [dic objectForKey:@"IndexImgs"];

            NSMutableArray *imageUrlArr = [NSMutableArray array];
            for (NSDictionary *dict in _bannerImageArr) {
                [imageUrlArr addObject:[dict objectForKey:@"ImgUrl"]];
            }
            /**
             mark by vi_chen
             
             描述：把数组－－>字典结构转换成数组－－>对象结构
             输入参数：
             calssName：指定对象类名 比如：@"Student"
             otherObject:数组－－>字典
             isList：YES:代表是数组－－>字典结构，NO:表示是字典结构
             
             输出：返回转换完成的对象
             */
            _recProductArr = [ReflectUtil reflectDataWithClassName:@"ProjectModel" otherObject:[dic valueForKey:@"AppRecProduct"] isList:YES];
            //轮播器
            SDCycleScrollView *autoScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.0, 0.0,SCREEN_WIDTH, 175.0) imageURLStringsGroup:imageUrlArr];
            autoScrollView.delegate = self;
            [_headerView addSubview:autoScrollView];

            
//            if(_recProductArr.count == 0) {
//             //暂无数据高度设置
//                
//
//                
//                self.noMsgView.top = _bottonView.frame.origin.y + 40;
//                self.noMsgView.width = SCREEN_WIDTH;
//                self.noMsgView.height = _homeTableView.frame.size.height-470;
//                [self.homeTableView addSubview:self.noMsgView];
//
//
//            }else{
//
//                [self.noMsgView removeFromSuperview];
//            }

        }else{
//刷新
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
            self.hideNoNetWork = NO;
        }
        [_homeTableView reloadData];

    }];
    
    
}






- (void)setTableViewInfo
{
    self.homeTableView.tableHeaderView = self.headerTableView;
    self.homeTableView.tableFooterView = self.tailTableView;

    
    //首页下拉刷新
    [self setupHeaderRefresh:_homeTableView];
    
    [_homeTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    [_homeTableView registerNib:[UINib nibWithNibName:@"ProjectNewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectNewTableViewCell"];

}


//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _recProductArr.count;
}
//对应的section有多少个元素，也就是多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//指定的 row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}
//section的header view 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
//section的footer view 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ProjectNewTableViewCell";
    ProjectNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProjectNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_recProductArr.count != 0) {
        cell.homeProject = _recProductArr[indexPath.section];
    }
    
    //详情按钮
    [cell.projectDetailClick addTarget:self action:@selector(projectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.projectDetailClick.tag = indexPath.section;
    
    return cell;
}

- (void)projectBtnClick:(UIButton *)btn{

    ProjectModel *project = _recProductArr[btn.tag];
    if (project.isNew == 0) {
        [MBProgressHUD showMessag:@"您已不是新手了，不能投资新手专享标" toView:self.view];
        return;
    }
    
    ProjectDetailsViewController *projectDetailsVC = [ProjectDetailsViewController new];
    projectDetailsVC.statueId = [NSString stringWithFormat:@"%d",project.statusId];
    if (project.type == 1) {
        projectDetailsVC.projectId = project.Id;
    }else if (project.type == 2){
        projectDetailsVC.productId = project.Id;
        projectDetailsVC.type = @"理财";
    }
    [self.navigationController pushViewController:projectDetailsVC animated:YES];
    
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if (!IsStrEmpty([_bannerImageArr[index] objectForKey:@"LinkUrl"])) {
        
        PageWebViewController *pageWebVC = [PageWebViewController new];
        pageWebVC.urlStr = [_bannerImageArr[index] objectForKey:@"LinkUrl"];
        pageWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pageWebVC animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.hideNaviBar = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (self.hideNoNetWork == NO) {
        [self getHomeData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.hideNaviBar = NO;
    
}


- (void)headerRefreshloadData
{
    [self getHomeData];
    [_homeTableView.mj_header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
