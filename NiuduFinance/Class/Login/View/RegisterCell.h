//
//  RegisterCell.h
//  NiuduFinance
//
//  Created by 123 on 17/2/5.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITextField *xianTextLabel;


-(void)setupdetailLabel:(NSString *)detailLabel xianTextLabel:(UITextField *)xianTextLabel;
@end
