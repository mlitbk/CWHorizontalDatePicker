//
//  CWDatePicker.h
//  CWDatePicker
//
//  Created by Michael Litvak on 5/18/14.
//  Copyright (c) 2014 codewhisper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWDatePicker;
@class CWDatePickerRow;

@protocol CWDatePickerDelegate <NSObject>
@optional
- (void)datePicker:(CWDatePicker *)datePicker didSelectDate:(NSDate*)date;
@end

@interface CWDatePicker : UIView

- (id)initWithLabel:(NSString*)dateLabelString startYear:(NSUInteger)startYear endYear:(NSUInteger)endYear;

- (BOOL)datePickerRowDidChangeSelection:(CWDatePickerRow*)datePickerRow;

@property NSDate *selectedDate;

@property (nonatomic, weak) id<CWDatePickerDelegate> delegate;

@end
