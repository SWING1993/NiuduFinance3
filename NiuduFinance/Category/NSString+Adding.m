//
//  NSString+Adding.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/20.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "NSString+Adding.h"
#import <UIKit/UIKit.h>
#import "MacroDefine.h"

@implementation NSString (Adding)
- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size{

    CGSize retSize = CGSizeZero;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {

        CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
        retSize.width = ceil(rect.size.width);
        retSize.height = ceil(rect.size.height);

    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        retSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    return retSize;
}


- (NSString *)strmethodComma
{
    NSString *string = self;
    if (string.length <= 3) {
        return string;
    }

    NSString *sign = nil;
    if ([string hasPrefix:@"-"]||[string hasPrefix:@"+"]) {
        sign = [string substringToIndex:1];
        string = [string substringFromIndex:1];
    }
    
    NSArray *signs = [string componentsSeparatedByString:@"."];
    string = signs[0];
    //    NSLog(@"====%lu",(unsigned long)string.length);
    if (string.length <= 3 && signs.count == 2) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@".%@",signs[1]]];
        return string;
    }
    
    NSString *pointLast = [string substringFromIndex:[string length]-3];
    NSString *pointFront = [string substringToIndex:[string length]-3];
    
    NSInteger commaNum = ([pointFront length]-1)/3;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < commaNum+1; i++) {
        NSInteger index = [pointFront length] - (i+1)*3;
        NSInteger leng = 3;
        if(index < 0)
        {
            leng = 3+index;
            index = 0;
            
        }
        NSRange range = {index,leng};
        NSString *stq = [pointFront substringWithRange:range];
        [arr addObject:stq];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (NSInteger i = [arr count]-1; i>=0; i--) {
        
        [arr2 addObject:arr[i]];
    }
    [arr2 addObject:pointLast];
    NSString *commaString = [arr2 componentsJoinedByString:@","];
    if (sign) {
        commaString = [sign stringByAppendingString:commaString];
    }
    if (signs.count == 2) {
        commaString = [commaString stringByAppendingString:[NSString stringWithFormat:@".%@",signs[1]]];
    }
    return commaString;
}

- (NSString *)wanStrmethodComma
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    CGFloat value = [str floatValue];
    CGFloat wanValue = value/10000;
    str = [NSString stringWithFormat:@"%f",wanValue];
    str = [str strmethodComma];
    NSRange range = [str rangeOfString:@"."];
    
    if (range.location != NSNotFound)
    {
        NSArray *strs = [str componentsSeparatedByString:@"."];
        NSUInteger index = -1;
        if (strs.count>=2)
        {
            str = strs[1];
            if ([str hasSuffix:@"0"])
            {
                
                for (int i = 0;i<str.length ; i++)
                {
                    NSString *subString = [str substringWithRange:NSMakeRange(i, 1)];
                    if ([subString integerValue] != 0)
                    {
                        index = i;
                    }
                }
            }
        }
        
        if (index == -1)
        {
            str = strs[0];
        }
        else
        {
            if (index == str.length - 1)
            {
                str = [NSString stringWithFormat:@"%@.%@",strs[0],str];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@.%@",strs[0],[str substringWithRange:NSMakeRange(0, index + 1)]];
            }
        }
        
        //strs[0] ,
    }
    return str;
}

//  判断输入框汉字/英文的字符多少个
-(int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

//  富文本
- (NSMutableAttributedString *)attributedText:(NSString *)text beginIndex:(NSInteger)index length:(NSInteger)length colorStr:(NSString *)color font:(CGFloat)font
{
    NSMutableAttributedString *borrowStr = [[NSMutableAttributedString alloc]initWithString:text];
    [borrowStr beginEditing];
    [borrowStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:color] range:NSMakeRange(index, length)];
    [borrowStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(index, length)];
    
    return borrowStr;
}

/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     * 虚拟号码: 170
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSString *VR = @"^17(0|6|8)\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
     NSPredicate *regextestvr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VR];
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel]
         || [regextestvr evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
//验证邮箱
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
