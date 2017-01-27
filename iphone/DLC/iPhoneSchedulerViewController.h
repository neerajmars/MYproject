//
//  iPhoneSchedulerViewController.h
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "constants.h"
#include "SchedulerVC.h"

@interface iPhoneSchedulerViewController : SchedulerVC
{
    TimeOfDay selectedTime;
    DayOfWeek selectedDay;
    Profile   selectedProfile;
    }

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *days;
@property (strong, nonatomic) NSArray *profiles;
@property (strong, nonatomic) NSArray *hours;
@property (strong, nonatomic) NSArray *minutes;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *syncButton;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleEnabledSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *hideAllView;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIImageView *schedulerImgVw;
- (IBAction)writeScheduleToController:(UIBarButtonItem *)sender;
- (IBAction)toWeekView:(UIButton *)sender;
- (IBAction)updateScheduleEnable:(UISwitch *)sender;

- (IBAction)ClkOnSaveBtn:(id)sender;

// delegate
- (void)updateScheduleForDay:(DayOfWeek)chosenDay forProfile:(Profile)chosenProfile andWithStartTime:(TimeOfDay)time;

@end
