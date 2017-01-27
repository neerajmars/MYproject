//
//  iPhoneTimersViewController.m
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneLinkViewController.h"
#import "iPhoneProfileViewController.h"
#import "iPhoneTabBarController.h"
#include "constants.h"
//#import <QuartzCore/QuartzCore.h>


@interface iPhoneLinkViewController ()

@end

@implementation iPhoneLinkViewController
@synthesize timer1Slider;
@synthesize timer2Slider;
@synthesize timer1Label;
@synthesize timer2Label;
@synthesize linkingSwitch;
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
	// Do any additional setup after loading the view 
    timer1Slider.maximumValue = MAX_TIMER_MINS;
    timer1Slider.minimumValue = MIN_TIMER_MINS;
    timer2Slider.maximumValue = MAX_TIMER_MINS;
    timer2Slider.minimumValue = MIN_TIMER_MINS;
    
    initialView = (iPhoneProfileViewController *)self.delegate;
}

- (void)viewDidUnload
{
    [self setTimer1Slider:nil];
    [self setTimer2Slider:nil];
    [self setTimer1Label:nil];
    [self setTimer2Label:nil];
    [self setDelegate:nil];

    [self setLinkingSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{ 
    [self setParentVC:(iPhoneTabBarController *)[[initialView parentViewController] parentViewController]];
    [self loadValuesFromControllerImage];
    [self updateGUI];    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self storeValuesToControllerImage];
    ((iPhoneProfileViewController *)self.delegate).linkViewVisible = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateGUI
{
    UILabel *label;
    NSString *text;
    UISlider *slider;
    
    linkingSwitch.on = dayLinkEnable;
    
    for (int timer = 0; timer < 2; timer++)
    {
        //timer labels
        label = (UILabel *)[self.view viewWithTag:(20 + timer)];
        text = [[NSString alloc] initWithFormat:@"%d mins", timers[timer]];
        label.text = text;
        
        //timer sliders
        slider = (UISlider *)[self.view viewWithTag:(10 + timer)];
        slider.value = timers[timer];        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)timerSliderChanged:(UISlider *)sender 
{
    timers[sender.tag - 10] = sender.value;
    [self updateGUI];
}

- (IBAction)linkSwitchChanged:(id)sender
{
    dayLinkEnable = linkingSwitch.on;
}

@end
