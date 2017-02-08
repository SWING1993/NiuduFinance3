//
//  DepositBankViewController.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BaseViewController.h"
@protocol ChangeDelegate <NSObject>

- (void)changeTitle:(NSString *)changeStr;

@end
@interface DepositBankViewController : BaseViewController

@property (nonatomic,strong)NSArray *depositArr;

@property (nonatomic,weak)id<ChangeDelegate>delegate;
@end
