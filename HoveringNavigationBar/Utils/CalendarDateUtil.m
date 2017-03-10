//
//  DateUtil.m
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import "CalendarDateUtil.h"

@implementation CalendarDateUtil

+ (BOOL)isLeapYear:(NSInteger)year
{
    NSAssert(!(year < 1), @"invalid year number");
    BOOL leap = FALSE;
    if ((0 == (year % 400))) {
        leap = TRUE;
    }
    else if((0 == (year%4)) && (0 != (year % 100))) {
        leap = TRUE;
    }
    return leap;
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month
{
    return [CalendarDateUtil numberOfDaysInMonth:month year:[CalendarDateUtil getCurrentYear]];
}

+ (NSInteger)getCurrentYear
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int year = dt->tm_year + 1900;
    return year;
}

+ (NSInteger)getCurrentMonth
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int month = dt->tm_mon + 1;
    return month;
}

+ (NSInteger)getCurrentDay
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int day = dt->tm_mday;
    return day;
}

+ (NSInteger)getYearWithDate:(NSDate*)date
{
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger year = comps.year;
    return year;
}


+ (NSInteger)getMonthWithDate:(NSDate*)date
{
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger month = comps.month;
    return month;
}

+ (NSInteger)getDayWithDate:(NSDate*)date
{
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger day = comps.day;
    return day;
}

+ (NSInteger)getWeekWithDate:(NSDate*)date
{
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger week = comps.weekday;
    return week;

}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year
{
    NSAssert(!(month < 1||month > 12), @"invalid month number");
    NSAssert(!(year < 1), @"invalid year number");
    month = month - 1;
    static int daysOfMonth[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    NSInteger days = daysOfMonth[month];
    /*
     * feb
     */
    if (month == 1) {
        if ([CalendarDateUtil isLeapYear:year]) {
            days = 29;
        }
        else {
            days = 28;
        }
    }
    return days;
}

+ (NSDate*)dateSinceNowWithInterval:(NSInteger)dayInterval
{
    return [NSDate dateWithTimeIntervalSinceNow:dayInterval*24*60*60];
}

#pragma mark - 任务开始 结束 设置
//获取默认的开始任务日期 2014-10-27
+ (NSString *)getDefaultStartDateWith:(NSString *)aselectdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *_selecedate = [dateFormatter dateFromString:aselectdate];
    
    NSDate *date = [CalendarDateUtil isGetNextDayWith:0] ? [NSDate dateWithTimeInterval:24*60*60 sinceDate:_selecedate]: _selecedate;
    
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    return dateString;
}

//获取默认的开始任务日期 20141027
+ (NSString *)getDateFormatWith:(NSString *)aselectdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    NSDate *_selecedate = [dateFormatter dateFromString:aselectdate];
    
    NSDate *date = [CalendarDateUtil isGetNextDayWith:0] ? [NSDate dateWithTimeInterval:24*60*60 sinceDate:_selecedate]: _selecedate;
    
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    return dateString;
}


//获取默认的开始任务时间
+ (NSString *)getDefaultStartTime
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"HH:mm";
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *dateStringH = [dateString substringToIndex:2];
    
    NSString *dateStringM = [dateString substringFromIndex:3];
    
    if ([dateStringM intValue] <= 30)
    {
        dateStringM = @"30";
    }
    else if ([dateStringM intValue] > 30)
    {
        dateStringM = @"00";
        
        dateStringH = [[NSString alloc] initWithFormat:@"%d",[dateStringH intValue] + 1];
        
        if ([dateStringH intValue] < 10)
        {
            dateStringH = [@"0" stringByAppendingString:dateStringH];
        }else if ([dateStringH intValue] > 23){
            dateStringH = @"00";
        }
    }

    dateString = [[NSString alloc] initWithFormat:@"%@:%@",dateStringH,dateStringM];
    
    return dateString;
}

//_h是小时数
+ (BOOL)isGetNextDayWith:(int)_h
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_h * 60 *60];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"HH:mm";
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *dateStringH = [dateString substringToIndex:2];
    
    NSString *dateStringM = [dateString substringFromIndex:3];
    
    if ([dateStringM intValue] <= 30)
    {
        dateStringM = @"30";
    }
    else if ([dateStringM intValue] > 30)
    {
        dateStringM = @"00";
        
        dateStringH = [[NSString alloc] initWithFormat:@"%d",[dateStringH intValue] + 1];
        
        if ([dateStringH intValue] < 10)
        {
            dateStringH = [@"0" stringByAppendingString:dateStringH];
        }else if ([dateStringH intValue] > 23){
            dateStringH = @"00";
            
            return YES;
        }
    }
    
    dateString = [[NSString alloc] initWithFormat:@"%@:%@",dateStringH,dateStringM];
    
    return NO;
}

//获取默认的结束任务日期
+ (NSString *)getDefaultEndDateWith:(NSString *)aselectdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *_selectdate = [dateFormatter dateFromString:aselectdate];
    
    NSDate *date = [CalendarDateUtil isGetNextDayWith:1] ? [NSDate dateWithTimeInterval:25*60*60 sinceDate:_selectdate]: [NSDate dateWithTimeInterval:60*60 sinceDate:_selectdate];
    
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    return dateString;
}

//获取默认的结束任务时间
+ (NSString *)getDefaultEndTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60 * 60];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"HH:mm";
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *dateStringH = [dateString substringToIndex:2];
    
    NSString *dateStringM = [dateString substringFromIndex:3];
    
    if ([dateStringM intValue] <= 30)
    {
        dateStringM = @"30";
    }
    else if ([dateStringM intValue] > 30)
    {
        dateStringM = @"00";
        
        dateStringH = [[NSString alloc] initWithFormat:@"%d",[dateStringH intValue] + 1];
        
        if ([dateStringH intValue] < 10)
        {
            dateStringH = [@"0" stringByAppendingString:dateStringH];
        }else if ([dateStringH intValue] > 23){
            dateStringH = @"00";
        }
    }
    
    dateString = [[NSString alloc] initWithFormat:@"%@:%@",dateStringH,dateStringM];
    
    return dateString;
}

@end
