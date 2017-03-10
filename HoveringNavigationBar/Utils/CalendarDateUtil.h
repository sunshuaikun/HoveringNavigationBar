//
//  DateUtil.h
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarDateUtil : NSObject

+ (BOOL)isLeapYear:(NSInteger)year;
/*
 * @abstract caculate number of days by specified month and current year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month;
/*
 * @abstract caculate number of days by specified month and year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year;

+ (NSInteger)getCurrentYear;

+ (NSInteger)getCurrentMonth;

+ (NSInteger)getCurrentDay;

+ (NSInteger)getYearWithDate:(NSDate*)date;

+ (NSInteger)getMonthWithDate:(NSDate*)date;

+ (NSInteger)getDayWithDate:(NSDate*)date;

+ (NSInteger)getWeekWithDate:(NSDate*)date;

+ (NSDate*)dateSinceNowWithInterval:(NSInteger)dayInterval;

#pragma mark - 任务开始 结束 设置

//获取默认的开始任务日期 2014-10-27
+ (NSString *)getDefaultStartDateWith:(NSString*)aselectdate;
//获取默认的开始任务日期 20141027
+ (NSString *)getDateFormatWith:(NSString *)aselectdate;
//获取默认的开始任务时间
+ (NSString *)getDefaultStartTime;

//获取默认的结束任务日期
+ (NSString *)getDefaultEndDateWith:(NSString*)aselectdate;

//获取默认的结束任务时间
+ (NSString *)getDefaultEndTime;

@end
