//
//  SKCalendarView.m
//  HoveringNavigationBar
//
//  Created by sunshuaikun on 17/3/9.
//  Copyright © 2017年 sunshuaikun. All rights reserved.
//
#import "SKCalendarView.h"
#import "CalendarDateUtil.h"
#define kDateBottomLineViewTag     250
@interface SKCalendarView (){
    UIView          *_dateView;               //一周日历背景view
    UIView          *_dateBottomLineView;
    UIView          *_changeDateViewRight;    //日历右边一星期view
    UIView          *_changeDateViewLeft;     //日历左边一星期view
    UIView          *_selectDateView;         //选择日期的标识view
    
    NSMutableArray  *_dateLabelArrayRight;    //右边一星期日期集合
    NSMutableArray  *_dateLabelArray;         //当前一周日期集合
    NSMutableArray  *_dateLabelArrayLeft;     //左边一星期日期集合
    
    int             _changeWeek;              //控制滑动日期
    int             _btnSelectDate;           //btn选择的位置
    
    int             _chooseint;                //选择日期的序列号 0-6
    UILabel         *_selectWeekLabel;        //选择日期的周几的label
    UILabel         *_selectDayLabel;         //选择日期的日期的label
    
    BOOL            _isCalendarViewSwipeing;    //判断日历view是否在滑动
    NSMutableArray              *_currentDateButtonArr;
    NSMutableArray              *_leftDateButtonArr;
    NSMutableArray              *_rightDateButtonArr;
    NSString                    *_todayString;
}

@end

@implementation SKCalendarView

- (id)init
{
    if (self = [super init]) {
        _changeWeek = 0;
        _btnSelectDate = 0;
        _chooseint = (int)[self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
        
        _dateLabelArray = [[NSMutableArray alloc]init];
        _dateLabelArrayLeft = [[NSMutableArray alloc]init];
        _dateLabelArrayRight = [[NSMutableArray alloc]init];
        _currentDateButtonArr = [NSMutableArray array];
        _leftDateButtonArr = [NSMutableArray array];
        _rightDateButtonArr = [NSMutableArray array];
        [self addSubViews];
    }
    return  self;
}
/**
 * 添加一周日历视图
 */
- (void)addSubViews
{
    //当前一周日历背景view
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 20,SCREEN_MAIN_WIDTH, 40)];
    _dateView.backgroundColor = [UIColor clearColor];
    [self createDateViewWithDateView:_dateView dateArray:_dateLabelArray dateButtonArray:_currentDateButtonArr];
    
    _dateBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_MAIN_WIDTH * _chooseint/7.0f+11, kFloatingViewMinimumHeight-5, SCREEN_MAIN_WIDTH/7.0f-22  , 2)];
    _dateBottomLineView.backgroundColor = [UIColor whiteColor];
    
    //左边一周日历图
    _changeDateViewLeft = [[UIView alloc] initWithFrame:CGRectMake(-SCREEN_MAIN_WIDTH, 20, SCREEN_MAIN_WIDTH, 40)];
    _changeDateViewLeft.backgroundColor = [UIColor clearColor];
    [self createDateViewWithDateView:_changeDateViewLeft dateArray:_dateLabelArrayLeft dateButtonArray:_leftDateButtonArr];
    
    //右边一周日历图
    _changeDateViewRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_MAIN_WIDTH, 20, SCREEN_MAIN_WIDTH, 40)];
    _changeDateViewRight.backgroundColor = [UIColor clearColor];
    [self createDateViewWithDateView:_changeDateViewRight dateArray:_dateLabelArrayRight dateButtonArray:_rightDateButtonArr];
    
    [self addSubview:_dateView];
    [self addSubview:_changeDateViewLeft];
    [self addSubview:_changeDateViewRight];
    [self addSubview:_dateBottomLineView];
    
    //给dateview添加左右滑和拖动的手势识别
    [self initDateViewGestureRecognizer];
}

/**
 * 给日历界面加载滑动手势和移动手势
 */
-(void)initDateViewGestureRecognizer
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dateViewSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_dateView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dateViewSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [_dateView addGestureRecognizer:swipeRight];
}

