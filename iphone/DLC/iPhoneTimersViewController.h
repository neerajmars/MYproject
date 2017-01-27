//
//  iPhoneTimersViewController.h
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimersVC.h"

@interface iPhoneTimersViewController : TimersVC
{
}

@property (strong, nonatomic) id delegate;

@property (strong, nonatomic) IBOutlet UISlider *timer1Slider;
@property (strong, nonatomic) IBOutlet UISlider *level1Slider;
@property (strong, nonatomic) IBOutlet UISlider *timer2Slider;
@property (strong, nonatomic) IBOutlet UISlider *level2Slider;
@property (strong, nonatomic) IBOutlet UISlider *timer3Slider;
@property (strong, nonatomic) IBOutlet UISlider *level3Slider;
@property (strong, nonatomic) IBOutlet UILabel *timer1Label;
@property (strong, nonatomic) IBOutlet UILabel *level1Label;
@property (strong, nonatomic) IBOutlet UILabel *timer2Label;
@property (strong, nonatomic) IBOutlet UILabel *level2Label;
@property (strong, nonatomic) IBOutlet UILabel *timer3Label;
@property (strong, nonatomic) IBOutlet UILabel *level3Label;
@property (strong, nonatomic) IBOutlet UILabel *brightness1Label;
@property (strong, nonatomic) IBOutlet UILabel *duration2Label;
@property (strong, nonatomic) IBOutlet UILabel *brightness2Label;
@property (strong, nonatomic) IBOutlet UILabel *duration3Label;
@property (strong, nonatomic) IBOutlet UILabel *brightness3Label;

- (IBAction)timerSliderChanged:(UISlider *)sender;
- (IBAction)levelSliderChanged:(UISlider *)sender;

@end
