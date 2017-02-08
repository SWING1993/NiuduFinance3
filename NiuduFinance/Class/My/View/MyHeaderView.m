//
//  MyHeaderView.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/3.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyHeaderView.h"

@implementation MyHeaderView


- (void)setIsOpenAccount:(BOOL)isOpenAccount
{
    _isOpenAccount = isOpenAccount;
    
    [self setHideBottomView];
    
}

- (void)setHideBottomView{

    _bottomView.layer.borderWidth = 1;
    _bottomView.layer.borderColor = [[UIColor colorWithHexString:@"#019BFF" ]CGColor];
    
//    _tiChongView.layer.borderWidth = 1;
//    _tiChongView.layer.borderColor = [[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1]CGColor];
    
    if (!_isOpenAccount) {
        self.bottomView.hidden = YES;
    }else{
        self.bottomView.hidden = NO;
    }
}



@end
