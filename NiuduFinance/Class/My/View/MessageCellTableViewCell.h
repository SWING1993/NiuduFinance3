//
//  MessageCellTableViewCell.h
//  NiuduFinance
//
//  Created by andrewliu on 16/11/3.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *msgTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *msgDataLab;
@property (weak, nonatomic) IBOutlet UILabel *msgContentLab;

@property (nonatomic,strong)NSDictionary *msgCenterDic;
@end
