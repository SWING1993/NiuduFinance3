//
//  OptionBankTypeView.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "OptionBankTypeView.h"
@interface OptionBankTypeView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *bankPickerView;
@end
@implementation OptionBankTypeView
- (IBAction)confirmAction {
    [self hide];
    //传值
}

- (IBAction)cancelAction {
    [self hide];
}

- (void)hide
{
    self.hidden = YES;
}
@end
