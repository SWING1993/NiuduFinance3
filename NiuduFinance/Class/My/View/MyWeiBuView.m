//
//  MyWeiBuView.m
//  NiuduFinance
//
//  Created by 123 on 17/1/19.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import "MyWeiBuView.h"

@implementation MyWeiBuView

- (void)setIsOpenAccount:(BOOL)isOpenAccount
{
    _isOpenAccount = isOpenAccount;
    
        [self setHideBottomView];
    
}

- (void)setHideBottomView{
    
    _tailView.layer.borderWidth =1;
    _tailView.layer.borderColor = [[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1]CGColor];
}

@end
