//
//  InvitationFriendsVC.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "InvitationFriendsVC.h"
#import "CodeTableViewCell.h"
#import "CodeDetailTableViewCell.h"
#import "FriendsTableViewCell.h"
#import "FriendsHeaderView.h"

#define CodeCell @"CodeTableViewCell"
#define CodeDetailCell @"CodeDetailTableViewCell"
#define FriendsCell @"FriendsTableViewCell"

@interface InvitationFriendsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;

@property (nonatomic,strong) UIButton *selectButtnon;

@property (nonatomic,strong) NSDictionary  *friendsDic;
@property (nonatomic,strong) NSMutableArray *friendArr;
//
@property (nonatomic,assign)NSInteger allBidPage;
@property (nonatomic,assign)NSInteger allBidCount;

@property (nonatomic,strong) NSDictionary *ruleDic;

@end

@implementation InvitationFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邀请好友";
    
    [self backBarItem];
    
    [self setupTableview];
    _selectButtnon = _buttonArray[0];
//    [self setupRefreshWithTableView:_tableView];
    [self setupHeaderRefresh:_tableView];
    
    _ruleDic = [NSDictionary dictionary];
    _friendsDic = [NSDictionary dictionary];
    _friendArr = [NSMutableArray array];
    _allBidPage = 1;
    _allBidCount = 0;
    
    [_selectButtnon setTitleColor:NaviColor forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCopyNoti) name:@"copysuccessNoti" object:nil];
    [self getRuleData];
    
}

- (void)showCopyNoti{
    
    [MBProgressHUD showMessag:@"复制成功" toView:self.view];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"copysuccessNoti" object:nil];;
}

- (void)setupTableview{

    _tableView.backgroundColor = BlackCCCCCC;
    _tableView.tableFooterView = [UIView new];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    
    [_tableView registerNib:[UINib nibWithNibName:CodeCell bundle:nil] forCellReuseIdentifier:CodeCell];
    
    [_tableView registerNib:[UINib nibWithNibName:CodeDetailCell bundle:nil] forCellReuseIdentifier:CodeDetailCell];
    
    [_tableView registerNib:[UINib nibWithNibName:FriendsCell bundle:nil] forCellReuseIdentifier:FriendsCell];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(UIButton *)sender {
 
    if (sender == _selectButtnon) {
        return;
    }else{
        [_selectButtnon setTitleColor:BlackCCCCCC forState:UIControlStateNormal];
    }
    _selectButtnon = sender;
    [_selectButtnon setTitleColor:NaviColor forState:UIControlStateNormal];
    if (_selectButtnon == _buttonArray[0]) {
        //邀请规则
        self.tableView.separatorStyle = NO;
        self.tableView.scrollEnabled = YES;
        [self showRuleView];
        
        [self getRuleData];
        
    }else{
        
        //邀请的好友
         [self setupFooterRefresh:_tableView];
         self.tableView.scrollEnabled = YES;
        self.tableView.separatorStyle = YES;
        [self loadFriendsData];
    }
}

#pragma mark -- 获得邀请规则信息
- (void)getRuleData{

    
    [self.httpUtil requestDic4MethodName:@"invitationfriend/rule" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            
            [_tableView.mj_footer resetNoMoreData];
            
            _ruleDic = dic;
            
            if (_ruleDic == nil) {
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
    }];
    
   
}


-(void) showRuleView{

    _tableView.separatorStyle = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_tableView reloadData];
}

- (void)loadFriendsData{

    _tableView.separatorStyle = NO;
     MBProgressHUD *hud = [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestDic4MethodName:@"invitationfriend/log" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            if (_allBidPage == 1) {
                [_friendArr removeAllObjects];
            }
            [hud hide:YES];
            
            [_tableView.mj_footer resetNoMoreData];
            _friendsDic = dic;
            
            [_friendArr addObjectsFromArray:[_friendsDic objectForKey:@"Data"]];
            
            
            if (_friendsDic == nil) {
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
    }];
    

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_selectButtnon == _buttonArray[0]) {
        
        return 1;
    }else{
        return 1;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_selectButtnon == _buttonArray[1]&&section!=0) {
        return 15;
    }else if(_selectButtnon == _buttonArray[1]&&section==0){
        return 35;
    }else{
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_selectButtnon == _buttonArray[1]&& section == 0){
    FriendsHeaderView *headerView = [[FriendsHeaderView alloc] init];
    headerView.headerDic = [_friendsDic objectForKey:@"Statistics"];
    return headerView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectButtnon == _buttonArray[0]) {
        if (indexPath.row == 0) {
            if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
                return 180;
            }else{
            return 205;
            }
            
        }else if(indexPath.row == 1){
            
            
            if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
                return SCREEN_HEIGHT - 180;
            }else{
                return SCREEN_HEIGHT - 195 - 49-49;
            }
            
        }
        
    }
    
    return 185;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectButtnon == _buttonArray[0]) {
       
        return 2;
    }else{
        return self.friendArr.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (_selectButtnon == _buttonArray[0]) {
        
        if (indexPath.row == 0) {
            CodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CodeCell];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            NSLog(@"%ld",_ruleDic.count);
            if (_ruleDic.count != 0) {
                cell.msgDic = _ruleDic;

            }
            
            return cell;
        }else if (indexPath.row == 1){
            
            CodeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CodeDetailCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            
            return nil;
        }
        
        
    }else{
        
        FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendsCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dic = _friendArr[indexPath.row];
        return cell;
    }
    
}


- (void)headerRefreshloadData
{
    if (_selectButtnon == _buttonArray[1]) {
        [self loadFriendsData];
        
        [_tableView.mj_header endRefreshing];
    }else{
        [self loadFriendsData];
         [_tableView.mj_header endRefreshing];
    }
   
}

- (void)footerRefreshloadData
{
    if (_selectButtnon == _buttonArray[1]) {
        
        if (_allBidCount < 5) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer resetNoMoreData];
            _allBidPage ++;
            [self loadFriendsData];
            [_tableView.mj_footer endRefreshing];
        }
    }else{
        
         [_tableView.mj_footer endRefreshing];
    }

}
@end
