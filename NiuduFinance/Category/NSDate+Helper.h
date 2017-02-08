//
//  NSDate+Helper.h
//  SuningEBuy
//
//  Created by 刘坤 on 12-8-30.
//  Copyright (c) 2012年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

/*tools*/

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)formatString;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString;

//add by cuizl  计算某一天到达现在的天数
+(NSInteger) daysFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;

+(NSDateComponents *)timeMethodGo:(NSString *)dataStr;

+(NSString *)getCurMonthFirstDay:(NSDate *)kdate;

+(NSString *)getCurMonthLastDay:(NSDate *)kdate;

+ (NSDate *)stringToDate:(NSString *)dateStr;

@end
