//
//  CWDatePickerCell.h
//  CWDatePicker
//
//  Created by Michael Litvak on 5/18/14.
//  Copyright (c) 2014 codewhisper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWDatePicker.h"

@interface CWDatePickerRow : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) CWDatePicker *datePicker;

- (id)init;

- (void)setData:(NSArray*)data;

- (NSString*)selectedValue;
- (NSUInteger)selectedIndex;

- (void)selectFirstRow;
- (void)selectLastRow;
- (void)selectRow:(NSUInteger)row;
- (void)selectRowWithValue:(NSUInteger)value;

- (BOOL)isStatic;

@end
