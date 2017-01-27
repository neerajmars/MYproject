//
//  BaseVC.m
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"
#import "TabVC.h"

@interface BaseVC ()

@end

@implementation BaseVC
@synthesize parentVC;
@synthesize controller;

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
    
    // In base class to all windows, sets up notification so we can disconnect peripherals when app enters background.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setParentVC:nil];
    [self setController:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) receivedBackgroundNotification:(NSNotification *) notification
{
    //if (parentVC)
    //{
    //    [parentVC disconnectFromPeripherals];
    //}
    //
    //parentVC.offline = YES;
    //parentVC.selectedController = NO_CONTROLLER_CONNECTED;
}

- (void) receivedActiveNotification:(NSNotification *) notification
{
    // forces the screen to redraw itself no matter where it was before (goes back to home(find) page).
    if (parentVC.offline == true)
    {
        [self.tabBarController setSelectedIndex:kSTATUS_TAB];
        [self.tabBarController setSelectedIndex:kFIND_TAB];
    }
}

- (void)setParentVC:(iPhoneTabBarController *)p
{
    parentVC = p;
    controller = p.controller;  
}

- (void)loadValuesFromControllerImage
{
    NSLog(@"ERROR: this should be overriden.");
}

- (void)storeValuesToControllerImage
{
    NSLog(@"ERROR: this should be overriden.");    
}
- (void)storeValuesToControllerImageWithEditTimeOut
{
    
}
- (void)loadValuesFromControllerImageForRelayChannelSetting
{
     NSLog(@"ERROR: this should be overriden.");
}
- (void)storeValuesFromControllerImageForRelayChannelSetting
{
     NSLog(@"ERROR: this should be overriden.");
}

@end
