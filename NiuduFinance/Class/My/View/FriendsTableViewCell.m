//
//  FriendsTableViewCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/19.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FriendsTableViewCell.h"

@interface FriendsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *profitLabel;

@property (weak, nonatomic) IBOutlet UILabel *isOpenAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *investLabel;




@end

@implementation FriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    //添加好友信息
    
    _nameLabel.text = [dic objectForKey:@"UserName"];
    _dateLabel.text = [dic objectForKey:@"CreateDate"];
    _phoneNumLabel.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"Mobile"] stringByReplacingCharactersInRange:NSMakeRange(3, 7) withString:@"********"]];
//    _phoneNumLabel.text = [dic objectForKey:@"Mobile"];
    _profitLabel.text = [NSString stringWithFormat:@"%@元",[dic objectForKey:@"BounsAmount"]];
    if ([[dic objectForKey:@"IsOpenAccount"] integerValue] ==1) {
        _isOpenAccountLabel.text = @"已开通";

    }else{
        _isOpenAccountLabel.text = @"未开通";
    }
    if ([[dic objectForKey:@"IsBid"] integerValue] ==1) {
        _investLabel.text = @"已投资";
    }else{
        _investLabel.text = @"未投资";
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
