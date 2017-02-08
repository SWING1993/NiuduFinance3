//
//  User.h
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/27.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
//是否开通第三方账号
@property (nonatomic,strong) NSString *isOpenAccount;
/// 手机号
@property (copy, nonatomic) NSString *mobile;

/// 用户名
@property (copy, nonatomic) NSString *userName;

/// 密码
@property (nonatomic,strong)NSString *password;

/// 用户编号
@property (assign, nonatomic) NSInteger userId;

/// 用户头像
@property (nonatomic,strong) NSString *avatar;

/// 真实姓名
@property (nonatomic,strong)NSString *realName;

/// 手势密码
@property (nonatomic,strong)NSString *gesture;

///  IdNumber
@property (nonatomic,strong)NSString *idNumber;

///   身份证是否验证
@property (nonatomic,assign)int idValidate;

/// 性别
@property (nonatomic,strong)NSString *gender;

/// 生日
@property (nonatomic,strong)NSString *birthDay;

/// 电话是否验证
@property (nonatomic,assign)int mobileValidate;

/// 是否设置手势密码
@property (nonatomic,assign)BOOL gestureStatus;

/// 是否设置交易密码
@property (nonatomic,assign)BOOL repaymentPwdStatus;

/// 交易密码
@property (nonatomic,strong)NSString *repaymentPwd;

/// 银行卡数量
@property (nonatomic,assign)int bankCardCount;

/// 角色
@property (nonatomic,assign)int role;

//邮箱
@property (nonatomic,strong) NSString *email;

//地址认证
@property (nonatomic,strong) NSString *userAddress;

//身份证
@property (nonatomic,strong) NSString * bankInfo;


+ (User *)shareUser;

//删除用户数据
- (void)removeUser;

//  当变更数据后，保存到文件
- (void)saveUser;

// 从文件中读取 这个方法是app刚进来的时候去调用
+ (instancetype)userFromFile;

//  记录用户登录
- (void)saveLogin;

//  记录用户退出
- (void)saveExit;
@end
