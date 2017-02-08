//
//  ChoseBankCardCell.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseBankCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;


@property (weak, nonatomic) IBOutlet UIImageView *choseImageView;


@property (nonatomic,strong) NSString *iconString;

@property (nonatomic,assign)BOOL isChose;
@end

