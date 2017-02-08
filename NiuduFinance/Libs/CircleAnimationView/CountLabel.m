//
//  CountLabel.m
//  CircleAnimation
//
//  Created by fujin on 15/10/20.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "CountLabel.h"
//#define RGBA(r,g,b,a)      [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface CountLabel ()
{
    NSTimer *timer;
}
@end
@implementation CountLabel
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.text = [NSString stringWithFormat:@"%@%s",@"0","%"];
        self.font = [UIFont systemFontOfSize:11];
        self.textColor = [UIColor colorWithHexString:@"#F5635D"];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)updateLabel:(CGFloat)percent withAnimationTime:(CGFloat)animationTime{

    CGFloat startPercent = 0;
    CGFloat endPercent = percent;
    
    CGFloat intever = animationTime/fabs(endPercent - startPercent);
    
    timer = [NSTimer scheduledTimerWithTimeInterval:intever target:self selector:@selector(IncrementAction:) userInfo:[NSNumber numberWithFloat:percent] repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

-(void)IncrementAction:(NSTimer *)time{
//    CGFloat change = [self.text floatValue];
    
//    if(change < [time.userInfo integerValue]){
//        change ++;
//    }
//    else if(change > [time.userInfo integerValue]){
//        change --;
//    }else{
//        change = change;
//    }
    
    self.text = [NSString stringWithFormat:@"%@%s",time.userInfo,"%"];
    if ([self.text floatValue] == [time.userInfo floatValue]) {
        [time invalidate];
    }else{
        [time fire];
    }
}
-(void)clear{
    self.text = @"";
}

- (void)noClear{
    self.text = @"0%";
}
@end
