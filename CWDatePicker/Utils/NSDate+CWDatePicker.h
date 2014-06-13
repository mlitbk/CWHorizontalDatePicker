//
//  NSDate+CWDatePicker.h
//  CWDatePicker
//
//  Created by Michael Litvak on 6/11/14.
//  Copyright (c) 2014 Michael Litvak. All rights reserved.
//

/* some of this is code is from NSDate-Extensions by Erica Sadun, thanks
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 */

#import <Foundation/Foundation.h>

@interface NSDate (CWDatePicker)

+ (NSDate *)dateFromDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;
+ (NSString*)localizedMonthAbbreviationForMonth:(NSUInteger)month;
- (NSString *) mediumDateString;
+ (NSUInteger)daysInMonth:(NSUInteger)month year:(NSUInteger)year;
- (NSInteger) day;
- (NSInteger) month;
- (NSInteger) year;

@end
