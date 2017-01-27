//
//  iPhoneFileManagerViewController.m
//  DLC
//
//  Created by mr Ankit Singhal on 25/08/2016.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "iPhoneCreditsViewController.h"
#import "iPhoneTabBarController.h"
#import "AppDelegate.h"
#include "constants.h"


@interface iPhoneCreditsViewController ()

@end

@implementation iPhoneCreditsViewController

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
    lblVersion = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *appVersion = kAPP_VERSION;
    NSMutableString *version = [NSMutableString string];
    [version appendFormat:@"Version: %@", appVersion];
    
    [self setParentVC:(iPhoneTabBarController *)[[self parentViewController] parentViewController]];
    
    if (parentVC.selectedController == NO_CONTROLLER_CONNECTED)
    {
        [version appendFormat:@"00.00"];
    }
    else
    {
        unsigned char msb = [controller getDLCFirmwareVersion:true];
        unsigned char lsb = [controller getDLCFirmwareVersion:false];
        [version appendFormat:@".%02d", msb];
        [version appendFormat:@".%02d", lsb];
    }
    
    lblVersion.text = version;
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)moveToProfiles
{
}

@end
