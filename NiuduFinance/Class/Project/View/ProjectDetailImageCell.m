//
//  ProjectDetailImageCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/10/13.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectDetailImageCell.h"
#import "ShowBigImage.h"
#import "Masonry.h"
#import "NetWorkingUtil.h"

@interface ProjectDetailImageCell()

@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation ProjectDetailImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setImgArray:(NSArray *)imgArray
{
    _imgArray = imgArray;

    [self addImageView];
}

- (void)addImageView{
    
    for (int i = 1; i<= _imgArray.count; i++) {
        _imgView = [UIImageView new];
        
        
        
        [NetWorkingUtil setImage:_imgView url:[_imgArray[i - 1] objectForKey:@"url"] defaultIconName:nil];
        _imgView.tag = i;
        [self.contentView addSubview:_imgView];
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
        [_imgView addGestureRecognizer:tapGestureRecognizer1];
        //让UIImageView和它的父类开启用户交互属性
        [_imgView setUserInteractionEnabled:YES];
        //添加图片约束
        __weak typeof(self) weakSelf = self;
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            
            if (i==1 || i==2) {
                make.top.equalTo(weakSelf.contentView).offset(0);
                
            }
            else{
                
                if (i%2==0) {
                    NSLog(@"test=%d",(i/2)-1);
                    make.top.equalTo(weakSelf.contentView).offset(180*((i/2)-1)+(5*(i/2)-1));
                }else{
                    make.top.equalTo(weakSelf.contentView).offset(180*(i/2)+5*(i/2));
                }
            }
            if (i%2==0) {
                
                make.left.equalTo(weakSelf.mas_left).offset((SCREEN_WIDTH-10)/2+10);
                make.right.equalTo(weakSelf.mas_right).offset(-5);
            }else{
                
                make.left.equalTo(weakSelf.contentView.mas_left).offset(5);
                
            }
            
            make.height.mas_equalTo(180);
            make.width.mas_equalTo((SCREEN_WIDTH-20)/2);
            
            
        }];
    }
    
    //添加图片约束
    [self addImgConstraints];
}



-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    
    @try {
        UIImageView *clickedImageView = (UIImageView *)tap.view;
        [ShowBigImage scanBigImageWithImageView:clickedImageView];
    } @catch (NSException *exception) {
//        [MBProgressHUD showMessag:@"图片加载中..." toView:self.view];
    } @finally {
        
    }
    
}

-(void)addImgConstraints{

    for (int i=0; i<4; i++) {
        
    
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
}

@end
