//
//  iPhoneTimersViewController.m
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneTimersViewController.h"
#import "iPhoneProfileViewController.h"
#import "iPhoneTabBarController.h"
#include "constants.h"
//#import <QuartzCore/QuartzCore.h>


@interface iPhoneTimersViewController ()

@end

@implementation iPhoneTimersViewController
@synthesize timer1Slider;
@synthesize level1Slider;
@synthesize timer2Slider;
@synthesize level2Slider;
@synthesize timer3Slider;
@synthesize level3Slider;
@synthesize timer1Label;
@synthesize level1Label;
@synthesize timer2Label;
@synthesize level2Label;
@synthesize timer3Label;
@synthesize level3Label;
@synthesize brightness1Label;
@synthesize brightness2Label;
@synthesize brightness3Label;
@synthesize duration2Label;
@synthesize duration3Label;
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
    timer3Slider.maximumValue = MAX_TIMER_MINS;
    timer3Slider.minimumValue = MIN_TIMER_MINS;
    level1Slider.maximumValue = MAX_PERCENT;
    level1Slider.minimumValue = MIN_PERCENT;
    level2Slider.maximumValue = MAX_PERCENT;
    level2Slider.minimumValue = MIN_PERCENT;
    level3Slider.maximumValue = MAX_PERCENT;
    level3Slider.minimumValue = MIN_PERCENT;
    
    initialView = (iPhoneProfileViewController *)self.delegate;
}

- (void)viewDidUnload
{
    [self setTimer1Slider:nil];
    [self setLevel1Slider:nil];
    [self setTimer2Slider:nil];
    [self setLevel2Slider:nil];
    [self setTimer3Slider:nil];
    [self setLevel3Slider:nil];
    [self setTimer1Label:nil];
    [self setLevel1Label:nil];
    [self setTimer2Label:nil];
    [self setLevel2Label:nil];
    [self setTimer3Label:nil];
    [self setLevel3Label:nil];
    [self setDelegate:nil];
    

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
    ((iPhoneProfileViewController *)self.delegate).timersViewVisible = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateGUI
{
    UILabel *label;
    NSString *text;
    UISlider *slider;
    UInt8 modelNo = [controller getModelNumber];
    
    for (int timer = TIMER1; timer < NUM_TIMERS; timer++)
    {
        //timer labels
        label = (UILabel *)[self.view viewWithTag:(20 + timer)];
        text = [[NSString alloc] initWithFormat:@"%d mins", timers[timer]];
        label.text = text;
        
        //dimmer labels
        label = (UILabel *)[self.view viewWithTag:(30 + timer)];
        text = [[NSString alloc] initWithFormat:@"%d %%", levels[timer]];
        label.text = text;
        
        //timer sliders
        slider = (UISlider *)[self.view viewWithTag:(10 + timer)];
        
        if (modelNo != (kDLC100 + 1))
        {
            slider.value = timers[timer];
            slider.enabled = YES;
            slider.alpha = 1.0;
        }
        else if (timer > TIMER1)
        {
            slider.value = 0;
            slider.enabled = NO;
            slider.alpha = 0.3;
        }
        
        //dimmer sliders
        slider = (UISlider *)[self.view viewWithTag:(15 + timer)];

        if (modelNo != (kDLC100 + 1))
        {
            slider.value = levels[timer];
            slider.enabled = YES;
            slider.alpha = 1.0;
            duration2Label.textColor = [UIColor blackColor];
            duration3Label.textColor = [UIColor blackColor];
            brightness1Label.textColor = [UIColor blackColor];
            brightness2Label.textColor = [UIColor blackColor];
            brightness3Label.textColor = [UIColor blackColor];

        }
        else
        {
            slider.value = 0;
            slider.enabled = NO;
            slider.alpha = 0.3;
            duration2Label.textColor = [UIColor lightGrayColor];
            duration3Label.textColor = [UIColor lightGrayColor];
            brightness1Label.textColor = [UIColor lightGrayColor];
            brightness2Label.textColor = [UIColor lightGrayColor];
            brightness3Label.textColor = [UIColor lightGrayColor];
        }
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

- (IBAction)levelSliderChanged:(UISlider *)sender 
{
    unsigned char newLevel = sender.value;
    
    if (sender.value < 10)
    {
        if (sender.value < 5)
        {
            newLevel = 0;
        }
        else
        {
            newLevel = 10;
        }
    }
    
    levels[sender.tag - 15] = newLevel;
    [self updateGUI];
}

/*
- (void)formatView:(UIView *)theView
{
    // Create a view
    [theView setBackgroundColor:[UIColor grayColor]];
    theView.layer.cornerRadius = 5.0f;
    
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:theView.bounds 
                                                   byRoundingCorners:UIRectCornerTopLeft
                                                         cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    // Create the shadow layer
    CAShapeLayer *shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:theView.bounds];
    [shadowLayer setMasksToBounds:NO];
    [shadowLayer setShadowPath:maskPath.CGPath];
    
    // Set the shadowColor, shadowOffset, shadowOpacity & shadowRadius as required
    [shadowLayer setShadowColor:[UIColor lightGrayColor].CGColor];
    [shadowLayer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    [shadowLayer setShadowOpacity:0.9];
    [shadowLayer setShadowRadius:5.0f];
    
    // Create the rounded layer, and mask it using the rounded mask layer
    CALayer *roundedLayer = [CALayer layer];
    [roundedLayer setFrame:theView.bounds];
    //[roundedLayer setContents:(id)theImage.CGImage];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    [maskLayer setFrame:theView.bounds];
    [maskLayer setPath:maskPath.CGPath];
    
    roundedLayer.mask = maskLayer;
    
    // Add these two layers as sublayers to the view
    [theView.layer addSublayer:shadowLayer];
    [theView.layer addSublayer:roundedLayer];
}
*/
@end
