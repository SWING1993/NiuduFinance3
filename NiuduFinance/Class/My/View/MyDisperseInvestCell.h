//
//  MyDisperseInvestCell.h
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/11.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,MyDisperseInvestState)
{
    MyDisperseInvestStateRufunding,
    MyDisperseInvestStateBidding,
    MyDisperseInvestStateHistory
};
@class MyDisperseInvestCell;
@protocol MyDisperseInvestCellDelegate <NSObject>

@end

@interface MyDisperseInvestCell : UITableViewCell
@property (assign, nonatomic,readonly) MyDisperseInvestState myDisperseInvestState;
//借款金额
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;
@property (weak, nonatomic) id<MyDisperseInvestCellDelegate> delegate;
- (void)creditorState:(MyDisperseInvestState)state model:(NSDictionary *)modelDic;
@end
