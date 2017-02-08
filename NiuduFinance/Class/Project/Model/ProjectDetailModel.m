//
//  ProjectDetailModel.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectDetailModel.h"
#import "ProjectDetailTableViewCell.h"
#define ProjectDetailCellID @"ProjectDetailTableViewCell"
@implementation ProjectDetailModel

//惰性初始化是这样写的
-(CGFloat)cellHeight
{
    //只在初始化的时候调用一次就Ok
    if(!_cellHeight){
        ProjectDetailTableViewCell *cell=[[ProjectDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProjectDetailCellID];
//        NSLog(@"我要计算高度");
        // 调用cell的方法计算出高度
        _cellHeight=[cell rowHeightWithCellModel:self];
        
    }
    return _cellHeight;
}
@end
