//
//  ProgressView.h
//  Test_Pro
//
//  Created by liuyong on 15/9/9.
//
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView



//中心颜色

@property (strong, nonatomic)UIColor *centerColor;

//圆环背景色

@property (strong, nonatomic)UIColor *arcBackColor;

//圆环色

@property (strong, nonatomic)UIColor *arcFinishColor;

@property (strong, nonatomic)UIColor *arcUnfinishColor;



//百分比数值（0-1）

@property (assign, nonatomic)float percent;


//圆环宽度

@property (assign, nonatomic)float width;

@end
