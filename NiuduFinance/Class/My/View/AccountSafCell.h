//
//  AccountSafCell.h
//  NiuduFinance
//
//  Created by 123 on 17/2/5.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSafCell : UITableViewCell

- (void)setuptitle:(NSString *)title detailText:(NSString *)detail hideLine:(BOOL)hide jianTouImageView:(BOOL)jianTouImageView zhegnjainLabel:(BOOL)zhegnjainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jianTouImageView;
@property (weak, nonatomic) IBOutlet UILabel *zhegnjainLabel;
//详情
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight;

@end
