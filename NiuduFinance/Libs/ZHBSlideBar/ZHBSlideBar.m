//
//  ZHBSlideBar.m
//  ZHBSlideBarDemo
//
//  Created by 庄彪 on 15/8/16.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBSlideBar.h"
#import "ZHBSlideItemView.h"

#define MARKVIEW_DEFAULT_COLOR [UIColor blueColor]

@interface ZHBSlideBar ()

/*! @brief  滑动控件 */
@property (nonatomic, strong) UIScrollView *scrollView;
/*! @brief  当前选中的item */
@property (nonatomic, weak, readwrite) ZHBSlideItemView *currentItemView;
/*! @brief  标识view */
@property (nonatomic, strong) UIImageView *markView;

@end

static NSUInteger const kItemViewFlagValue = 100;
//static CGFloat const kDefaultMarkHeight = 2.f;
static NSTimeInterval const kDefaultScrollInterval = 0.25f;
CGFloat const ZHBSlideBarMarkViewNone = 0.f;

@implementation ZHBSlideBar

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.markHeight = kDefaultMarkHeight;
        self.duration = kDefaultScrollInterval;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGFloat subViewX = 0;
    //这里改动 subViewX 又 20 -> 40
    //设置投资页 新手专享/散标投资/债权转让的间距
    if (SCREEN_WIDTH == 320) {
        subViewX = 35;
    }
    if (SCREEN_WIDTH == 375) {
        subViewX = 50;
    }
    if (SCREEN_WIDTH == 414) {
        subViewX = 50;
    }
    CGFloat scrollViewH = CGRectGetHeight(self.scrollView.frame);
    BOOL firstView = YES;
    CGFloat markViewW = 0;
    //设置内部item的frame
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[ZHBSlideItemView class]]) {
            CGFloat subViewW = [self itemViewWidth:subView];
            
            if (firstView) {
                firstView = NO;
                markViewW = subViewW;
            }
            subView.frame = CGRectMake(subViewX, 10, subViewW, scrollViewH);
            //改动
            
//            subViewX = subViewX + subViewW 
            subViewX = subViewX + subViewW + 10;
            if (SCREEN_WIDTH == 375) {
                subViewX = subViewX + 5;
            }
            if (SCREEN_WIDTH == 414) {
                subViewX = subViewX + 14;
            }
        }
    }
    self.scrollView.contentSize = CGSizeMake(subViewX, scrollViewH);
    self.scrollView.scrollEnabled = subViewX > CGRectGetWidth(self.bounds);
    if (subViewX <= CGRectGetWidth(self.bounds)) {
        self.scrollView.scrollEnabled = NO;
        self.scrollPosition = ZHBSlideBarScrollPositionNone;
    }
    if (SCREEN_WIDTH == 320) {
        self.markView.frame = CGRectMake(35, scrollViewH - self.markHeight, markViewW, self.markHeight);
    }else{
        self.markView.frame = CGRectMake(50, scrollViewH - self.markHeight, markViewW, self.markHeight);
    }
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
    [self selectedItemViewAtIndex:0];
}

#pragma mark - Publice Methods
- (ZHBSlideItemView *)itemViewAtIndex:(NSUInteger)index {
    return (ZHBSlideItemView *)[self.scrollView viewWithTag:index + kItemViewFlagValue];
}

