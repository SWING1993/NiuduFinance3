//
//  MessageCenterViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/21.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MessageCenterViewController.h"
//#import "MessageCenterTableViewCell.h"
#import "MessageCellTableViewCell.h"
#import "NSString+Adding.h"
@interface MessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageCenterTableView;

@property (nonatomic,strong)NSMutableArray *messageCenterArr;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"消息中心";
    
    _messageCenterArr = [NSMutableArray array];
    _messageCenterTableView.tableFooterView = [UIView new];
    [_messageCenterTableView registerNib:[UINib nibWithNibName:@"MessageCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCenterTableViewCell"];
    
    [self getMessageCenterData];
    
    
}

- (void)getMessageCenterData
{
   MBProgressHUD *hud =  [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"messages/list" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            self.hideNoNetWork = YES;
            [_messageCenterArr addObjectsFromArray:arr];
            [hud hide:YES];
            if (_messageCenterArr.count == 0) {
                self.hideNoMsg = NO;
            }else{
                self.hideNoMsg = YES;
            }
            
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            
            self.hideNoNetWork = NO;
        }
        [_messageCenterTableView reloadData];
    } convertClassName:nil key:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _messageCenterArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *riskStr = [NSString stringWithFormat:@"%@",[_messageCenterArr[indexPath.row] objectForKey:@"Content"]];
    
    NSString *contentStr = nil;
    NSScanner * scanner = [NSScanner scannerWithString:riskStr];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        contentStr = [riskStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
    }
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"p" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"br/" withString:@"\n"];
    
    CGSize riskSize =[contentStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedSize:CGSizeMake(SCREEN_WIDTH - 30 , 5000)];
    
        
    return 77 - 30+ riskSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *cellId = @"MessageCenterTableViewCell";
    MessageCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[MessageCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.msgCenterDic = _messageCenterArr[indexPath.row];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
