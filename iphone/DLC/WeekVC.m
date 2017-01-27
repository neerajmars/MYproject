//
//  WeekVC.m
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeekVC.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"
#import "iPhoneSchedulerViewController.h"
#import "iPhoneProfileNameViewController.h"
#include "constants.h"

@interface WeekVC ()

@end

@implementation WeekVC
@synthesize delegate;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadValuesFromControllerImage
{
    iPhoneSchedulerViewController *initialView= (iPhoneSchedulerViewController *)self.delegate;
    selectedTime = [((iPhoneTabBarController *)[[initialView parentViewController] parentViewController]).controller getScheduleForProfile:selectedProfile andDay:selectedDay];
}

- (void)storeValuesToControllerImage
{
    iPhoneSchedulerViewController *initialView= (iPhoneSchedulerViewController *)self.delegate;
    [initialView updateScheduleForDay:selectedDay forProfile:selectedProfile andWithStartTime:selectedTime];
}

@end
