//
//  CWDatePickerCell.m
//  Analysa
//
//  Created by Michael Litvak on 5/27/14.
//  Copyright (c) 2014 codewhisper. All rights reserved.
//

#import "CWDatePickerCell.h"

#define kColorActive [UIColor blackColor]
#define kColorNotActive [UIColor grayColor]
#define kCellFont [UIFont boldSystemFontOfSize:17]

@implementation CWDatePickerCell {
    UIView *rightBorder;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _label.textColor = kColorActive;
    } else {
        _label.textColor = kColorNotActive;
    }
    [super setSelected:selected];
}

- (void)setupWithData:(NSString *)data {
    if ([self viewWithTag:998]) {
        [[self viewWithTag:998] removeFromSuperview];
    }
    
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = kCellFont;
    _label.textColor = kColorNotActive;
    _label.text = data;
    _label.tag = 998;
    
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:_label];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
}

- (void)setupBorder {
    if ([self viewWithTag:997])
        [[self viewWithTag:997] removeFromSuperview];
    
    rightBorder = [[UIView alloc] init];
    rightBorder.backgroundColor = [UIColor blackColor];
    rightBorder.tag = 997;
    
    rightBorder.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:rightBorder];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightBorder(==1)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightBorder)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightBorder]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightBorder)]];
}

- (void)removeBorder {
    if ([self viewWithTag:997]) {
        [[self viewWithTag:997] removeFromSuperview];
    }
}

@end
