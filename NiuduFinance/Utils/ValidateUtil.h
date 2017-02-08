//
//  ValidateUtil.h
//  PublicFundraising
//
//  Created by liuyong on 15/10/15.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateUtil : NSObject
//检验手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//判断文本框输入的是否全是数字
+ (NSInteger)characterCountOfString:(NSString *)string;
//判断文本框输入的是否全是字母
+ (NSInteger)characterCharCountOfString:(NSString *)string;
@end
