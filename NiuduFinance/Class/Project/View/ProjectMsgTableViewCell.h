//
//  ProjectMsgTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *educationLab;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UILabel *marrigeLab;
@property (weak, nonatomic) IBOutlet UILabel *houseLab;
@property (weak, nonatomic) IBOutlet UILabel *carLab;
@property (weak, nonatomic) IBOutlet UILabel *borrowMoneyLab;


@property (nonatomic,strong)NSDictionary *borrowerInfoDic;
@end
