//
//  MyContentCell.h
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/3.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyContentCell : UITableViewCell

- (void)setupContentIcon:(NSString *)iconName title:(NSString *)title detailText:(NSString *)detail hideLine:(BOOL)hide;
@property (weak, nonatomic) IBOutlet UIImageView *jianTouImageView;
@end
