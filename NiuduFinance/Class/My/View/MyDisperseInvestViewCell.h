//
//  MyDisperseInvestViewCell.h
//  NiuduFinance
//
//  Created by 123 on 17/1/20.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,MyDisperseInvestStat)
{
    MyDisperseInvestStatRufunding,
    MyDisperseInvestStatBidding,
    MyDisperseInvestStatHistory
};
@class MyDisperseInvestViewCell;
@protocol MyDisperseInvestViewCellDelegate <NSObject>

@end

@interface MyDisperseInvestViewCell : UITableViewCell
//协议
@property (weak, nonatomic) IBOutlet UIButton *xieYiBtn;
@property (weak, nonatomic) id<MyDisperseInvestViewCellDelegate> delegate;
-(void)creditorState:(MyDisperseInvestStat)state model:(NSDictionary *)modeIDic;
@end
