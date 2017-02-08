
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "GestureViewController.h"
#import "PSBarButtonItem.h"
#import "NetWorkingUtil.h"
#import "User.h"

@interface GestureVerifyViewController ()<CircleViewDelegate,GestureViewControllerDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

@end

@implementation GestureVerifyViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //修改手势背景色
//        [self.view setBackgroundColor:CircleViewBackgroundColor];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lock_background"]]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PSBarButtonItem *backItem = [PSBarButtonItem itemWithTitle:nil barStyle:PSNavItemStyleBack target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"验证手势解锁";
    
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.center = self.view.center;
    lockView.delegate = self;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功");
            
            if (self.isToSetNewGesture) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeSetting];
                gestureVc.delegate = self;
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    }
}

#pragma mark GestureViewControllerDelegate
- (void)createLockSuccess:(NSString *)lockPwd
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:nil];
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"user/gesture" parameters:@{@"Gesture":lockPwd} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [User userFromFile].gesture = [IOSmd5 md5:lockPwd];
            [PCCircleViewConst saveGesture:[IOSmd5 md5:lockPwd] Key:gestureFinalSaveKey];
            [hud hide:YES];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)delayMethod{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
