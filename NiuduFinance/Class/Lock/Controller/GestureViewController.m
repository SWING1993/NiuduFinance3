
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "PSBarButtonItem.h"
#import "NetWorkingUtil.h"
#import "User.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "CheckLoginViewController.h"

@interface GestureViewController ()<CircleViewDelegate>
{
    id _gestureDelegate;
}
/**
 *  跳过按钮
 */
@property (nonatomic, strong) UIButton *skipBtn;

/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

/**
 *  用户模型
 */
//@property (nonatomic, strong) User *user;

/**
 *  手势次数
 */
@property (nonatomic, assign) NSInteger countNum;

@end

@implementation GestureViewController
@synthesize delegate;

- (void)setStateType:(NSString *)stateType
{
    _stateType = stateType;
}

- (void)setRegisterDic:(NSDictionary *)registerDic
{
    _registerDic = registerDic;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    if (self.type == GestureViewControllerTypeSetting) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    if (self.type == GestureViewControllerTypeLock) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置手势背景色
    //    [self.view setBackgroundColor:CircleViewBackgroundColor];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lock_background"]]];
    
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
    
    // 初始化手势次数
    _countNum = 0;
    
    
    //去掉左滑手势
    
}

#pragma mark - 创建UIBarButtonItem
- (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {100, 20}};
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.tag = tag;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setHidden:YES];
    self.resetBtn = button;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        case GestureViewControllerTypeLock:
            [self setupSubViewsLockVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    // 创建导航栏右边按钮
    //    self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"重设" target:self action:@selector(didClickBtn:) tag:buttonTagReset];
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    self.title = @"设置手势密码";
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
    
    //    if (![_stateType isEqual:@"重置密码"] && ![_stateType isEqual:@"验证密码"]) {
    //        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _skipBtn.frame = CGRectMake(0, 0, 60, 30);
    //        _skipBtn.center = CGPointMake(kScreenW/2, kScreenH-70);
    //        _skipBtn.layer.borderWidth = 1.0f;
    //        [_skipBtn.layer setBorderColor:AgainTextColorNormalState.CGColor];
    //        [_skipBtn setTitleColor:AgainTextColorNormalState forState:UIControlStateNormal];
    //        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    //        [_skipBtn setTitle:@"跳 过" forState:UIControlStateNormal];
    //        [_skipBtn addTarget:self action:@selector(skipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //        _skipBtn.tag = buttonTagReset;
    //        [self.view addSubview:_skipBtn];
    //    }else
    //    if ([_stateType isEqual:@"点此去重新绘制"]){
    //        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        backBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 40, 40);
    //        [backBtn setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    //        backBtn.contentMode = UIViewContentModeCenter;
    //        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //        [self.view addSubview:backBtn];
    //    }
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)skipBtnClick:(UIButton *)sender
{
    NSLog(@"点击了跳过按钮");
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestObj4MethodName:@"passport/register" parameters:_registerDic result:^(id obj, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            //            _user = (User *)obj;
            //            _user.password = [_registerDic objectForKey:@"PassWord"];
            //            [_user saveUser];
            //            [_user saveLogin];
            [MBProgressHUD showSuccess:msg toView:self.view];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    } convertClassName:@"User" key:nil];
}
- (void)delayMethod{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:nil];
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    
    [util requestObj4MethodName:@"passport/login" parameters:@{@"UserName":[_registerDic objectForKey:@"UserName"],@"PassWord":[_registerDic objectForKey:@"PassWord"]} result:^(id obj, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            //            _user = (User *)obj;
            //            _user.password = [_registerDic objectForKey:@"PassWord"];
            //            [_user saveUser];
            //            [_user saveLogin];
            //            [AppDelegate loginMain];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    } convertClassName:@"User" key:nil];
}
#pragma mark - 锁屏手势密码界面
- (void)setupSubViewsLockVc
{
    User *user = [User userFromFile];
    [self.lockView setType:CircleViewTypeLock];
    
    [self.msgLabel showNormalMsg:gestureTextLoginGesture];
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 41, 41);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/6);
    imageView.layer.cornerRadius = 20.5;
    imageView.layer.masksToBounds = YES;
    [NetWorkingUtil setImage:imageView url:user.avatar defaultIconName:@"my_defaultIcon"];
    [self.view addSubview:imageView];
    
    // 用户名
    UILabel *userNmaeLab = [[UILabel alloc]init];
    userNmaeLab.frame = CGRectMake(0, 0, 100, 20);
    userNmaeLab.center = CGPointMake(kScreenW/2, kScreenH/4.5);
    userNmaeLab.textAlignment = NSTextAlignmentCenter;
    userNmaeLab.font = [UIFont systemFontOfSize:10.0f];
    userNmaeLab.textColor = [UIColor whiteColor];
    userNmaeLab.text = [NSString stringWithFormat:@"%@",[user.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    [self.view addSubview:userNmaeLab];
    
    // 忘记手势
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW/2, 20) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
    
    // 切换账户
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW/2, 20) title:@"使用其他账户登录" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    User *user = [User userFromFile];
    [self.lockView setType:CircleViewTypeLogin];
    
    [self.msgLabel showNormalMsg:gestureTextLoginGesture];
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 41, 41);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/6);
    imageView.layer.cornerRadius = 20.5;
    imageView.layer.masksToBounds = YES;
    [NetWorkingUtil setImage:imageView url:user.avatar defaultIconName:@"my_defaultIcon"];
    [self.view addSubview:imageView];
    
    // 用户名
    UILabel *userNmaeLab = [[UILabel alloc]init];
    userNmaeLab.frame = CGRectMake(0, 0, 100, 20);
    userNmaeLab.center = CGPointMake(kScreenW/2, kScreenH/4.5);
    userNmaeLab.textAlignment = NSTextAlignmentCenter;
    userNmaeLab.font = [UIFont systemFontOfSize:10.0f];
    userNmaeLab.textColor = [UIColor whiteColor];
    userNmaeLab.text = [NSString stringWithFormat:@"%@",[user.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    [self.view addSubview:userNmaeLab];
    
    // 忘记手势
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW/2, 30) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
    
    // 切换账户
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW/2, 30) title:@"使用其他账户登录" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagReset:
        {
            NSLog(@"点击了重设按钮");
            // 1.隐藏按钮
            [self.resetBtn setHidden:YES];
            [sender setHidden:YES];
            [_skipBtn setHidden:NO];
            
            // 2.infoView取消选中
            [self infoViewDeselectedSubviews];
            
            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];
            
            // 4.清除之前存储的密码
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
            
        }
            break;
        case buttonTagManager:
        {
            NSLog(@"点击了忘记手势");
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            CheckLoginViewController*modifyVC = [[CheckLoginViewController alloc] init];
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:modifyVC];
            baseNav.navigationBar.barTintColor = Nav019BFF;
            baseNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
            [app.window.rootViewController presentViewController:baseNav animated:YES completion:^{
            }];
            
        }
            break;
        case buttonTagForget:
        {
            NSLog(@"点击了切换账户");
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            LoginViewController*loginVC = [[LoginViewController alloc] init];
            loginVC.typeStr = @"forget";
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            baseNav.navigationBar.barTintColor = Nav019BFF;
            baseNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
            [app.window.rootViewController presentViewController:baseNav animated:YES completion:^{
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
    
    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showNormalMsg:gestureTextDrawAgain];
    //隐藏跳过按钮
    [_skipBtn setHidden:YES];
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        //        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        //        [PCCircleViewConst saveGesture:[IOSmd5 md5:gesture] Key:gestureFinalSaveKey];
        //        [self.navigationController popToRootViewControllerAnimated:NO];
        if (delegate&&[delegate respondsToSelector:@selector(createLockSuccess:)]) {
            [delegate createLockSuccess:gesture];
        }
        //        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
        
    } else {
        NSLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
        
        UIButton *againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        againBtn.frame = CGRectMake(0, 0, 120, 30);
        againBtn.center = CGPointMake(kScreenW/2, kScreenH-70);
        
        againBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [againBtn setTitle:@"点此去重新绘制" forState:UIControlStateNormal];
        [againBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        againBtn.tag = buttonTagReset;
        [self.view addSubview:againBtn];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify  or Lock
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            NSLog(@"登陆成功！");
            [AppDelegate loginMain];
        } else {
            NSLog(@"密码错误！");
            
            _countNum ++;
            if (_countNum == 4) {
                User *user = [User userFromFile];
                [user saveExit];
                [user removeUser];
                [MBProgressHUD showError:@"超过输入次数，已注销当前用户" toView:self.view];
                [self performSelector:@selector(delayMethodTime) withObject:nil afterDelay:0.5f];
                
                return;
            }
            
            [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"输入有误，还可以输入%ld次",4-_countNum]];
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }else if (type == CircleViewTypeLock) {
        
        if (equal) {
            NSLog(@"登陆成功！");
            //            [AppDelegate loginMain];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"密码错误！");
            
            _countNum ++;
            if (_countNum == 4) {
                User *user = [User userFromFile];
                [user saveExit];
                [user removeUser];
                [MBProgressHUD showError:@"超过输入次数，已注销当前用户" toView:self.view];
                [self performSelector:@selector(delayMethodTime) withObject:nil afterDelay:0.5f];
                
                return;
            }
            
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    }
}

- (void)delayMethodTime
{
    [AppDelegate loginMain];
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews
{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
