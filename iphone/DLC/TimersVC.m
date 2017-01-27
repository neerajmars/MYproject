//
//  TimersVC.m
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimersVC.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"

@interface TimersVC ()

@end

@implementation TimersVC
@synthesize selectedProfile;

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadValuesFromControllerImage
{
    //keep local copy
    for (int timer = TIMER1; timer < NUM_TIMERS; timer++)
    {
        timers[timer] = [controller getTimerMaxForProfile:selectedProfile andTimer:timer];
        levels[timer] = [controller getDimLevelForProfile:selectedProfile andTimer:timer];
    }    
}

- (void)storeValuesToControllerImage
{
    //copy new values onto controller image
    for (int timer = TIMER1; timer < NUM_TIMERS; timer++)
    {
        [controller setTimerMaxForProfile:selectedProfile andTimer:timer withValue:timers[timer]];
        [controller setDimLevelForProfile:selectedProfile andTimer:timer withValue:levels[timer]];        
    }
}
@end
