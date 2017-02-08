//
//  ProjectDetailModel.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectDetailModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,copy) NSString *content; //内容的label
//单元格的高度
@property (nonatomic,assign) CGFloat cellHeight;
@end
