//
//  ProjectDetailImageTableViewCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectDetailImageTableViewCell.h"
#import "NetWorkingUtil.h"
#import "ShowBigImage.h"
@interface ProjectDetailImageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgTwo;

@property (weak, nonatomic) IBOutlet UIImageView *imgThree;
@property (weak, nonatomic) IBOutlet UIImageView *imgFour;
@end

@implementation ProjectDetailImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIconStringArr:(NSArray *)iconStringArr
{
    _iconStringArr = iconStringArr;
    //为UIImageView1添加点击事件
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [_imgOne addGestureRecognizer:tapGestureRecognizer1];
    //让UIImageView和它的父类开启用户交互属性
    [_imgOne setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [_imgTwo addGestureRecognizer:tapGestureRecognizer2];
    //让UIImageView和它的父类开启用户交互属性
    [_imgTwo setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    
    [_imgThree addGestureRecognizer:tapGestureRecognizer3];
    //让UIImageView和它的父类开启用户交互属性
    [_imgThree setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [_imgFour addGestureRecognizer:tapGestureRecognizer4];
    //让UIImageView和它的父类开启用户交互属性
    [_imgFour setUserInteractionEnabled:YES];
    _imgOne.image = [UIImage imageNamed:@"welcome42"];
    _imgTwo.image = [UIImage imageNamed:@"welcome42"];
    _imgThree.image = [UIImage imageNamed:@"welcome42"];
    _imgFour.image = [UIImage imageNamed:@"welcome42"];
//    [NetWorkingUtil setImage:_imgOne url:iconStringArr[0] defaultIconName:@"my_defaultIcon"];
//    [NetWorkingUtil setImage:_imgTwo url:iconStringArr[1] defaultIconName:@"my_defaultIcon"];
//    [NetWorkingUtil setImage:_imgThree url:iconStringArr[2] defaultIconName:@"my_defaultIcon"];
//    [NetWorkingUtil setImage:_imgFour url:iconStringArr[3] defaultIconName:@"my_defaultIcon"];
}

-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [ShowBigImage scanBigImageWithImageView:clickedImageView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
