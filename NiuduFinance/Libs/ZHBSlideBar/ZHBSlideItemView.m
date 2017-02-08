//
//  ZHBSlideItemView.m
//  ZHBSlideBarDemo
//
//  Created by 庄彪 on 15/8/16.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBSlideItemView.h"

#define TITLE_NORMAL_COLOR [UIColor whiteColor]
#define TITLE_SELECTED_COLOR [UIColor blueColor]
#define TITLE_NORMAL_FONT [UIFont systemFontOfSize:14]
#define TITLE_SELECTED_FONT [UIFont boldSystemFontOfSize:16]

#define TITLE_NORMALS_FONT [UIFont systemFontOfSize:15]
#define TITLE_SELECTEDS_FONT [UIFont boldSystemFontOfSize:18]

#define TITLE_NORMALP_FONT [UIFont systemFontOfSize:16]
#define TITLE_SELECTEDP_FONT [UIFont boldSystemFontOfSize:19]

@interface ZHBSlideItemView ()

/*! @brief  标题 */
@property (nonatomic, strong) UILabel *titleLbl;

@end
//设置label的间距
static CGFloat const kMarginX = 10.f;

static NSString * const kSelectedKeyPath = @"selected";
static NSString * const kTitleKeyPath = @"title";
static NSString * const kColorKeyPath = @"normalColor";
static NSString * const kFontKeyPath = @"normalFont";

@implementation ZHBSlideItemView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //设置默认图片
        self.normalaImage = [UIImage imageNamed:@"xinshoutwo.png"];
        NSTextAttachment * textAttach = [[NSTextAttachment alloc]init];
        textAttach.image = _normalaImage;
        NSAttributedString * strA = [NSAttributedString attributedStringWithAttachment:textAttach];
        self.titleLbl.attributedText = strA;
        
        self.normalaImage = [UIImage imageNamed:@"xinshouone.png"];
        NSTextAttachment * textAttac = [[NSTextAttachment alloc]init];
        textAttach.image = _normalaImage;
        NSAttributedString * stA = [NSAttributedString attributedStringWithAttachment:textAttac];
        self.titleLbl.attributedText = stA;
        
        
        
        
        //选中图片
        self.selectedsImage = [UIImage imageNamed:@"xinshoutwo"];
        
        //设置默字体颜色
        self.normalsColor   = TITLE_NORMAL_COLOR;
        //默认字体大小
        self.normalFont    = TITLE_NORMAL_FONT;
        //选中字体的颜色
        self.selectedsColor = TITLE_SELECTED_COLOR;
        //选中字体的大小
        self.selectedFont  = TITLE_SELECTED_FONT;
        if (SCREEN_WIDTH == 375) {
            
            
            self.normalFont = TITLE_NORMALS_FONT;
            self.selectedFont  = TITLE_SELECTEDS_FONT;
        }
        if (SCREEN_WIDTH == 414) {
            self.normalFont = TITLE_NORMALP_FONT;
            self.selectedFont  = TITLE_SELECTEDP_FONT;
        }
        [self addSubview:self.titleLbl];
        [self addObserver:self forKeyPath:kSelectedKeyPath options:0 context:nil];
        [self addObserver:self forKeyPath:kTitleKeyPath options:0 context:nil];
        [self addObserver:self forKeyPath:kColorKeyPath options:0 context:nil];
        [self addObserver:self forKeyPath:kFontKeyPath options:0 context:nil];
    }
    return self;
}
//布局
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLbl.frame = self.bounds;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kSelectedKeyPath];
    [self removeObserver:self forKeyPath:kTitleKeyPath];
    [self removeObserver:self forKeyPath:kColorKeyPath];
    [self removeObserver:self forKeyPath:kFontKeyPath];
}



#pragma mark - Private Methods
//改变view状态
- (void)changeViewStatus {
    if (self.selected) {
        
        self.titleLbl.font      = self.selectedFont;
        self.titleLbl.textColor = self.selectedsColor;
    } else {
        self.titleLbl.font      = self.normalFont;
        self.titleLbl.textColor = self.normalsColor;
    }
    self.titleLbl.text = self.title;
    //设置需要的布局
    [self setNeedsLayout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self changeViewStatus];
}
//设置自己的界限
- (void)setSelfBounds {
    //设置字体的大小
    NSDictionary *attributes = @{NSFontAttributeName : self.titleLbl.font};
    //boundingRectWithSize 返回文本绘制所占据的矩形空间   
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width  = ceil(size.width);
    size.height = ceil(size.height);
    self.bounds = CGRectMake(0, 0, size.width + 2 * kMarginX, CGRectGetHeight(self.frame));
    
    
}

#pragma mark - Getters

- (UILabel *)titleLbl {
    if (nil == _titleLbl) {
        _titleLbl               = [[UILabel alloc] init];
        _titleLbl.font          = self.normalFont;
        _titleLbl.textColor     = self.normalsColor;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

//- (UIImage *)imagee{
//    
//}

#pragma mark - Setters
- (void)setTitle:(NSString *)title {
//    _title = [title copy];
    [self setSelfBounds];
}

@end
