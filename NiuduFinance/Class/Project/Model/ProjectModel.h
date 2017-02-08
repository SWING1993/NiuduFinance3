//
//  ProjectModel.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/10.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

/// 产品开始时间
@property (nonatomic,strong)NSString *beginDate;

/// 理财包已购买金额
@property (nonatomic,assign)CGFloat funding;

/// 理财包期限
@property (nonatomic,assign)int loanPeriod;

/// 理财包名称
@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *productNum;

/// 理财包期限类型：1按天计算2按月计算3按年计算
@property (nonatomic,assign)int periodTypeId;

/// 理财包预计金额
@property (nonatomic,assign)CGFloat planAmount;

/// 预计收益率
@property (nonatomic,strong)NSString *planRate;

/// 进度
@property (nonatomic,assign)double progress;

/// 理财包期限/天
@property (nonatomic,assign)int month;

/// 产品状态  /// 状态0 预审 1 进行中 2 审核中(满标) 3 成功 4成功且还清  5 流标  6审核失败  7撤回
@property (nonatomic,assign)int statusId;

/// 剩余可投金额
@property (nonatomic,strong)NSString *overplus;

/// 剩余可投金额ID
@property (nonatomic,assign)int overplusTypeId;

/// 起投金额
@property (nonatomic,assign)CGFloat bidAmount;

@property (nonatomic,strong)NSString *bidAmountTimes;

/// 理财项目Id
@property (nonatomic,assign)int productId;


/// 借款金额
@property (nonatomic,strong)NSString *amount;

/// 关于元/万元
@property (nonatomic,assign)int amountTypeId;

/// 借款产品图标
@property (nonatomic,strong)NSString *iconUrl;

/// 借款期限
@property (nonatomic,assign)int loanDate;

/// 借款利率
@property (nonatomic,strong)NSString *loanRate;

/// 散标项目Id
@property (nonatomic,assign)int projectId;

/// 项目状态
@property (nonatomic,strong)NSString *projectStatus;

/// 项目标题
@property (nonatomic,strong)NSString *title;

/// IsBid
@property (nonatomic,assign)int isBid;


/// homeId
@property (nonatomic,assign)int Id;

///  minAmount
@property (nonatomic,assign)float minAmount;

///  rate率
@property (nonatomic,strong)NSString *rate;

///  type
@property (nonatomic,assign)int type;

///  IsNewLender
@property (nonatomic,assign)int isNewLender;

/// 剩余可投
@property (nonatomic,strong)NSString *surplusAmount;

/// 剩余可投ID
@property (nonatomic,assign)int surplusAmountTypeId;

///  ZAmount
@property (nonatomic,strong)NSString *zAmount;

///  是否可以投资
@property (nonatomic,assign)int isNew;
@end
