//
//  ValidateUtil.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/15.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "ValidateUtil.h"

@implementation ValidateUtil
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        //        if([regextestcm evaluateWithObject:mobileNum] == YES) {
        //            NSLog(@"China Mobile");
        //        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
        //            NSLog(@"China Telecom");
        //        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
        //            NSLog(@"China Unicom");
        //        } else {
        //            NSLog(@"Unknow");
        //        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSInteger)characterCountOfString:(NSString *)string{
    int characterCount = 0;
    if (string.length == 0)
    {
        return 0;
    }
    for (int i = 0; i<string.length; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (isdigit(c)) {
            characterCount++;//数字
        }
    }
    return characterCount;
}

+ (NSInteger)characterCharCountOfString:(NSString *)string{
    int characterCount = 0;
    if (string.length == 0)
    {
        return 0;
    }
    for (int i = 0; i<string.length; i++)
    {
        unichar c = [string characterAtIndex:i];
        if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
        {
            characterCount++;//字母
        }
    }
    return characterCount;
}

//+ (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size originString:(NSString*)originString{
//    
//    CGSize retSize = CGSizeZero;
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
//        
//        CGRect rect =  [originString boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
//        retSize.width = ceil(rect.size.width);
//        retSize.height = ceil(rect.size.height);
//        
//    }else{
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated"
//        retSize = [originString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//#pragma clang diagnostic pop
//    }
//    return retSize;
//}

//+ (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size originString:(NSString*)originString;
@end
