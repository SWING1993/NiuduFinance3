//
//  InvestRecodeViewController.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BaseViewController.h"

@interface InvestRecodeViewController : BaseViewController

@property (nonatomic,assign)int projectId;

@property (nonatomic,strong)NSString *urlStr;

@property (nonatomic,assign)int productId;

@property (nonatomic,assign)BOOL isTransfer;
//
@property (nonatomic,assign) NSArray *debtArr;
@end
