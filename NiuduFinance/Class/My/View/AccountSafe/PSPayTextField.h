//
//  PSPayTextField.h
//  支付密码
//
//  Created by zhoupushan on 16/3/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSPayTextField;
@protocol  PSPayTextFieldDelegate<NSObject>
- (void)ps_textField:(PSPayTextField *)textField textDidChange:(NSString *)text;
@end
@interface PSPayTextField : UIView
@property (strong, nonatomic,readonly) NSString *text;
@property (weak, nonatomic) id<PSPayTextFieldDelegate> delegate;

+ (instancetype)textFieldFromXib;

- (BOOL)ps_resignFirstResponder;
@end
