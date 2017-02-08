//
//  MessageCenterTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/21.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *msgTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *msgDataLab;
@property (weak, nonatomic) IBOutlet UILabel *msgContentLab;

@property (nonatomic,strong)NSDictionary *msgCenterDic;

@end
