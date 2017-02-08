//
//  HttpClient.m
//  NiuduFinance
//
//  Created by Song on 2017/2/8.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "ReflectUtil.h"
#import "IOSmd5.h"
#import "User.h"

static NSString *mainURL = @"http://139.224.54.40:8081/";
static NSString *appKey = @"~!N@D#Z*";
static HttpClient *shared = nil;

@implementation HttpClient

+ (instancetype)shared {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}


/** 网络请求 */
- (void)POST:(NSString *)URLString params:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    manager.requestSerializer.timeoutInterval = 15;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [manager POST:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failed(error);
    }];
}

#pragma mark - private
- (NSDictionary *)parameterDicWithDic:(NSDictionary *)pamar
{
    
    // 对传的参数进行处理
    NSMutableDictionary * dic = pamar?[NSMutableDictionary dictionaryWithDictionary:pamar]:[NSMutableDictionary dictionary];
    //     token
    /*
    if (token)
    {
        [dic setObject:token forKey:@"Token"];
    }
     */
    
    // UserID
    NSInteger userId = [User shareUser].userId;
    if (userId)
    {
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)userId] forKey:@"UserId"];
    }
    [dic setObject:@"2" forKey:@"Platform"];
    //     排序
    NSArray *keys = [self sortKeys:[dic allKeys]];
    // 生成加密参数
    NSMutableString *valueStr = [NSMutableString string];
    for (NSString *key in keys) {
        id obj = [dic objectForKey:key];
        NSString *str;
        // 字符串
        if ([obj isKindOfClass:[NSString class]]) {
            str = (NSString *)obj;
        }
        
        // number
        else if ([obj isKindOfClass:[NSNumber class]]) {
            str = [obj stringValue];
        }
        else {
            str = [obj JSONString];
        }
        [valueStr appendFormat:@"%@|",str];
    }
    
    [valueStr appendString:appKey];
    [dic setObject:[IOSmd5 md5:valueStr] forKey:@"Sign"];
    return dic;
}

- (NSArray *)sortKeys:(NSArray *)keys
{
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2)
            {
                NSComparisonResult result =  [obj1 compare:obj2 options:NSLiteralSearch];
                return result == NSOrderedDescending;
            }];
    return keys;
}


@end
