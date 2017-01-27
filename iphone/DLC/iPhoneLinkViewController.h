//
//  iPhoneTimersViewController.h
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkVC.h"

@interface iPhoneLinkViewController : LinkVC
{
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UISwitch *linkingSwitch;

@property (strong, nonatomic) IBOutlet UISlider *timer1Slider;
@property (strong, nonatomic) IBOutlet UISlider *timer2Slider;
@property (strong, nonatomic) IBOutlet UILabel *timer1Label;
@property (strong, nonatomic) IBOutlet UILabel *timer2Label;

- (IBAction)timerSliderChanged:(UISlider *)sender;
- (IBAction)linkSwitchChanged:(id)sender;

@end
