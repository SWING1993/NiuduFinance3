//
//  User.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/27.
//  Copyright © 2015年 Niuduz. All rights reserved.
//
#define KHaveLogin    @"KHaveLogin"
#import "User.h"
#import <MJExtension.h>

@implementation User
static User *instance = nil;
MJCodingImplementation

+ (User *)shareUser
{
    if (!instance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[super allocWithZone:NULL] init];
            
//            [User mj_setupIgnoredCodingPropertyNames:^NSArray *{
//                //里面写 不需要归档的 属性名
//                return @[@"avatar",@"realName",@"token"];
//            }];

        });
    }
    
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareUser];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}

- (void)saveUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userDefaults setObject:data forKey:@"user"];
    [userDefaults synchronize];
}

- (void)removeUser
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user"];
    [userDefaults synchronize];
}

+ (instancetype)userFromFile
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"user"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)saveLogin
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:KHaveLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveExit
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KHaveLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
