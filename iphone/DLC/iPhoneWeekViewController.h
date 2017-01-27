//
//  iPhoneWeekViewController.h
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekVC.h"

@interface iPhoneWeekViewController : WeekVC <UIPickerViewDataSource, UIPickerViewDelegate>
{
}

@property (strong, nonatomic) NSArray *days;
@property (strong, nonatomic) NSArray *profiles;
@property (strong, nonatomic) NSArray *hours;
@property (strong, nonatomic) NSArray *minutes;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)saveScheduleChanges:(UIBarButtonItem *)sender;
- (IBAction)showCurrentScheduleTime:(UIButton *)sender;

@end
