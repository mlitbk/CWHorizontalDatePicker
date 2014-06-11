//
//  CWDatePicker.m
//  CWDatePicker
//
//  Created by Michael Litvak on 5/18/14.
//  Copyright (c) 2014 codewhisper. All rights reserved.
//

#import "CWDatePicker.h"
#import "CWDatePickerRow.h"
#import "Masonry.h"
#import "NSDate+CWDatePicker.h"

#define kDateLabelFont [UIFont boldSystemFontOfSize:18]

static CGFloat const dayPickerRowHeight = 40;
static CGFloat const dayPickerRowsSpacing = 8;
static CGFloat const dateLabelOffset = 25;

@interface CWDatePicker ()

@property UITableView *tableView;

@property NSArray *tableCells;

@end

@implementation CWDatePicker {
    UILabel *_dateLabel;
    CWDatePickerRow *_dayRow;
    CWDatePickerRow *_monthRow;
    CWDatePickerRow *_yearRow;
    
    UIImageView *_arrow_up;
    UIImageView *_arrow_down;
    
    NSString *_dateLabelString;
    NSUInteger _startYear;
    NSUInteger _endYear;
}

- (id)initWithLabel:(NSString*)dateLabelString startYear:(NSUInteger)startYear endYear:(NSUInteger)endYear {
    self = [super init];
    if (self) {
        _dateLabelString = dateLabelString;
        _startYear = startYear;
        _endYear = endYear;
        
        _dateLabel = [[UILabel alloc] init];
        _dayRow = [[CWDatePickerRow alloc] init];
        _monthRow = [[CWDatePickerRow alloc] init];
        _yearRow = [[CWDatePickerRow alloc] init];
        
        for (CWDatePickerRow *datePickerRow in @[_dayRow, _monthRow, _yearRow]) {
            datePickerRow.datePicker = self;
        }
        
        _dateLabel.text = dateLabelString;
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.font = kDateLabelFont;

        [self addSubview:_dateLabel];
        [self addSubview:_dayRow];
        [self addSubview:_monthRow];
        [self addSubview:_yearRow];
        
        [self setupContraints];
        
        [self initData];
    }
    return self;
}

- (void)setupContraints {
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(dateLabelOffset);
        make.top.equalTo(self.mas_top).with.offset(dayPickerRowsSpacing);
    }];
    
    [_dayRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:dayPickerRowHeight]);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(_dateLabel.mas_bottom).with.offset(dayPickerRowsSpacing);
        make.left.equalTo(self.mas_left);
    }];
    
    [_monthRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:dayPickerRowHeight]);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(_dayRow.mas_bottom).with.offset(dayPickerRowsSpacing);
        make.left.equalTo(self.mas_left);
    }];
    
    [_yearRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:dayPickerRowHeight]);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(_monthRow.mas_bottom).with.offset(dayPickerRowsSpacing);
        make.left.equalTo(self.mas_left);
    }];
    
    [_arrow_down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dayRow.mas_top);
        make.centerX.equalTo(_dayRow.mas_centerX);
    }];
    
    [_arrow_up mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_yearRow.mas_bottom);
        make.centerX.equalTo(_yearRow.mas_centerX);
    }];
}

- (void)updateDateLabel {
    _dateLabel.text = [NSString stringWithFormat:@"%@%@", _dateLabelString, [[self selectedDate] mediumDateString]];
}

#pragma mark - Data Handling

- (void)initData {
    [self setNumberOfDays:31];
    [self setMonthStrings];
    [self setStartYear:_startYear endYear:_endYear];
}

- (NSUInteger)daysInSelectedMonth {
    return [NSDate daysInMonth:[self selectedMonth] year:[self selectedYear]];
}

- (void)setNumberOfDays:(NSUInteger)num {
    if (num <= 1)
        return;
    
    NSMutableArray *days = [NSMutableArray array];
    
    for (NSUInteger i = 1; i <= num; i++)
        [days addObject:[NSString stringWithFormat:@"%02lu", (unsigned long)i]];
    
    _dayRow.data = days;
}

- (void)setMonthStrings {
    NSMutableArray *monthStrings = [NSMutableArray array]
    ;
    
    for (NSUInteger i = 1; i <= 12; i++) {
        [monthStrings addObject:[NSDate localizedMonthAbbreviationForMonth:i]];
    }
    
    _monthRow.data = monthStrings;
}

- (void)setStartYear:(NSUInteger)startYear endYear:(NSUInteger)endYear {
    NSMutableArray *years = [NSMutableArray array];
    
    for (NSUInteger i = startYear; i <= endYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
    }
    
    _yearRow.data = years;
}

#pragma mark - Date Selection

/* returns bool that indicates if the datePickerRow should
 * scroll to the selected index or no */
- (BOOL)datePickerRowDidChangeSelection:(CWDatePickerRow*)datePickerRow {
    NSDate *date = [self selectedDate];
    
    NSUInteger daysInMonth = [self daysInSelectedMonth];
    
    // if the day is illegal, select the last possible day in this month
    if ([self selectedDay] > daysInMonth) {
        [_dayRow selectRow:daysInMonth - 1];
        
        /* we don't want the day row to scroll if the date is invalid */
        if (datePickerRow == _dayRow) {
            return NO;
        } else {
            return YES;
        }
    }
    
    if (self.delegate) {
        [self.delegate datePicker:self didSelectDate:date];
    }
    
    [self updateDateLabel];
    
    return YES;
}

- (NSDate*)selectedDate {
    return [NSDate dateFromDay:[self selectedDay] month:[self selectedMonth] year:[self selectedYear]];
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    [_dayRow selectRow:([selectedDate day] - 1)];
    [_monthRow selectRow:([selectedDate month] - 1)];
    [_yearRow selectRowWithValue:[selectedDate year]];
}

- (NSString*)selectedDateString {
    return [[self selectedDate] mediumDateString];
}

- (NSUInteger)selectedDay {
    return [[_dayRow selectedValue] intValue];
}

- (NSUInteger)selectedMonth {
    return [_monthRow selectedIndex] + 1;
}

- (NSUInteger)selectedYear {
    return [[_yearRow selectedValue] intValue];
}

@end