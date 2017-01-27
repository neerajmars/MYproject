//
//  TimersVC.m
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LinkVC.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"

@interface LinkVC ()

@end

@implementation LinkVC
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
//    timers[0] = [controller getLinkDelayForProfile:selectedProfile forOnDelay:true];
//    timers[1] = [controller getLinkDelayForProfile:selectedProfile forOnDelay:false];
  //  dayLinkEnable = [controller getDaylightLinkEnableForProfile:selectedProfile];

}

- (void)storeValuesToControllerImage
{
    //copy new values onto controller image
//    [controller setLinkDelayForProfile:selectedProfile forOnDelay:true withValue: timers[0]];
//    [controller setLinkDelayForProfile:selectedProfile forOnDelay:false withValue: timers[1]];
   // [controller setDaylightLinkEnableForProfile:selectedProfile withState:dayLinkEnable];
}
@end
