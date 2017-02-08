//
//  NSDate+Helper.m
//  SuningEBuy
//
//  Created by 刘坤 on 12-8-30.
//  Copyright (c) 2012年 Suning. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//add by cuizl  计算某一天到达现在的天数
+(NSInteger) daysFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    
    NSUInteger unitFlags =NSDayCalendarUnit;
    
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:fromDate toDate:toDate  options:0];
    
//    chineseClendar = nil;
    return [cps day];
}

+(NSDateComponents *)timeMethodGo:(NSString *)dataStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_China"];
    [dateFormatter setLocale: local];
    NSDate* fireDate = [dateFormatter dateFromString:dataStr];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    
    NSDateComponents *timeDay = [calender components:unitFlags fromDate:today toDate:fireDate options:0];
    return timeDay;
}

+(NSString *)getCurMonthFirstDay:(NSDate *)kdate{
    NSDate *now = kdate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit
                                     fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* str = [formatter stringFromDate:firstDay];
    return str;
}

+(NSString *)getCurMonthLastDay:(NSDate *)kdate{
    NSDate *now = kdate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit
                                     fromDate:now];
    NSRange daysRange = [cal rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:now];
    comps.day = daysRange.length;
    NSDate *lastDay = [cal dateFromComponents:comps];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd HH:mm:ss
    NSString* str = [formatter stringFromDate:lastDay];
    return str;
}

+ (NSDate *)stringToDate:(NSString *)dateStr
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:dateStr];
    return inputDate;
}

@end