-(void)dateViewSwipeLeft:(id)sender
{
    _isCalendarViewSwipeing = YES;
    
    _changeWeek += 7;
    
    [self setDateViewLabelTitleRight];
    
    CGRect oldFrame = _dateView.frame;
    CGRect changeFrameDate = _changeDateViewRight.frame;
    
    [UIView animateWithDuration:0.75f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         [_dateView setFrame:CGRectMake(-SCREEN_MAIN_WIDTH, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
                         [_changeDateViewRight setFrame:CGRectMake(0, changeFrameDate.origin.y, changeFrameDate.size.width, changeFrameDate.size.height)];
                         [_dateBottomLineView setFrame:CGRectMake(_chooseint *(SCREEN_MAIN_WIDTH/7.0f)+11, _dateBottomLineView.frame.origin.y, _dateBottomLineView.frame.size.width, _dateBottomLineView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [_dateView setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
                         [_changeDateViewRight setFrame:changeFrameDate];
                         [self setDateViewLabelTitle];
                         
                         //结束滑动
                         _isCalendarViewSwipeing = NO;
                     }];
    
}

-(void)dateViewSwipeRight:(id)sender
{
    _isCalendarViewSwipeing = YES;
    
    _changeWeek -= 7;
    
    [self setDateViewLabelTitleLeft];
    
    CGRect oldFrame = _dateView.frame;
    CGRect changeFrameDate = _changeDateViewLeft.frame;
    
    [UIView animateWithDuration:0.75f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         [_dateView setFrame:CGRectMake(SCREEN_MAIN_WIDTH, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
                         [_changeDateViewLeft setFrame:CGRectMake(0, changeFrameDate.origin.y, changeFrameDate.size.width, changeFrameDate.size.height)];
                         [_dateBottomLineView setFrame:CGRectMake(_chooseint *(SCREEN_MAIN_WIDTH/7.0f)+11, _dateBottomLineView.frame.origin.y, _dateBottomLineView.frame.size.width, _dateBottomLineView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [_dateView setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
                         [_changeDateViewLeft setFrame:changeFrameDate];
                         [self setDateViewLabelTitle];
                         
                         _isCalendarViewSwipeing = NO;
                     }];
    
}

/**
 * 创建一周的日历视图
 */
- (void)createDateViewWithDateView:(UIView*)view dateArray:(NSMutableArray*)dateArray dateButtonArray:(NSMutableArray *)dateButtonArray{
    
    for (int i = 0 ; i < 7; i++)
    {
        UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dateButton.frame = CGRectMake(SCREEN_MAIN_WIDTH * i/7.0f, 0, SCREEN_MAIN_WIDTH/7.0f, 45);
        dateButton.backgroundColor = [UIColor clearColor];
        [dateButton addTarget:self action:@selector(dateButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dateButton.frame.size.width, dateButton.frame.size.height*0.5)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = [UIColor colorWithRed:(255.0/255.0f) green:(255.0/255.0f) blue:(255.0/255.0f) alpha:1.0f];
        weekLabel.font = [UIFont boldSystemFontOfSize:10];
        NSString *week = [self getWeekString:i];
        weekLabel.text = week;
        weekLabel.center = CGPointMake(weekLabel.center.x, weekLabel.center.y + 3);
        [dateButton addSubview:weekLabel];
        
        NSMutableArray *tempDaysArr = [self switchDay];
        NSString *dayString = [tempDaysArr objectAtIndex:i];
        if ([dayString intValue] < 10) {
            dayString = [@"0" stringByAppendingString:dayString];
        }
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateButton.frame.size.height*0.5, dateButton.frame.size.width, dateButton.frame.size.height*0.5)];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = [UIColor colorWithRed:(255.0/255.0f) green:(255.0/255.0f) blue:(255.0/255.0f) alpha:1.0f];
        dayLabel.font = [UIFont boldSystemFontOfSize:10];
        dayLabel.text = dayString;
        dayLabel.center = CGPointMake(dayLabel.center.x, dayLabel.center.y - 3);
        [dateButton addSubview:dayLabel];
        
        [dateArray addObject:dayLabel];
        [view addSubview:dateButton];
        [dateButtonArray addObject:dateButton];
    }
}

/**
 * 每天的日历按钮执行方法
 */
- (void)dateButtonMethod:(UIButton*)btn
{
    _chooseint =  btn.center.x/(SCREEN_MAIN_WIDTH/7.0f);
    
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         [_dateBottomLineView setFrame:CGRectMake(_chooseint *(SCREEN_MAIN_WIDTH/7.0f)+11, _dateBottomLineView.frame.origin.y, _dateBottomLineView.frame.size.width, _dateBottomLineView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                     }];
}

/**
 * 获取当前一周的日期，添加到集合里
 */
- (NSMutableArray*)switchDay
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    int head = 0;
    int foot = 0;
    switch ([self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]]) {
        case 1:{
            head = 0;
            foot = 6;
            break;
        }
        case 2:{
            head = 1;
            foot = 5;
            break;
        }
        case 3:{
            head = 2;
            foot = 4;
            break;
        }
        case 4:{
            head = 3;
            foot = 3;
            break;
        }
        case 5:{
            head = 4;
            foot = 2;
            break;
        }
        case 6:{
            head = 5;
            foot = 1;
            break;
        }
        case 7:{
            head = 6;
            foot = 0;
            break;
        }
            
            
        default:
            break;
    }
    
    for (int i = -head; i < 0; i++)
    {
        NSString* str = [NSString stringWithFormat:@"%d", (int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:i]]];
        [array addObject:str];
    }
    
    [array addObject:[NSString stringWithFormat:@"%d", (int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:0]]]];
    
    //sy 添加日期
    int tempNum = 1;
    for (int i = 0; i < foot; i++)
    {
        NSString* str = [NSString stringWithFormat:@"%d", (int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:tempNum]]];
        [array addObject:str];
        tempNum++;
    }
    
    return array;
}

/**
 * 根据NSDate获取年月日和周几
 */
-(int)weekDate:(NSDate*)date
{
    NSCalendar *_calendar=[NSCalendar currentCalendar];
    NSInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *com=[_calendar components:unitFlags fromDate:date];
    NSString *_dayNum=@"";
    int dayInt = 0;
    switch ([com weekday]) {
        case 1:{
            _dayNum=@"日";
            dayInt = 1;
            break;
        }
        case 2:{
            _dayNum=@"一";
            dayInt = 2;
            break;
        }
        case 3:{
            _dayNum=@"二";
            dayInt = 3;
            break;
        }
        case 4:{
            _dayNum=@"三";
            dayInt = 4;
            break;
        }
        case 5:{
            _dayNum=@"四";
            dayInt = 5;
            break;
        }
        case 6:{
            _dayNum=@"五";
            dayInt = 6;
            break;
        }
        case 7:{
            _dayNum=@"六";
            dayInt = 7;
            break;
        }
            
            
        default:
            break;
    }
    
    return dayInt;
}

/**
 * 根据i获得周几
 * i是0-6的范围的整数
 */
- (NSString *)getWeekString:(int)i
{
    NSString* week;
    switch (i) {
        case 0:{
            week=@"周日";
            break;
        }
        case 1:{
            week=@"周一";
            break;
        }
        case 2:{
            week=@"周二";
            break;
        }
        case 3:{
            week=@"周三";
            break;
        }
        case 4:{
            week=@"周四";
            break;
        }
        case 5:{
            week=@"周五";
            break;
        }
        case 6:{
            week=@"周六";
            break;
        }
        default:
            break;
    }
    
    return week;
}

/**
 * 设置当前日历界面的日期
 */
-(void)setDateViewLabelTitle
{
    int chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
    
    for (int i = 0; i < [_dateLabelArray count]; i++)
    {
        UILabel *lab = (UILabel*)[_dateLabelArray objectAtIndex:i];
        NSString *dateString = [NSString stringWithFormat:@"%d",(int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt]]];
        if ([dateString intValue] < 10)
        {
            dateString = [@"0" stringByAppendingString:dateString];
        }
        lab.text = dateString;
        
    }
}

/**
 * 设置日历界面左边的日期为左边一周的
 */
-(void)setDateViewLabelTitleRight
{
    int chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
    for (int i = 0; i < [_dateLabelArrayRight count]; i++)
    {
        UILabel *lab = (UILabel*)[_dateLabelArrayRight objectAtIndex:i];
        NSString *dateString = [NSString stringWithFormat:@"%d",(int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt]]];
        if ([dateString intValue] < 10)
        {
            dateString = [@"0" stringByAppendingString:dateString];
        }
        lab.text = dateString;
    }
}

/**
 * 修改日历界面右边的日期为右边一周的
 */
-(void)setDateViewLabelTitleLeft
{
    int chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
    for (int i = 0; i < [_dateLabelArrayLeft count]; i++)
    {
        UILabel *lab = (UILabel*)[_dateLabelArrayLeft objectAtIndex:i];
        NSString *dateString = [NSString stringWithFormat:@"%d",(int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt]]];
        if ([dateString intValue] < 10)
        {
            dateString = [@"0" stringByAppendingString:dateString];
        }
        lab.text = dateString;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