- (void)reloadData {
    while (self.scrollView.subviews.count) {
        [[self.scrollView.subviews firstObject] removeFromSuperview];
    }
    NSUInteger itemCount = [self.dataSource numberOfItemViewsInSlideBar:self];
    for (NSUInteger index = 0; index < itemCount; index ++) {
        ZHBSlideItemView *itemView = [self.dataSource slideBar:self viewForItemAtIndex:index];
        //根据index的值赋值tag,为了避免tag冲突,加了一个flag值
        itemView.tag = index + kItemViewFlagValue;
        [itemView addTarget:self action:@selector(didClickItemView:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:itemView];
    }
    if (self.markHeight > 0.f) {
        [self.scrollView addSubview:self.markView];
    }
    [self setNeedsLayout];
}

- (void)selectedItemViewAtIndex:(NSUInteger)index {
    [self didClickItemView:[self itemViewAtIndex:index]];
}

#pragma mark - Private Methods

/*!
 *  @brief  获取itemView应该显示的宽度
 *
 *  @param itemView ZHBSildeItemView
 *
 *  @return 宽度
 */
- (CGFloat)itemViewWidth:(UIView *)itemView {
    if (self.itemWidth > 1.f) {
        return self.itemWidth;
    }
    
    CGFloat subViewW = 0.f;
    if ([self.delegate respondsToSelector:@selector(slideBar:itemWidthAtIndex:)]) {
        subViewW = [self.delegate slideBar:self itemWidthAtIndex:itemView.tag - kItemViewFlagValue];
    }
    if (subViewW < 1.f) {
        subViewW = CGRectGetWidth(itemView.frame);
    }
    return subViewW;
}

/*!
 *  @brief  滑动到index处的item
 *
 *  @param index    索引
 *  @param animated 动画
 */
- (void)scrollToItemViewAtIndex:(NSUInteger)index animated:(BOOL)animated {
    ZHBSlideItemView *itemView = [self itemViewAtIndex:index];
    CGFloat selfW        = CGRectGetWidth(self.frame);
    CGFloat contentW     = self.scrollView.contentSize.width;
    CGFloat itemViewW    = CGRectGetWidth(itemView.frame);
    CGFloat itemViewMidX = CGRectGetMidX(itemView.frame);
    CGFloat itemViewMaxX = CGRectGetMaxX(itemView.frame);
    CGFloat itemViewMinX = CGRectGetMinX(itemView.frame);
    CGFloat marginX = 30;
    CGPoint scrollPoint = CGPointZero;
    switch (self.scrollPosition) {
        case ZHBSlideBarScrollPositionLeft: {//选中的item位于滑动条的左部
            if (contentW - itemViewMaxX > selfW - itemViewW) {
                if (itemViewMinX > marginX) {
                    scrollPoint = CGPointMake(itemViewMinX - marginX, 0);
                } else {
                    scrollPoint = CGPointMake(itemViewMinX, 0);
                }
            } else {
                scrollPoint = CGPointMake(contentW - selfW, 0);
            }
            break;
        }
        case ZHBSlideBarScrollPositionMiddle: {//选中的item位于滑动条的中间
            CGFloat rightW = contentW - itemViewMidX;
            CGFloat midWidth = selfW / 2;
            if (rightW > midWidth && itemViewMidX > selfW / 2) {
                scrollPoint = CGPointMake(- selfW / 2 + itemViewMidX, 0) ;
            }
            if (rightW <= midWidth){
                scrollPoint = CGPointMake(contentW -  selfW, 0);
            }
            break;
        }
        case ZHBSlideBarScrollPositionRight: {//选中的item位于滑动条的右部
            if (itemViewMaxX > selfW) {
                if (contentW - itemViewMaxX > marginX) {
                    scrollPoint = CGPointMake(itemViewMaxX - selfW + marginX, 0);
                } else {
                    scrollPoint = CGPointMake(itemViewMaxX - selfW, 0);
                }
            }
            break;
        }
        case ZHBSlideBarScrollPositionNone: {
            break;
        }
        default:
            break;
    }
    [self.scrollView setContentOffset:scrollPoint animated:animated];
    [UIView animateWithDuration:self.duration animations:^{
        self.markView.frame = CGRectMake(itemViewMinX, CGRectGetMinY(self.markView.frame), itemViewW, CGRectGetHeight(self.markView.frame));
    }];
}

#pragma mark - Event Response
//设置新手专享/散标投资/债权转让item的点击事件
- (void)didClickItemView:(ZHBSlideItemView *)sender {
    NSUInteger index = sender.tag - kItemViewFlagValue;
    if (sender != self.currentItemView) {
        self.currentItemView.selected = NO;
        sender.selected = YES;
        self.currentItemView = sender;
        [self scrollToItemViewAtIndex:index animated:YES];
        if ([self.delegate respondsToSelector:@selector(slideBar:didSelectItemViewAtIndex:)]) {
            [self.delegate slideBar:self didSelectItemViewAtIndex:index];
        }
    }
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

//设置滑动标识颜色
- (UIImageView *)markView {
    if (nil == _markView) {
        _markView = [[UIImageView alloc] init];
        [_markView setBackgroundColor:MARKVIEW_DEFAULT_COLOR];
    }
    return _markView;
}

#pragma mark Setters
- (void)setMarkColor:(UIColor *)markColor {
    _markColor = markColor;
    self.markView.backgroundColor = markColor;
}

@end
