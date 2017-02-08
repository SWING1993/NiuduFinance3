//
//  PSJumpNumLabel.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/3.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "PSJumpNumLabel.h"
@interface PSJumpNumLabel()
@property (strong, nonatomic) CADisplayLink *timer;
@property (assign, nonatomic) CGFloat changeValue;
@end
@implementation PSJumpNumLabel

- (void)setJumpValue:(NSString *)jumpValue
{
    _jumpValue = jumpValue;
    
    //定时 0 ~ jumpValue 总时间
    [_timer invalidate];
    self.text = @"0";
    _changeValue = 0.0;
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeJumpValue:)];
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)changeJumpValue:(CADisplayLink *)timer
{
    // 0.00 ~ value
    _changeValue += [_jumpValue floatValue]/(0.5*60);// 一秒钟会调用60次 0.5秒执行完
    if (_changeValue < [_jumpValue floatValue])
    {
        self.text = [NSString stringWithFormat:@"%.2f",_changeValue];
    }
    else
    {
        self.text = [NSString stringWithFormat:@"%@",_jumpValue];
        [_timer invalidate];
    }
}

- (void)dealloc
{
    [_timer invalidate];
}

@end
