//
//  HongBaoCell.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/13.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HongbaoState)
{
    HongbaoStateCanUser,
    HongbaoStateUsed,
    HongbaoStateAbandon
};
@protocol HaoBaoCellDelegate <NSObject>



@end

@interface HongBaoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (assign, nonatomic,readonly)HongbaoState hongbaoState;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *validDateLabel;
//积分
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


//@property(nonatomic,weak)id <HaoBaoCellDelegate> delegate;
- (void)creditorState:(HongbaoState)state model:(NSDictionary *)modelDic;
@end
