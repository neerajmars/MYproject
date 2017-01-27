//
//  iPhoneTabBarController.m
//  DLC
//
//  Created by mr king on 18/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneTabBarController.h"
#import "BLEDevice.h"
#include "constants.h"

@interface iPhoneTabBarController ()

@end

@implementation iPhoneTabBarController
@synthesize tabBar;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) 
//    {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTabBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scanForPeripherals:(id)sender 
{    
    [self scan];
}

-(void) connectionTimer:(NSTimer *)timer 
{
    if (t.peripherals.count > 0)
    {
        printf("BLE devices found: %lu\n", (unsigned long)t.peripherals.count);
    }
    else 
    {
        printf("No BLE light controller devices found");
    }
}



@end
