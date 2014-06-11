//
//  DatePickerExampleViewController.m
//  CWDatePicker
//
//  Created by Michael Litvak on 6/11/14.
//  Copyright (c) 2014 Michael Litvak. All rights reserved.
//

#import "DatePickerExampleViewController.h"
#import "CWDatePicker.h"
#import "Masonry.h"
#import "NSDate+CWDatePicker.h"

@interface DatePickerExampleViewController ()

@end

@implementation DatePickerExampleViewController {
    CWDatePicker *_startDatePicker;
    CWDatePicker *_endDatePicker;
    UIButton *_doneButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _startDatePicker = [[CWDatePicker alloc] initWithLabel:@"Start Date: " startYear:2000 endYear:2014];
        _endDatePicker = [[CWDatePicker alloc] initWithLabel:@"End Date: " startYear:2000 endYear:2014];
        
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setBackgroundColor:[UIColor redColor]];
        [_doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view setBackgroundColor:[UIColor colorWithRed:243/255.0f green:251/255.0f blue:226/255.0f alpha:1.0f]];
        [self.view addSubview:_startDatePicker];
        [self.view addSubview:_endDatePicker];
        [self.view addSubview:_doneButton];
        
        [_startDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(20);
            make.left.equalTo(self.view.mas_left);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(@180);
        }];
        
        [_endDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_startDatePicker.mas_bottom).with.offset(20);
            make.left.equalTo(self.view.mas_left);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(@180);
        }];
        
        [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_endDatePicker.mas_bottom).with.offset(20);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (void)doneAction {
    NSString *message = [NSString stringWithFormat:@"%@ - %@", [[_startDatePicker selectedDate] mediumDateString], [[_endDatePicker selectedDate] mediumDateString]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Dates" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
