//
//  ProfileVC.m
//  DLC
//
//  Created by mr king on 26/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileVC.h"
#include "constants.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"

@interface ProfileVC ()

@end

@implementation ProfileVC
@synthesize timersViewVisible;
@synthesize nameViewVisible;
@synthesize linkViewVisible;

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
    timersViewVisible = NO;
    nameViewVisible = NO;
    linkViewVisible = NO;
    selectedProfile = PROFILE1;
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
    for (int timer = TIMER1; timer < NUM_TIMERS; timer++)
    {
        timerMax[timer] = [controller getTimerMaxForProfile:(int)selectedProfile andTimer:timer];
        dimLevel[timer] = [controller getDimLevelForProfile:(int)selectedProfile andTimer:timer];
    }   
    
    absenceEnable = [controller getAbsenceEnableForProfile:(int)selectedProfile];
   // dsiDali = [controller getDimmingFormat];
    photocellValue = [controller getPhotocellCalibrationForProfile:(int)selectedProfile];
    brightOutEnable=[controller getbrightOutEnableForProfile:(int)selectedProfile];
    constantLightEnable=[controller getConstantLightEnableForProfile:(int)selectedProfile];
    
}

- (void)storeValuesToControllerImage
{
    [controller setAbsenceEnableForProfile:(int)selectedProfile withState:absenceEnable];
  //  [controller setDimmingFormatWithState:dsiDali];
    [controller setPhotocellCalibrationForProfile:(int)selectedProfile withCalibrationValue:(int)photocellValue];
    
     [controller setbrightOutEnableForProfile:(int)selectedProfile withState:brightOutEnable];
    [controller setConstantLightEnableForProfile:(int)selectedProfile withState:constantLightEnable];
    
    for (int timer = TIMER1; timer < NUM_TIMERS; timer++)
    {
        [controller setTimerMaxForProfile:(int)selectedProfile andTimer:timer withValue:timerMax[timer]];
        [controller setDimLevelForProfile:(int)selectedProfile andTimer:timer withValue:dimLevel[timer]];
    }
}
- (void)storeValuesToControllerImageWithEditTimeOut
{
    for (int timer = TIMER1; timer < NUM_TIMERS-1; timer++)
    {
        [controller setTimerMaxForProfile:(int)selectedProfile andTimer:timer withValue:timers[timer]];
        [controller setDimLevelForProfile:(int)selectedProfile andTimer:timer withValue:levels[timer]];
    }
}
- (BOOL)showTimersView
{
    if (timersViewVisible == NO)
    {
        timersViewVisible = YES;
        return (YES);
    }
    
    return (NO);
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

- (BOOL)showLinkView
{
    if (linkViewVisible == NO)
    {
        linkViewVisible = YES;
        return (YES);
    }
    
    return (NO);
}
@end
