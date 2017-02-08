
#import <UIKit/UIKit.h>

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin,
    GestureViewControllerTypeLock
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@protocol GestureViewControllerDelegate <NSObject>

- (void)createLockSuccess:(NSString *)lockPwd;

@end

@interface GestureViewController : UIViewController
{
    NSString *_stateType;
    NSDictionary *_registerDic;
}

@property (nonatomic,strong)NSString *stateType;
@property (nonatomic,strong)NSDictionary *registerDic;

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;
@property (assign,nonatomic)id<GestureViewControllerDelegate>delegate;

@end
