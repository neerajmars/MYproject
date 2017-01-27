//
//  iPhoneProfileNameViewController.m
//  DLC
//
//  Created by mr king on 09/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneProfileNameViewController.h"
#import "iPhoneProfileViewController.h"
#import "iPhoneTabBarController.h"
#import "iPhoneSchedulerViewController.h"

@interface iPhoneProfileNameViewController ()

@end

@implementation iPhoneProfileNameViewController
@synthesize txtDescription;
@synthesize txtLocation;
@synthesize txtFilename;
@synthesize lblWarning;
@synthesize saveButton;

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
    [self setTxtDescription:nil];
    [self setTxtLocation:nil];
    [self setTxtFilename:nil];
    [self setLblWarning:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    lblWarning.hidden = YES;

    if (callingScreen == kProfileScreen)
    {
        iPhoneProfileViewController *initialView= (iPhoneProfileViewController *)self.delegate;
        [self setParentVC:(iPhoneTabBarController *)[[initialView parentViewController] parentViewController]];
    }
    else if (callingScreen == kSchedulerScreen)
    {
        iPhoneSchedulerViewController *initialView= (iPhoneSchedulerViewController *)self.delegate;
        [self setParentVC:(iPhoneTabBarController *)[[initialView parentViewController] parentViewController]];
    }
    
    [self loadValuesFromControllerImage];
    [self updateGUI];
    saveButton.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{    
    if (callingScreen == kProfileScreen)
    {
        ((iPhoneProfileViewController *)self.delegate).nameViewVisible = NO;
    }
    else if (callingScreen == kSchedulerScreen)
    {
        ((iPhoneSchedulerViewController *)self.delegate).nameViewVisible = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateGUI
{
    
    
    [self loadValuesFromControllerImage];
    txtDescription.text = description;
    txtLocation.text = location;
    txtFilename.text = filename;
}


- (IBAction)saveToFile:(id)sender
{
    [txtDescription resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtFilename resignFirstResponder];
    
    if ([self savedXMLFileWithName:txtFilename.text andDescription:txtDescription.text andLocation:txtLocation.text] == YES)
    {
        //[parentVC writeDeviceInformation];
        [self updateGUI];
        saveButton.enabled = NO;
        //[parentVC readDeviceInformation];
    }
}

- (IBAction)detailsChanged:(id)sender
{
    saveButton.enabled = YES;
}
@end
