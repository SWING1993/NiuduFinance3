//
//  RefundPlanViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/11.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RefundPlanViewController.h"
#import <JTCalendar/JTCalendar.h>
#import "NSDate+Helper.h"
#import "NSString+Adding.h"

@interface RefundPlanViewController ()<JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *refundTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundedLabel;

@property (weak, nonatomic) IBOutlet UILabel *unRefundLabel;

@property (weak, nonatomic) IBOutlet UIView *refundDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *interestMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *principleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestMoneyLab;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (strong, nonatomic) NSDate *dateSelected;
@property (nonatomic,strong)NSString *dateSelectedStr;

@property (nonatomic,strong)NSMutableArray *eventsByDateArr;

@property (assign, nonatomic) BOOL haveRefund;
@end

@implementation RefundPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"回款计划";
    [self backBarItem];
    
    _eventsByDateArr = [NSMutableArray array];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    
    _calendarManager.dateHelper.calendar.timeZone = [NSTimeZone systemTimeZone];
    _calendarManager.dateHelper.calendar.locale =  [NSLocale currentLocale];
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _dateSelectedStr = [formatter stringFromDate:[NSDate date]];
    
    [self getBackMoneyData];
    
    [self getBackMoneyFirstDate:[NSDate getCurMonthFirstDay:[NSDate date]] LastDay:[NSDate getCurMonthLastDay:[NSDate date]]];
}


#pragma mark - Setter
- (void)setHaveRefund:(BOOL)haveRefund
{
    _haveRefund = haveRefund;
    if (!_haveRefund)
    {
        _refundDetailView.hidden = YES;
    }
}
//- (void)loadPreviousPageWithAnimation;
//- (void)loadNextPageWithAnimation;
#pragma mark - Actions
- (IBAction)leftScrollAction {
    [_calendarContentView loadPreviousPageWithAnimation];
}

- (IBAction)rightScrollAction {
    [_calendarContentView loadNextPageWithAnimation];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    _refundDetailView.hidden = YES;
    [self getBackMoneyFirstDate:[NSDate getCurMonthFirstDay:calendar.date] LastDay:[NSDate getCurMonthLastDay:calendar.date]];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    _refundDetailView.hidden = YES;
    [self getBackMoneyFirstDate:[NSDate getCurMonthFirstDay:calendar.date] LastDay:[NSDate getCurMonthLastDay:calendar.date]];
}

#pragma mark - JTCalendarDelegate
- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    menuItemView.text = [dateFormatter stringFromDate:date];
}

- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    
    for(UILabel *label in view.dayViews){
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12];
    }
    
    return view;
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont systemFontOfSize:12];
    view.circleRatio = .8;
    view.dotRatio = 1. / .9;
    return view;
}


- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;

    // Hide if from another month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
        
        if (_eventsByDateArr.count > 0) {
            for (int i = 0; i < _eventsByDateArr.count; i ++) {
                if ([_calendarManager.dateHelper date:[NSDate stringToDate:_eventsByDateArr[i]] isTheSameDayThan:dayView.date])
                {
                    dayView.circleView.hidden = NO;
                    dayView.circleView.layer.borderColor = [UIColor colorWithHexString:@"#EE615C"].CGColor;
                    dayView.circleView.layer.borderWidth = 1.0;
                    dayView.circleView.layer.shouldRasterize = YES;
                    dayView.textLabel.textColor = [UIColor blackColor];
                    dayView.circleView.backgroundColor = [UIColor whiteColor];

                }
            }
        }
    }
    
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithHexString:@"#EE615C"];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithHexString:@"#EE615C"];
//                dayView.circleView.layer.borderColor = [UIColor colorWithHexString:@"#EE615C"].CGColor;
//                dayView.circleView.layer.borderWidth = 1.0;
//                dayView.circleView.layer.shouldRasterize = YES;
        dayView.textLabel.textColor = [UIColor whiteColor];
  
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
        
        if (_eventsByDateArr.count > 0) {
            for (int i = 0; i < _eventsByDateArr.count; i ++) {
                if ([_calendarManager.dateHelper date:[NSDate stringToDate:_eventsByDateArr[i]] isTheSameDayThan:dayView.date])
                {
                    dayView.circleView.hidden = NO;
                    dayView.circleView.layer.borderColor = [UIColor colorWithHexString:@"#EE615C"].CGColor;
                    dayView.circleView.layer.borderWidth = 1.0;
                    dayView.circleView.layer.shouldRasterize = YES;
                    dayView.textLabel.textColor = [UIColor blackColor];
                    dayView.circleView.backgroundColor = [UIColor whiteColor];
                    
                }
            }
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _dateSelectedStr = [formatter stringFromDate:_dateSelected];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    [self getBackMoneyData];
}

//  回款详情
- (void)getBackMoneyData
{
    [self.httpUtil requestDic4MethodName:@"account/backmoney" parameters:@{@"BeginDate":_dateSelectedStr,@"EndDate":_dateSelectedStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 ||status == 2) {
            
            if ([[dic objectForKey:@"SumAmount"] floatValue] == 0) {
                _refundDetailView.hidden = YES;
            }else{
                
                _refundDetailView.hidden = NO;
//                _refundTotalLabel.text = [[[NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"SumAmount"] floatValue]] strmethodComma] stringByAppendingString:@"元"];
//                _refundedLabel.text = [@"已回：" stringByAppendingString : [NSString stringWithFormat:@"%.2f元",[[dic objectForKey:@"RepayAmount"] floatValue]]];
                _interestMoneyLab.text = [[[NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"Interest"] floatValue]] strmethodComma] stringByAppendingString:@"元"];
                _principleMoneyLabel.text = [[[NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"Principal"] floatValue]] strmethodComma] stringByAppendingString:@"元"];
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_calendarManager reload];
    }];
}

//  哪天有回款
- (void)getBackMoneyFirstDate:(NSString *)firstDay LastDay:(NSString *)lastDay
{
    [self.httpUtil requestDic4MethodName:@"account/backmoneydate" parameters:@{@"BeginDate":firstDay,@"EndDate":lastDay} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            
            _refundTotalLabel.text = [[[NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"ReceivableAmount"] floatValue]] strmethodComma] stringByAppendingString:@"元"];
            
            _refundedLabel.text = [[NSString stringWithFormat:@"已回：%.2f",[[dic objectForKey:@"RepayAmount"] floatValue]] stringByAppendingString : @"元"];
            NSArray *arr = [dic objectForKey:@"Date"];
            if (arr.count > 0) {
                for (NSInteger i = 0; i < arr.count; i ++) {
                    _eventsByDateArr[i] = [arr[i] objectForKey:@"Date"];
                }
            }
            
        }else{
//            if (dic==nil) {
//
//                [MBProgressHUD showMessag:msg toView:self.view];
//            }else{
//            
//                [MBProgressHUD showError:msg toView:self.view];
//            }
             [MBProgressHUD showError:msg toView:self.view];

        }
        [_calendarManager reload];
    }];
}
@end
