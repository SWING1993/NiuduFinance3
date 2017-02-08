//
//  HttpClient.h
//  NiuduFinance
//
//  Created by Song on 2017/2/8.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id result);
typedef void (^FailedBlock)(NSError *error);

@interface HttpClient : NSObject

+ (instancetype)shared;

- (void)POST:(NSString *)URLString params:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed;

@end
