//
//  FriendsHeaderView.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/19.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FriendsHeaderView.h"


@interface FriendsHeaderView()

@property (nonatomic,strong) UILabel *messageLabel;

@end

@implementation FriendsHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.99f green:0.93f blue:0.93f alpha:1.00f];
    }
    return self;
}

- (void)setHeaderDic:(NSDictionary *)headerDic
{
    _headerDic = headerDic;
    
    [self loadView];
}

- (void)loadView{

    _messageLabel = [[UILabel alloc] init];
    
    _messageLabel.text = [NSString stringWithFormat:@"我的奖励%@元  好友奖励%@元  好友注册%@人  好友投资%@人",[self.headerDic objectForKey:@"BounsAmount"],[self.headerDic objectForKey:@"FriendBouns"],[self.headerDic objectForKey:@"InvitationCount"],[self.headerDic objectForKey:@"BidCount"]];
    _messageLabel.adjustsFontSizeToFitWidth  = YES;
    [_messageLabel setFont:[UIFont systemFontOfSize:13]];
    [_messageLabel setTextColor:NaviColor];
    [self addSubview:_messageLabel];
    
 
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.bottom.equalTo(self);
    }];
}

@end
