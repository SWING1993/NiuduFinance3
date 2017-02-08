//
//  MyCreditorActionViewController.h
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/10.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCreditorActionViewController : BaseViewController
@property (assign, nonatomic) BOOL transferInvest;

@property (nonatomic,strong)NSDictionary *myCreditorDic;
@property (nonatomic,strong) NSString *projectId;
@end
