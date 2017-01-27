//
//  iPhoneProfileViewController.h
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileVC.h"
#include "constants.h"
#import "AppDelegate.h"

@interface iPhoneProfileViewController : ProfileVC<UITextFieldDelegate>
{
    
    AppDelegate *appDelegate;
    
    NSString *selectedBtnOnProfile;
    
    UIButton *searchBtn;
    UILabel *searchLbl;
    UIButton *statusBtn;
    UILabel *statusLbl;
    UIButton *profileBtn;
    UILabel *profileLbl;
    UIButton *scheduleBtn;
    UILabel *schedulerLbl;
    UIButton *manageFileBtn;
    UILabel *manageFileLbl;
    
    //General ProfileSetting Vw Variables
    UISwitch *absenceSwitch;
    UISwitch *constantLightSwitch;
    UIView *saveProfileVw;
    BOOL isShowinfo;
    UIView *infoVw;
    UILabel *firstBrighnessLbl;
    UILabel *secondBrightnessLbl;
    UILabel *firstTimeLbl;
    UILabel *secondTimeLbl;
    UILabel *lightLevelAdjustLbl;
    UIStepper *lightLevelAdjustStepper;
    UISwitch *brightOutSwitch;
    UIView *constantLightFlyOutVw;
    
    // editTimeouts Variables
    UIImageView *occupancytimerBlueImgVw;
    UIImageView *transitionTimerBlueImgVw;
    //sensorSelectScreen variables
    UIImageView *sensorImgVw;
    // save profile variable
    UITextField *fileNameTF;
    UISegmentedControl *profileSegmentedControl1;
    
    
    
    
}



@property (weak, nonatomic) IBOutlet UIScrollView *ç;
@property (strong, nonatomic) NSString *selectedBtn;
//SunTimeVw Variables
@property (strong, nonatomic) NSString *profile1BrightnessValue;
@property (strong, nonatomic) NSString *profile1TimeValue;
@property (strong, nonatomic) NSString *profile2BrightnessValue;
@property (strong, nonatomic) NSString *profile2TimeValue;
@property (strong, nonatomic) NSString *manageFileToProfile;
@property (nonatomic, assign) BOOL isSelectSensorScreen;
@property (weak, nonatomic) IBOutlet UIView *profileMainVw;

//........

@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UILabel *timer1Label;
@property (strong, nonatomic) IBOutlet UILabel *timer2Label;
@property (strong, nonatomic) IBOutlet UILabel *timer3Label;
@property (strong, nonatomic) IBOutlet UILabel *level1BrightnessLabel;
@property (strong, nonatomic) IBOutlet UILabel *level2BrightnessLevel;
@property (strong, nonatomic) IBOutlet UILabel *level3BrightnessLevel;
@property (strong, nonatomic) IBOutlet UISwitch *absenceSettingSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *linkingSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *harvestSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *dsiDaliSwitch;
@property (strong, nonatomic) IBOutlet UILabel *photocellLabel;
@property (strong, nonatomic) IBOutlet UIStepper *photocellStepper;
@property (strong, nonatomic) IBOutlet UISegmentedControl *profileSegmentedControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *syncButton;
@property (strong, nonatomic) IBOutlet UIButton *saveProfileButton;
@property (strong, nonatomic) IBOutlet UIImageView *hideAllView;

@property (strong, nonatomic) IBOutlet UIImageView *DSILabel;

//- (IBAction)selectedProfileChanged:(id)sender;
- (IBAction)writeProfileToController:(id)sender;
- (IBAction)saveProfile:(id)sender;
//- (IBAction)autoSettingChanged:(id)sender;
//- (IBAction)linkingSettingChanged:(id)sender;
//- (IBAction)harvestSettingChanged:(id)sender;
//- (IBAction)dsiDaliSettingChanged:(id)sender;
//- (IBAction)photocellStepperChanged:(UIStepper *)sender;

@end
