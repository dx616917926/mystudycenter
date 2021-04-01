//
//  NSDate+HXDate.m
//  eplatform-edu
//
//  Created by iMac on 16/8/8.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "NSDate+HXDate.h"

@implementation NSDate (HXDate)

+(BOOL)compareNowTimeWithHumanString:(NSString *)string
{
    if (string == nil || ![string isKindOfClass:[NSString class]] ||[string isEqualToString:@""]) {
        return NO;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nsNow = [formatter stringFromDate:now];
    
    NSComparisonResult resule = [nsNow compare:string];
    
    if (resule == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+ (NSString *)getNowDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone localTimeZone];
    return [formatter stringFromDate:[NSDate date]];
}
- (NSInteger )distanceNowDays
{
    NSTimeInterval seconds = [self timeIntervalSinceNow];
    if (seconds < 0) {
        seconds = -seconds;
    }
    NSInteger daySeconds = 60 * 60 * 24;
    NSInteger days = (NSInteger)(seconds / daySeconds);
    return days;
}

- (NSString *)distanceNowDescribe
{
    NSTimeInterval sinceTime = [self timeIntervalSinceNow];
    NSInteger dayOfSeconds = 60 * 60 * 24;
    NSInteger days = (NSInteger)(sinceTime / dayOfSeconds);
    if (days < 0) {
        days = 0;
    }
    NSInteger hourOfSeconds = 60 * 60;
    NSInteger hours = ((NSInteger)sinceTime / hourOfSeconds) % 24;
    
    NSInteger minuteOfSeconds = 60;
    NSInteger minutes = ((NSInteger)sinceTime / minuteOfSeconds) % 60;
    NSInteger seconds = (NSInteger)sinceTime % 60;
    
    NSString *describe = nil;
    if (days > 1) {
        describe = [NSString stringWithFormat:@"%d天",(int)days];
    }
    else if (hours > 1) {
        describe = [NSString stringWithFormat:@"%d小时",(int)hours];
    }
    else if(minutes > 1) {
        describe = [NSString stringWithFormat:@"%d分",(int)minutes];
    }
    else {
        describe = [NSString stringWithFormat:@"%d秒",(int)seconds];
    }
    
    
    return describe;
}

- (NSDictionary *)distanceNowDic
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:kCFCalendarUnitDay|kCFCalendarUnitHour| kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:[NSDate date] toDate:self options:0];
    
    NSDictionary * dic = nil;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@(comps.day),@"day",@(comps.hour),@"hour",@(comps.minute),@"minute",@(comps.second),@"second",nil];
    
    return dic;
}

- (NSDictionary *)distanceYearMonthDayFromNowDic
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:kCFCalendarUnitYear|kCFCalendarUnitMonth| kCFCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
    
    NSDictionary * dic = nil;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@(comps.year),@"year",@(comps.month),@"month",@(comps.day),@"day",nil];
    
    return dic;
}

/**
 *  功能:转换成日期字符串，精确到天
 */
- (NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone localTimeZone];
    
    NSString *ret = [formatter stringFromDate:self];
    
    return ret;
}

/**
 *  功能:转换成时间字符串，精确到秒
 */
- (NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone localTimeZone];
    
    NSString *ret = [formatter stringFromDate:self];
    
    return ret;
}

/**
 *  是否是今天的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isTodayDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *day = [dateFormatter stringFromDate:self];
    
    if ([today isEqualToString:day])
    {
        return YES;
    }
    
    return NO;
}

/**
 *  是否昨天
 */
- (BOOL)isYesterday
{
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selStr = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    NSLog(@"%ld",(long)cmps.day);
    return cmps.day == 1;
}

/**
 *  是否是今年的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isCurrentYearDate
{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *day = [dateFormatter stringFromDate:self];
    
    if ([today isEqualToString:day])
    {
        return YES;
    }
    
    return NO;
}

/**
 *  判断与当前时间差值
 */
- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
