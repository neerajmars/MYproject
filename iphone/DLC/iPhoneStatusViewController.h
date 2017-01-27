//
//  iPhoneStatusViewController.h
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "StatusVC.h"
#import "BaseVC.h"
#import "SensorView.h"
#import "AppDelegate.h"

@interface iPhoneStatusViewController : StatusVC<UIAlertViewDelegate,SensorViewDelegate>
{
    AppDelegate *appDelegate;
    
    NSArray     *timerStageImages;
    NSArray     *lightLevelImages;
    NSArray     *PIRImages;
    NSArray     *LED_FlashImages;
    NSArray     *onOffStrings;
    
    int         lightsDebounceCounter;
    int         calibrationDebounceCounter;
    int         dimLevelDebounceCounterA;
    int         dimLevelDebounceCounterB;
    unsigned char dimLevelValueA;
    unsigned char dimLevelValueB;
    int timerStatus;
    int PIRTriggeredValue;
    
    
    
   // PIRState PIRStatus;
    
    
    // DALI Channel 1 Setting Variables
    UIButton *daliChannel1singlePoleCheckboxBtn;
    UIButton *daliChannel1doublePoleCheckboxBtn;
    
     // DALI Channel 2 Setting Variables
    UIButton *daliChannel2PirCheckBoxBtn;
    UIButton *daliChannel2singlePoleCheckboxBtn;
    UIButton *daliChannel2doublePoleCheckboxBtn;
    UIButton *daliChannel2ManualControlCheckBoxBtn;
    UIButton *daliChannel2MimicChaneel1CheckboxBtn;
    UISlider *mimicChannel1Slider;
    UIView *mimicChannelVw;
    UILabel *offsetValueLbl;
    
    // Relay Channel 3 Setting Variables
    
    UISwitch *relayChannel3Profile1Switch;
    UISwitch *relayChannel3Profile2Switch;
    UIButton *relayChannel3_PirCheckBoxBtn;
    UIButton *relayChannel3_DaliPowerSaveMode_CheckboxBtn;
    UIButton *relayChannel3_TimeClock_CheckboxBtn;
    UIButton *relayChannel3_ManualControlCheckBoxBtn;
}

@property (strong, nonatomic) IBOutlet UILabel *timerValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *activeProfileLabel;
@property (weak, nonatomic) IBOutlet UIButton *setConstantLightBtn;
@property (weak, nonatomic) IBOutlet UIButton *pirSettingBtn;

@property (weak, nonatomic) IBOutlet UIView *mainVw;
@property (weak, nonatomic) IBOutlet UILabel *daliChannel1ValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *lightLevelValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *daliChannel2ValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *relayChannelValueLbl;
@property (weak, nonatomic) IBOutlet UISwitch *relayChannelSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *targetLevelSensorImgVw;
@property (weak, nonatomic) IBOutlet UISwitch *walkTestSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *pirStatusSensorImgVw;
@property (weak, nonatomic) IBOutlet UIImageView *schedulerImgVw;
@property (strong, nonatomic) IBOutlet UIImageView *brightnessImage;
@property (strong, nonatomic) IBOutlet UIImageView *timerStageImage;
@property (strong, nonatomic) IBOutlet UIImageView *lightLevelImage;
@property (strong, nonatomic) IBOutlet UIImageView *PIRImage;
@property (weak, nonatomic) IBOutlet UIStepper *dali1Stepper;
@property (weak, nonatomic) IBOutlet UIStepper *dali2Stepper;
@property (strong, nonatomic) NSTimer *timer;


- (IBAction)settingBtnAction:(id)sender;
- (IBAction)settingBtnchannel2:(id)sender;
- (IBAction)settingBtnrelayAction:(id)sender;
- (IBAction)clickONsensorBtn:(id)sender;
- (IBAction)clkOnPirSettingBtn:(id)sender;
- (IBAction)daliChannel1StepperChanged:(id)sender;
- (IBAction)daliChannel2stepperChaged:(id)sender;
- (IBAction)clkOnSetConstantLgtBtn:(id)sender;
- (IBAction)relayChannel3SwitchValue:(id)sender;
- (IBAction)walkTestSwitchValueChanged:(id)sender;



@end
