//
//  WindDataTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectIntroduceViewController;
@interface WindDataTableViewCell : UITableViewCell
@property (nonatomic,weak) ProjectIntroduceViewController*delegate;

@property (nonatomic,strong)NSMutableArray *projectImageArr;
@end
