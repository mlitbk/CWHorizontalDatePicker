//
//  NSDate+CWDatePicker.m
//  CWDatePicker
//
//  Created by Michael Litvak on 6/11/14.
//  Copyright (c) 2014 Michael Litvak. All rights reserved.
//

#import "NSDate+CWDatePicker.h"

@implementation NSDate (CWDatePicker)

static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);

+ (NSCalendar *) currentCalendar
{
    static dispatch_once_t pred;
    static __strong NSCalendar *sharedCalendar = nil;
    
    dispatch_once(&pred, ^{
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    });
    
    return sharedCalendar;
}

+ (NSString*)localizedMonthAbbreviationForMonth:(NSUInteger)month {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSDate *date = [cal dateFromComponents:comps];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    [components setDay:day];
    
    if (month <= 0) {
        [components setMonth:12-month];
        [components setYear:year-1];
    } else if (month >= 13) {
        [components setMonth:month-12];
        [components setYear:year+1];
    } else {
        [components setMonth:month];
        [components setYear:year];
    }
    
    
    return [NSDate dateWithNoTime:[calendar dateFromComponents:components] middleDay:NO];
}

- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    formatter.locale = [NSLocale currentLocale];
    return [formatter stringFromDate:self];
}

- (NSString *) mediumDateString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

+ (NSDate *)dateWithNoTime:(NSDate *)dateTime middleDay:(BOOL)middle
{
    if( dateTime == nil ) {
        dateTime = [NSDate date];
    }
    
    NSCalendar       *calendar   = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                             fromDate:dateTime];
    
    NSDate *dateOnly = [calendar dateFromComponents:components];
    
    if (middle)
        dateOnly = [dateOnly dateByAddingTimeInterval:(60.0 * 60.0 * 12.0)];           // Push to Middle of day.
    
    return dateOnly;
}

+ (NSUInteger)daysInMonth:(NSUInteger)month year:(NSUInteger)year {
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    [comps setYear:year];
    
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                              inUnit:NSMonthCalendarUnit
                             forDate:[cal dateFromComponents:comps]];
    return range.length;
}

- (NSInteger) day
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.day;
}

- (NSInteger) month
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.month;
}

- (NSInteger) year
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.year;
}

@end
