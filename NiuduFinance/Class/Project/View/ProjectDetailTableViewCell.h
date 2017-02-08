//
//  ProjectDetailTableViewCell.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDetailModel.h"

@interface ProjectDetailTableViewCell : UITableViewCell


@property (nonatomic,strong) ProjectDetailModel *projectModel;
@property (nonatomic,assign) BOOL ishowHtml;
//我们最后得到cell的高度的方法
-(CGFloat)rowHeightWithCellModel:(ProjectDetailModel *)model;


@end
