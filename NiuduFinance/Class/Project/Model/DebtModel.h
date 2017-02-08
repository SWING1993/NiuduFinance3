//
//  DebtModel.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/14.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebtModel : NSObject

/// 债权Id
@property (nonatomic,assign)int debtDealId;

/// 债权项目Id
@property (nonatomic,assign)int projectId;

/// 标题
@property (nonatomic,strong)NSString *title;

/// 应收本金
@property (nonatomic,assign)CGFloat receivablePrincipal;

/// 应收利息
@property (nonatomic,assign)CGFloat receivableInterest;

/// 利率
@property (nonatomic,strong)NSString *rate;

/// icon
@property (nonatomic,strong)NSString *iconUrl;

/// 出售价
@property (nonatomic,strong)NSString *priceForSale;

///
@property (nonatomic,assign)int priceForSaleTypeId;

//剩余份数

@property (nonatomic,assign)int sellerUserId;

@property (nonatomic,assign)int borrowerId;

@property (nonatomic,assign)int surplusNum;

@property (nonatomic,assign)int statusId;
@end
