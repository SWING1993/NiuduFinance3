//
//  SettingPayPasswordOneViewController.h
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/8.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,SettingPayStep)
{
    SettingPayStepOld,
    SettingPayStepOne,
    SettingPayStepTwo
};
@interface SettingPayPasswordViewController : BaseViewController
@property (assign, nonatomic) SettingPayStep settingStep;

@property (nonatomic,strong)NSString *codeStr;
@property (nonatomic,strong)NSString *idNumStr;

@property (nonatomic,strong)NSString *psdStrTwo;
@end
