
#import "PCCircleViewConst.h"

@implementation PCCircleViewConst

+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getGestureWithKey:(NSString *)key
{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)removeGesture:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
