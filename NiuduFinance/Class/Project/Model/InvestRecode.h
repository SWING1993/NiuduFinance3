//
//  InvestRecode.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/14.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestRecode : NSObject

///  用户名
@property (nonatomic,strong)NSString *userName;

///  金额
@property (nonatomic,assign)CGFloat successfulAmount;

///  日期
@property (nonatomic,strong)NSString *bidDate;
@end
