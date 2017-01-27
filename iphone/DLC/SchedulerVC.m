//
//  SchedulerVC.m
//  DLC
//
//  Created by mr king on 27/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SchedulerVC.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"
@interface SchedulerVC ()

@end

@implementation SchedulerVC
@synthesize nameViewVisible;
@synthesize weekViewVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    nameViewVisible = NO;
    weekViewVisible = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadValuesFromControllerImage
{
    scheduleEnabled = [controller getScheduleEnable];
    
    for (int day = MONDAY; day <= SUNDAY; day++)
    {
        profile1Time[day] = [controller getScheduleForProfile:PROFILE1 andDay:day];
        profile2Time[day] = [controller getScheduleForProfile:PROFILE2 andDay:day];
    }
}

- (void)storeValuesToControllerImage
{
    [controller setScheduleEnable:scheduleEnabled];

    for (int day = MONDAY; day <= SUNDAY; day++)
    {
        [controller setScheduleForProfile:PROFILE1 andDay:day withTime:profile1Time[day]];
        [controller setScheduleForProfile:PROFILE2 andDay:day withTime:profile2Time[day]];
    }
}

- (BOOL)showNameView
{
    if (nameViewVisible == NO)
    {
        nameViewVisible = YES;
        return (YES);
    }
    
    return (NO);
}

- (BOOL)showWeekView
{
    if (weekViewVisible == NO)
    {
        weekViewVisible = YES;
        return (YES);
    }
    
    return (NO);
}
@end
