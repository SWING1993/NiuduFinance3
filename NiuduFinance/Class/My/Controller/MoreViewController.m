//
//  MoreViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/8.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MoreViewController.h"
//#import "MyContentCell.h"
#import "FeedbackViewController.h"
#import "MoreWebViewController.h"
#import "User.h"
#import "PCCircleViewConst.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "MessageCenterViewController.h"
#import "AccountSafeCell.h"


@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@end
//static NSString *cellIdentifier = @"MyContentCell";
static NSString *accountSafeCell = @"AccountSafeCell";

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多";
    _exitBtn.layer.cornerRadius = 5.0f;
    
    [self backBarItem];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setupTableView
{
    // 添加 table foot view
    self.tableView.tableFooterView = _tableFooterView;
    [_tableView registerNib:[UINib nibWithNibName:accountSafeCell bundle:nil] forCellReuseIdentifier:accountSafeCell];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountSafeCell *cell = [tableView dequeueReusableCellWithIdentifier:accountSafeCell forIndexPath:indexPath];
    NSString *title;
    BOOL hideLine;
    BOOL jianTouImageView;
//    if (indexPath.section == 0 && indexPath.row == 0)
//    {
//        icon = @"more_active_center";
//        title = @"活动中心";
//        hideLine = NO;
//    }
//    else
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        title = @"消息中心";
        hideLine = NO;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        title = @"公告资讯";
        hideLine = NO;
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        title = @"常见问题";
        hideLine = NO;
    }
//    else if (indexPath.section == 0 && indexPath.row == 4)
//    {
//        icon = @"more_safe";
//        title = @"安全保障";
//        hideLine = NO;
//    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        title = @"关于我们";
        hideLine = NO;
    }
    else if (indexPath.section == 0 && indexPath.row == 4)
    {
        title = @"意见反馈";
        hideLine = YES;
    }
    
    
    [cell setuptitle:title detailText:nil hideLine:hideLine jianTouImageView:jianTouImageView ];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreWebViewController *moreWebVC = [MoreWebViewController new];
//    if (indexPath.section == 0 && indexPath.row == 0)
//    {
//        moreWebVC.titleStr = @"活动中心";
//        moreWebVC.webStr = @"activitycenter.jsp";
//        [self.navigationController pushViewController:moreWebVC animated:YES];
//    }
//    else
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        moreWebVC.titleStr = @"消息中心";
        MessageCenterViewController *messageCenterVC = [MessageCenterViewController new];
        [self.navigationController pushViewController:messageCenterVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        moreWebVC.titleStr = @"公告资讯";
        moreWebVC.webStr = @"/advisory.jsp";
        [self.navigationController pushViewController:moreWebVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        moreWebVC.titleStr = @"常见问题";
        moreWebVC.webStr = @"/commonproblem.jsp";
        
        [self.navigationController pushViewController:moreWebVC animated:YES];
    }
//    else if (indexPath.section == 0 && indexPath.row == 4)
//    {
//        moreWebVC.titleStr = @"安全保障";
//        moreWebVC.webStr = @"NewsInformation/InvestSecurity";
//        [self.navigationController pushViewController:moreWebVC animated:YES];
//    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        
        moreWebVC.titleStr = @"关于我们";
        moreWebVC.webStr = @"/aboutus.jsp";
        [self.navigationController pushViewController:moreWebVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 4)
    {
        FeedbackViewController *vc = [[FeedbackViewController alloc ]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)exitBtnClick:(id)sender {
    [[User shareUser] saveExit];
    [[User shareUser] removeUser];
    [User shareUser].userId = 0;
    [PCCircleViewConst removeGesture:gestureFinalSaveKey];

    LoginViewController*loginVC = [[LoginViewController alloc] init];
    loginVC.typeStr = @"exit";
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
