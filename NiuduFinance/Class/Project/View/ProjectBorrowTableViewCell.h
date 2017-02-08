//
//  ProjectBorrowTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectBorrowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectNumLab;
@property (weak, nonatomic) IBOutlet UILabel *successNumLab;
@property (weak, nonatomic) IBOutlet UILabel *repaymentSuccessNumLab;
@property (weak, nonatomic) IBOutlet UILabel *successAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *owingAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *overdueNumLab;
@property (weak, nonatomic) IBOutlet UILabel *overdueAmountLab;

@property (nonatomic,strong)NSDictionary *creditFileDic;
@end
