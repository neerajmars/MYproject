//
//  iPhoneProfileViewController.m
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneProfileViewController.h"
#import "iPhoneTabBarController.h"
#import "iPhoneTimersViewController.h"

#import "iPhoneProfileNameViewController.h"
#import "iPhoneLinkViewController.h"
#include "constants.h"
#import "ASJOverflowButton.h"
#import "webViewController.h"

#define kOFFSET_FOR_KEYBOARD 170.0

@interface iPhoneProfileViewController ()
{
     UIScrollView *profileScrollVw;
    UIScrollView *editTimeScrollVw;
    UILabel *lightLevelAdjustValueLbl;
    
    UILabel *onlevelLbl;
    UILabel *occupancyTimeOutLbl;
    UILabel *powerSaveLbl;
    UILabel *transitionTimeOutLbl;
    UILabel *transitionTimeOutResolutionLbl;
    
    UITextField *onLevelTF;
    UITextField *occupancyTimeOutTF;
    UITextField *powerSaveTF;
    UITextField *transitionTimeOutTF;
    UISlider *onLevelSlider;
    UISlider *occupancyTimeOutSlider;
    UISlider *powerSaveSlider;
    UISlider *transitionTimeOutSlider;
    UILabel *titlelbl;
    
}
@property (strong, nonatomic) ASJOverflowButton *overflowButton;
@property (copy, nonatomic) NSArray *overflowItems;

@property (strong, nonatomic) ASJOverflowButton *overflowButton2;
@property (copy, nonatomic) NSArray *overflowItems2;

- (void)setup;
- (void)setupDefaults;
- (void)setupOverflowItems;
- (void)setupOverflowButton;
- (void)handleOverflowBlocks;

@end

@implementation iPhoneProfileViewController
@synthesize timer1Label;
@synthesize timer2Label;
@synthesize timer3Label;
@synthesize level1BrightnessLabel;
@synthesize level2BrightnessLevel;
@synthesize level3BrightnessLevel;
@synthesize absenceSettingSwitch;
@synthesize linkingSwitch;
@synthesize harvestSwitch;
@synthesize photocellLabel;
@synthesize photocellStepper;
@synthesize profileSegmentedControl;
@synthesize syncButton;
@synthesize saveProfileButton;
@synthesize hideAllView;
@synthesize timer;
@synthesize dsiDaliSwitch;

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
    
    [self setup];
	// Do any additional setup after loading the view.
    photocellStepper.minimumValue = MIN_PHOTOCELL_VALUE;
    photocellStepper.maximumValue = MAX_PHOTOCELL_VALUE;
    photocellStepper.stepValue = PHOTOCELL_STEPCHANGE;
    
    titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.titleView = titlelbl;
    titlelbl.textAlignment=NSTextAlignmentCenter;
    
    [self showSecondGeneralProfileSetting];
}
-(void)showGeneralProfileHeaderVw
{
    titlelbl.text=NSLocalizedString(@"PROFILE_SETTING", nil);
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sync.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clkOnSyncBtnOfGeneralprofileSetting:)];
    //self.navigationItem.rightBarButtonItem=rightBarBtn;
  //  self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem * leftBarBtnItm = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helvarLogo.png"]]];
    self.navigationItem.leftBarButtonItem = leftBarBtnItm;
}
-(void)clkOnSyncBtnOfGeneralprofileSetting:(id)sender
{
    timerMax[0]=[firstTimeLbl.text intValue];
    
    if ([secondTimeLbl.text isEqualToString:@"Infinity"]) {
        timerMax[1]=241;
    }
    else{
        timerMax[1]=[secondTimeLbl.text intValue];
    }
    
    if ([firstBrighnessLbl.text isEqualToString:@"CL"]) {
        dimLevel[0]=[self.profile1BrightnessValue intValue];
        NSLog(@"%@",self.profile1BrightnessValue);
    }
    else{
        dimLevel[0]=[firstBrighnessLbl.text intValue];
    }
    dimLevel[1]=[secondBrightnessLbl.text intValue];
    absenceEnable=absenceSwitch.on;
    brightOutEnable=brightOutSwitch.on;
    constantLightEnable=constantLightSwitch.on;
    
   [self storeValuesToControllerImage];
    [parentVC writeProfileSettings];
    [self updateSyncButton];
}

#pragma mark profileVw
-(void)showSecondGeneralProfileSetting
{
    [self showGeneralProfileHeaderVw];
    profileScrollVw=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [_profileMainVw addSubview:profileScrollVw];
    if (self.view.frame.size.height<568) {
        profileScrollVw.contentSize=CGSizeMake(profileScrollVw.frame.size.width, self.view.frame.size.height+100);
    }
    else{
         profileScrollVw.contentSize=CGSizeMake(profileScrollVw.frame.size.width, self.view.frame.size.height);
    }
    
    UIView *graphVw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, profileScrollVw.frame.size.width, profileScrollVw.frame.size.height/2.5)];
    graphVw.backgroundColor=[UIColor whiteColor];
    [profileScrollVw addSubview:graphVw];
    NSArray *itemArray = [NSArray arrayWithObjects: NSLocalizedString(@"PROFILE_1_SEG", nil), NSLocalizedString(@"PROFILE_2_SEG", nil), nil];
    
    profileSegmentedControl1=[[UISegmentedControl alloc]initWithItems:itemArray];
    profileSegmentedControl1.frame=CGRectMake(graphVw.frame.size.width/2-65, 10, 130, 30);
    profileSegmentedControl1.segmentedControlStyle = UISegmentedControlStylePlain;
    [profileSegmentedControl1 addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    [graphVw addSubview:profileSegmentedControl1];
    profileSegmentedControl1.selectedSegmentIndex = selectedProfile;
    
    
    UIImageView *graphImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(20, 60, graphVw.frame.size.width-40, graphVw.frame.size.height - (graphVw.frame.size.height/4 + 10))];
    graphImgVw.image=[UIImage imageNamed:@"profilegraph.png"];
    [graphVw addSubview:graphImgVw];
    NSLog(@"%f",graphVw.frame.size.height/4);
    
    [self showSunTimeVw];
    [self showLightLevelAdjustVw];
    [self showSaveProfileVw];
    
}
-(void)showSunTimeVw
{
    UIView *sunTimeVw=[[UIView alloc]initWithFrame:CGRectMake(0, profileScrollVw.frame.size.height/2.5 + 5, profileScrollVw.frame.size.width, 75)];
    sunTimeVw.backgroundColor=[UIColor whiteColor];
    [profileScrollVw addSubview:sunTimeVw];
    
    UIImageView *blackOneImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    blackOneImgVw.image=[UIImage imageNamed:@"one-black.png"];
    [sunTimeVw addSubview:blackOneImgVw];
    
    UIImageView *firstSunImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(40, 5, 25, 25)];
    firstSunImgVw.image=[UIImage imageNamed:@"sun.png"];
    [sunTimeVw addSubview:firstSunImgVw];
    
    firstBrighnessLbl=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 40, 15)];
    if (self.profile1BrightnessValue==nil )
    {
        self.profile1BrightnessValue=@"0";
    }
    firstBrighnessLbl.text=[NSString stringWithFormat:@"%@%%",self.profile1BrightnessValue];
    firstBrighnessLbl.textAlignment=NSTextAlignmentLeft;
    firstBrighnessLbl.textColor=[UIColor blackColor];
    firstBrighnessLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0f];
    [sunTimeVw addSubview:firstBrighnessLbl];
    
    UIImageView *firstWatchImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(140, 5, 27, 30)];
    firstWatchImgVw.image=[UIImage imageNamed:@"alarm.png"];
    [sunTimeVw addSubview:firstWatchImgVw];
    
    firstTimeLbl=[[UILabel alloc]initWithFrame:CGRectMake(185, 10, 60, 15)];
    if (self.profile1TimeValue==nil )
    {
        self.profile1TimeValue=@"0";
    }
    firstTimeLbl.text=[NSString stringWithFormat:@"%@ mins",self.profile1TimeValue];
    firstTimeLbl.textAlignment=NSTextAlignmentLeft;
    firstTimeLbl.textColor=[UIColor blackColor];
    firstTimeLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0f];
    [sunTimeVw addSubview:firstTimeLbl];
    
    
    UIImageView *blackTwoImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 15, 15)];
    blackTwoImgVw.image=[UIImage imageNamed:@"two-black.png"];
    [sunTimeVw addSubview:blackTwoImgVw];
    
    UIImageView *secondSunImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 25, 25)];
    secondSunImgVw.image=[UIImage imageNamed:@"sun.png"];
    [sunTimeVw addSubview:secondSunImgVw];
    
    secondBrightnessLbl=[[UILabel alloc]initWithFrame:CGRectMake(80, 45, 40, 15)];
    if (self.profile2BrightnessValue==nil )
    {
        self.profile2BrightnessValue=@"0";
    }
    secondBrightnessLbl.text=[NSString stringWithFormat:@"%@%%",self.profile2BrightnessValue];
    secondBrightnessLbl.textAlignment=NSTextAlignmentLeft;
    secondBrightnessLbl.textColor=[UIColor blackColor];
    secondBrightnessLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0f];
    [sunTimeVw addSubview:secondBrightnessLbl];
    
    UIImageView *secondWatchImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(140, 40, 27, 30)];
    secondWatchImgVw.image=[UIImage imageNamed:@"alarm.png"];
    [sunTimeVw addSubview:secondWatchImgVw];
    
    secondTimeLbl=[[UILabel alloc]initWithFrame:CGRectMake(185, 45, 60, 15)];

    if (self.profile2TimeValue==nil )
    {
        self.profile2TimeValue=@"0";
    }
    if (self.profile2TimeValue==nil )
    {
        self.profile2TimeValue=@"0";
    }
    secondTimeLbl.text=[NSString stringWithFormat:@"%@ mins",self.profile2TimeValue];
    secondTimeLbl.textAlignment=NSTextAlignmentLeft;
    secondTimeLbl.textColor=[UIColor blackColor];
    secondTimeLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0f];
    [sunTimeVw addSubview:secondTimeLbl];
    
    UIButton *settingBtn=[[UIButton alloc]initWithFrame:CGRectMake(sunTimeVw.frame.size.width-60, sunTimeVw.frame.size.height/2-35/2, 35, 35)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [sunTimeVw addSubview:settingBtn];
    
    [settingBtn addTarget:self action:@selector(ClkOnSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showLightLevelAdjustVw
{
    UIView *lightLevelAdjustVw=[[UIView alloc]initWithFrame:CGRectMake(0, profileScrollVw.frame.size.height/2.5 + 85, profileScrollVw.frame.size.width, 40)];
    lightLevelAdjustVw.backgroundColor=[UIColor whiteColor];
    [profileScrollVw addSubview:lightLevelAdjustVw];
    
    lightLevelAdjustLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 15)];
    lightLevelAdjustLbl.text=NSLocalizedString(@"CONSTANTS_LIGHT_LEVEL", nil);
    lightLevelAdjustLbl.textAlignment=NSTextAlignmentLeft;
    lightLevelAdjustLbl.textColor=[UIColor blackColor];
    lightLevelAdjustLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [lightLevelAdjustVw addSubview:lightLevelAdjustLbl];
    
    lightLevelAdjustValueLbl=[[UILabel alloc]initWithFrame:CGRectMake(170, 10, 30, 15)];
    lightLevelAdjustValueLbl.textAlignment=NSTextAlignmentLeft;
    lightLevelAdjustValueLbl.textColor=[UIColor blackColor];
    lightLevelAdjustValueLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [lightLevelAdjustVw addSubview:lightLevelAdjustValueLbl];
    
    lightLevelAdjustStepper=[[UIStepper alloc]init];
    lightLevelAdjustStepper.frame=CGRectMake(lightLevelAdjustVw.frame.size.width-100, 5, 80, 20);
    lightLevelAdjustStepper.maximumValue=4000;
    lightLevelAdjustStepper.minimumValue=0;
    lightLevelAdjustStepper.stepValue=1;
    lightLevelAdjustStepper.value=[lightLevelAdjustValueLbl.text intValue];
    [lightLevelAdjustStepper addTarget:self action:@selector(stepperOneChanged:) forControlEvents:UIControlEventValueChanged];
    [lightLevelAdjustVw addSubview:lightLevelAdjustStepper];
}

- (void)stepperOneChanged:(UIStepper*)stepper
{
    lightLevelAdjustValueLbl.text=[NSString stringWithFormat:@"%d",(int)stepper.value];
    photocellValue = [lightLevelAdjustValueLbl.text intValue];
    [self storeValuesToControllerImage];
    [self updateSyncButton];
}
-(void)showSaveProfileVw
{
    saveProfileVw=[[UIView alloc]initWithFrame:CGRectMake(0, profileScrollVw.frame.size.height/2.5 + 130, profileScrollVw.frame.size.width, 95)];
    saveProfileVw.backgroundColor=[UIColor whiteColor];
    [profileScrollVw addSubview:saveProfileVw];
    
    UILabel *absenceModeLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 15)];
    absenceModeLbl.text=NSLocalizedString(@"ABSENCE_MODE", nil);
    absenceModeLbl.textAlignment=NSTextAlignmentLeft;
    absenceModeLbl.textColor=[UIColor blackColor];
    absenceModeLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [saveProfileVw addSubview:absenceModeLbl];
    
    
    absenceSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(90, 2, 30, 10)];
    [saveProfileVw addSubview:absenceSwitch];
    [absenceSwitch setOn:YES animated:YES];
    [absenceSwitch addTarget:self action:@selector(changeAbsenceSwitch:) forControlEvents:UIControlEventValueChanged];
    absenceSwitch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
    
    UIButton *brightOutInfoBtn=[[UIButton alloc]initWithFrame:CGRectMake(8, 47, 20, 20)];
    [brightOutInfoBtn setBackgroundImage:[UIImage imageNamed:@"i-icon.png"] forState:UIControlStateNormal];
    [saveProfileVw addSubview:brightOutInfoBtn];
    [brightOutInfoBtn addTarget:self action:@selector(clkOnbrightOutInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    isShowinfo=FALSE;
    UILabel *brightOutLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 50, 60, 15)];
    brightOutLbl.text=NSLocalizedString(@"BRIGHT_OUT", nil);
    brightOutLbl.textAlignment=NSTextAlignmentLeft;
    brightOutLbl.textColor=[UIColor blackColor];
    brightOutLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [saveProfileVw addSubview:brightOutLbl];
    
    brightOutSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(90, 42, 30, 10)];
    [saveProfileVw addSubview:brightOutSwitch];
    brightOutSwitch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
    [brightOutSwitch addTarget:self action:@selector(changeBrightOutSwitch:) forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *constantLightLbl=[[UILabel alloc]initWithFrame:CGRectMake(saveProfileVw.frame.size.width/2, 10, 80, 15)];
    constantLightLbl.text=NSLocalizedString(@"CONSTANT_LIGHT", nil);
    constantLightLbl.textAlignment=NSTextAlignmentLeft;
    constantLightLbl.textColor=[UIColor blackColor];
    constantLightLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [saveProfileVw addSubview:constantLightLbl];
    
    constantLightSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(saveProfileVw.frame.size.width/2+80+5, 2, 30, 10)];
    [saveProfileVw addSubview:constantLightSwitch];
    
    [constantLightSwitch addTarget:self action:@selector(changeConstantLightSwitch:) forControlEvents:UIControlEventValueChanged];
    constantLightSwitch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
    
    [self setConstantLightFlyOutVw];
    
    UIButton *saveprofileBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveprofileBtn.frame=CGRectMake(saveProfileVw.frame.size.width-120, 45, 100, 30);
    [saveProfileVw addSubview:saveprofileBtn];
    [saveprofileBtn setTitle:@"Save File" forState:UIControlStateNormal];
    [saveprofileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveprofileBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0f];
    [saveprofileBtn addTarget:self action:@selector(clkOnSaveProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveprofileBtn setBackgroundImage:[UIImage imageNamed:@"blue-btn.png"] forState:UIControlStateNormal];
}
- (void)clkOnSaveProfileBtn:(id)sender
{
    timerMax[0]=[firstTimeLbl.text intValue];
    
    if ([secondTimeLbl.text isEqualToString:@"Infinity"]) {
        timerMax[1]=241;
    }
    else{
        timerMax[1]=[secondTimeLbl.text intValue];
    }
    
    if ([firstBrighnessLbl.text isEqualToString:@"CL"]) {
        dimLevel[0]=[self.profile1BrightnessValue intValue];
    }
    else{
        dimLevel[0]=[firstBrighnessLbl.text intValue];
    }
    dimLevel[1]=[secondBrightnessLbl.text intValue];
    absenceEnable=absenceSwitch.on;
    brightOutEnable=brightOutSwitch.on;
    constantLightEnable=constantLightSwitch.on;
    
    
    [self storeValuesToControllerImage];
    [self performSegueWithIdentifier:@"toProfileNameView" sender:self];
}
- (void)changeBrightOutSwitch:(id)sender
{
    brightOutEnable = brightOutSwitch.on;
    [self storeValuesToControllerImage];
    [self updateSyncButton];
     [self updateGui];
}
- (void)changeAbsenceSwitch:(id)sender
{
    absenceEnable = absenceSwitch.on;
    
    [self storeValuesToControllerImage];
    [self updateSyncButton];
    [self updateGui];
}

- (void)changeConstantLightSwitch:(id)sender
{
    if (constantLightSwitch.isOn)
    {
        firstBrighnessLbl.text=@"CL";
      // old 6/10  constantLightFlyOutVw.hidden=NO;
        constantLightFlyOutVw.hidden=YES;
        [self performSelector:@selector(hideConstantLightFlyOutVw) withObject:nil afterDelay:5];
    }
    else{
        constantLightFlyOutVw.hidden=YES;
        firstBrighnessLbl.text=[NSString stringWithFormat:@"%@%%",self.profile1BrightnessValue];
    }
    secondBrightnessLbl.text=[NSString stringWithFormat:@"%@%%",self.profile2BrightnessValue];
    constantLightEnable = constantLightSwitch.on;
    [self storeValuesToControllerImage];
    [self updateSyncButton];
     [self updateGui];
}
-(void)hideConstantLightFlyOutVw{
    constantLightFlyOutVw.hidden= YES;
}
-(void)setConstantLightFlyOutVw
{
    constantLightFlyOutVw=[[UIView alloc]initWithFrame:CGRectMake(profileScrollVw.frame.size.width-170, profileScrollVw.frame.size.height-168, 155, 45)];
    [profileScrollVw addSubview:constantLightFlyOutVw];
    constantLightFlyOutVw.backgroundColor=[UIColor whiteColor];
    constantLightFlyOutVw.layer.borderWidth=1.0;
    constantLightFlyOutVw.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    UILabel *constantLightFlyoutTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(2, 4, 150, 40)];
    constantLightFlyoutTextLbl.text=@"Set The Constant light Level on Status Page";
    
    constantLightFlyoutTextLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0f];
    [constantLightFlyOutVw addSubview:constantLightFlyoutTextLbl];
    constantLightFlyoutTextLbl.numberOfLines=0;
    constantLightFlyoutTextLbl.lineBreakMode=NSLineBreakByWordWrapping;
    constantLightFlyoutTextLbl.textAlignment=NSTextAlignmentCenter;
    
    constantLightFlyOutVw.hidden=YES;
    
}
- (void)clkOnbrightOutInfoBtn:(id)sender
{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:nil message:@"Bright-out stops lights being automatically turned on if ambient light is above the constant light level. Please set up constant light first. Not available in Absence Mode" delegate:self cancelButtonTitle:nil otherButtonTitles: NSLocalizedString(@"OK", nil), nil];
    
    [alertDialog show];
//    if (!isShowinfo) {
//        isShowinfo=YES;
//        infoVw=[[UIView alloc]initWithFrame:CGRectMake(5, 2, 170, 40)];
//        infoVw.backgroundColor=[UIColor whiteColor];
//        [saveProfileVw addSubview:infoVw];
//        
//        infoVw.layer.borderColor=[UIColor lightGrayColor].CGColor;
//        infoVw.layer.borderWidth=1.0f;
//        
//        UILabel *infoLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 40)];
//        infoLbl.text=@"Bright-out stops lights being automatically turned on if ambient light is above the constant light level. Please set up constant light first. Not available in Absence Mode";
//        [infoVw addSubview:infoLbl];
//        infoLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:8.5];
//        infoLbl.textAlignment=NSTextAlignmentCenter;
//        infoLbl.numberOfLines=0;
//        infoLbl.lineBreakMode=NSLineBreakByWordWrapping;
//        infoLbl.textColor=[UIColor blackColor];
//        
//        
//        
//        
//        
//    }
//    else{
//        isShowinfo=NO;
//        [infoVw removeFromSuperview];
//    }
}

#pragma  mark Show TimeOutVw
- (void)ClkOnSettingBtn:(id)sender
{
    [self setup2];
    profileScrollVw.hidden=YES;
   [self showEditTimeOut];
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"PRO_ALL_BACK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clkOnbackBtn:)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
    self.navigationItem.hidesBackButton=YES;
    //self.navigationItem.rightBarButtonItem=nil;
}
- (void)clkOnbackBtn:(id)sender
{
    [self doneWithNumberPad];
    timers[0]=self.profile1TimeValue;
    firstTimeLbl.text=[NSString stringWithFormat:@"%@ mins",self.profile1TimeValue];
    
    if ([self.profile2TimeValue isEqualToString:@"Infinity"]) {
        timers[1]=241;
        secondTimeLbl.text=[NSString stringWithFormat:@"%@",self.profile2TimeValue];
    }
    else
    {
        timers[1]=self.profile2TimeValue;
        secondTimeLbl.text=[NSString stringWithFormat:@"%@ mins",self.profile2TimeValue];
    }

    NSLog(@"%@",self.profile1BrightnessValue);
    NSLog(@"%@",firstBrighnessLbl.text);
    if ([firstBrighnessLbl.text isEqualToString:@"CL"]) {
        levels[0]=firstBrighnessLbl.text;
    }
    else{
         levels[0]=self.profile1BrightnessValue;
        firstBrighnessLbl.text=[NSString stringWithFormat:@"%@%%",self.profile1BrightnessValue];
    }
   
    levels[1]=self.profile2BrightnessValue;
    secondBrightnessLbl.text=[NSString stringWithFormat:@"%@%%",self.profile2BrightnessValue];
    
    editTimeScrollVw.hidden=YES;
    profileScrollVw.hidden=NO;
    [self showGeneralProfileHeaderVw];
    [self storeValuesToControllerImageWithEditTimeOut];
    
    [super viewDidAppear:YES];
    
}
-(void)showeditTimeoutHeaderVw
{
    
    titlelbl.text=NSLocalizedString(@"EDIT_TIMEOUTS", nil);
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(clkOnBackBtnOfEditTimeOut:)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
    self.navigationItem.hidesBackButton=YES;
   // self.navigationItem.rightBarButtonItem=nil;
 
}

-(void)showEditTimeOut
{
    [self showeditTimeoutHeaderVw];
    editTimeScrollVw=[[UIScrollView alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, self.view.frame.size.height)];
    NSLog(@"%f",self.view.frame.size.height);
    self.automaticallyAdjustsScrollViewInsets=NO;
    [_profileMainVw addSubview:editTimeScrollVw];
    
    UIView *graphVw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, editTimeScrollVw.frame.size.width, editTimeScrollVw.frame.size.height/2.5)];
    graphVw.backgroundColor=[UIColor whiteColor];
    [editTimeScrollVw addSubview:graphVw];
    
    UIImageView *graphImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-60, graphVw.frame.size.height - (graphVw.frame.size.height/4 - 10))];
    graphImgVw.image=[UIImage imageNamed:@"profilegraph.png"]; 
    [graphVw addSubview:graphImgVw];
    
    [self showOnlevelView];
    [self showOccupancyTimeOutView];
    [self showPowerSaveVw];
    [self showTransitionTimeoutVw];
    [self showDoneBtnOnKeyPad];
}
#pragma mark OnLevel View
-(void)showOnlevelView
{
    
    NSLog(@"%@",self.profile1BrightnessValue);
    NSLog(@"sdsdsd:---%f",editTimeScrollVw.frame.size.height/2.5 + 5);
    UIView *onLevelVw=[[UIView alloc]initWithFrame:CGRectMake(0, editTimeScrollVw.frame.size.height/2.5 + 5, editTimeScrollVw.frame.size.width, 70)];
    onLevelVw.backgroundColor=[UIColor whiteColor];
    [editTimeScrollVw addSubview:onLevelVw];
    
    onlevelLbl=[[UILabel alloc]initWithFrame:CGRectMake(onLevelVw.frame.size.width/2-50, 5, 50, 30)];
    onlevelLbl.text=[NSString stringWithFormat:NSLocalizedString(@"ON_LEVEL", nil)];
    onlevelLbl.textAlignment=NSTextAlignmentCenter;
    onlevelLbl.textColor=[UIColor blackColor];
    onlevelLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [onLevelVw addSubview:onlevelLbl];
    
    onLevelTF=[[UITextField alloc]initWithFrame:CGRectMake(onLevelVw.frame.size.width/2-50+55, 7, 50, 25)];
    [onLevelVw addSubview:onLevelTF];
    onLevelTF.borderStyle = UITextBorderStyleRoundedRect;
    onLevelTF.autocorrectionType = UITextAutocorrectionTypeNo;
    onLevelTF.delegate=self;
    
    
    
    onLevelTF.text=[NSString stringWithFormat:@"%@",self.profile1BrightnessValue];
    onLevelTF.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    onLevelTF.textAlignment=NSTextAlignmentCenter;
    onLevelTF.keyboardType=UIKeyboardTypeNumberPad;
    onLevelTF.tag=1;
    
    UILabel *onLvlRgtVwLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 25)];
    onLvlRgtVwLbl.text=@"%";
    onLvlRgtVwLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    onLevelTF.rightViewMode=UITextFieldViewModeAlways;
    onLevelTF.rightView=onLvlRgtVwLbl;
    
    onLevelSlider=[[UISlider alloc]initWithFrame:CGRectMake(40, 30, onLevelVw.frame.size.width-80, 25)];
    [onLevelVw addSubview:onLevelSlider];
    [onLevelSlider addTarget:self action:@selector(onLevelsliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    onLevelSlider.minimumValue=0.0;
    onLevelSlider.maximumValue=11.0;
    if ([self.profile1BrightnessValue isEqualToString:@"100"]) {
        [onLevelSlider setValue:11.0];
    }
    else{
        [onLevelSlider setValue:([self.profile1BrightnessValue floatValue]-0.5)/9];
    }
    UIImageView *lowBrighnessImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 25, 25)];
    lowBrighnessImgVw.image=[UIImage imageNamed:@"light-sun.png"];
    [onLevelVw addSubview:lowBrighnessImgVw];
    
    UIImageView *highBrighnessImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(onLevelVw.frame.size.width-35, 27, 30, 30)];
    highBrighnessImgVw.image=[UIImage imageNamed:@"sun.png"];
    [onLevelVw addSubview:highBrighnessImgVw];
    
    UIImageView *profile1ImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(50, 5, 15, 15)];
    profile1ImgVw.image=[UIImage imageNamed:@"light1.png"];
    [onLevelVw addSubview:profile1ImgVw];
    
    
//    if ([self.profile1BrightnessValue isEqualToString:@"CL"])
//    {
//        onLevelSlider.enabled=false;
//    }
//    else
//    {
//        self.profile1BrightnessValue=[firstBrighnessLbl.text substringToIndex:[firstBrighnessLbl.text length] - 1];
//        onLevelSlider.enabled=true;
//    }
    
    
    if ([firstBrighnessLbl.text isEqualToString:@"CL"])
    {
        onLevelSlider.enabled=false;
        onLevelTF.enabled=false;
    }
    else{
        onLevelSlider.enabled=true;
        onLevelTF.enabled=true;
    }
    
    
}
- (IBAction)onLevelsliderValueChanged:(UISlider *)sender {
    
    int sliderValue = (ceil(sender.value*9 - 0.5f)+1 );  // To get 1 - 10 slider with equal spacing.
    onLevelTF.text=[NSString stringWithFormat:@"%ld", (long)sliderValue];
    self.profile1BrightnessValue=[NSString stringWithFormat:@"%ld", (long)sliderValue];
}
#pragma mark Occupancy Timeout View
-(void)showOccupancyTimeOutView
{
    UIView *occupancyTimeOutVw=[[UIView alloc]initWithFrame:CGRectMake(0, editTimeScrollVw.frame.size.height/2.5 + 80, editTimeScrollVw.frame.size.width, 75)];
    occupancyTimeOutVw.backgroundColor=[UIColor whiteColor];
    [editTimeScrollVw addSubview:occupancyTimeOutVw];
    
    occupancyTimeOutLbl=[[UILabel alloc]initWithFrame:CGRectMake(occupancyTimeOutVw.frame.size.width/2-70, 5, 100, 30)];
    occupancyTimeOutLbl.text=[NSString stringWithFormat:@"Occupancy Timeout :"];
    occupancyTimeOutLbl.textAlignment=NSTextAlignmentCenter;
    occupancyTimeOutLbl.textColor=[UIColor blackColor];
    occupancyTimeOutLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [occupancyTimeOutVw addSubview:occupancyTimeOutLbl];
    
    
    occupancyTimeOutTF=[[UITextField alloc]initWithFrame:CGRectMake(occupancyTimeOutVw.frame.size.width/2-70+105, 7, 70, 25)];
    
    [occupancyTimeOutVw addSubview:occupancyTimeOutTF];
    occupancyTimeOutTF.borderStyle = UITextBorderStyleRoundedRect;
    occupancyTimeOutTF.autocorrectionType = UITextAutocorrectionTypeNo;
    occupancyTimeOutTF.delegate=self;
    
    self.profile1TimeValue=[firstTimeLbl.text substringToIndex:[firstTimeLbl.text length] - 5];
    occupancyTimeOutTF.text=[NSString stringWithFormat:@"%@",self.profile1TimeValue];
    occupancyTimeOutTF.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    occupancyTimeOutTF.textAlignment=NSTextAlignmentCenter;
    occupancyTimeOutTF.keyboardType=UIKeyboardTypeNumberPad;
    occupancyTimeOutTF.tag=2;
    
    UILabel *occupancyTimeOutRgtVwLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    occupancyTimeOutRgtVwLbl.text=@"mins";
    occupancyTimeOutRgtVwLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    occupancyTimeOutTF.rightViewMode=UITextFieldViewModeAlways;
    occupancyTimeOutTF.rightView=occupancyTimeOutRgtVwLbl;
    
    
    occupancyTimeOutSlider=[[UISlider alloc]initWithFrame:CGRectMake(40, 30, occupancyTimeOutVw.frame.size.width-80, 30)];
    [occupancyTimeOutVw addSubview:occupancyTimeOutSlider];
    [occupancyTimeOutSlider addTarget:self action:@selector(occupancyTimeOutsliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    occupancyTimeOutSlider.minimumValue=0.0;
    occupancyTimeOutSlider.maximumValue=6.6;
    
    UIImageView *timerGrayImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(10, 27, 27, 30)];
    timerGrayImgVw.image=[UIImage imageNamed:@"timer-gray.png"];
    [occupancyTimeOutVw addSubview:timerGrayImgVw];
    
    occupancytimerBlueImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(occupancyTimeOutVw.frame.size.width-35, 27, 27, 30)];
    
    [occupancyTimeOutVw addSubview:occupancytimerBlueImgVw];
    [occupancyTimeOutSlider setValue:([_profile1TimeValue floatValue]-0.5)/9];
    occupancytimerBlueImgVw.image=[UIImage imageNamed:@"timer-blue.png"];
    
    UIImageView *profile1ImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(50, 5, 15, 15)];
    profile1ImgVw.image=[UIImage imageNamed:@"light1.png"];
    [occupancyTimeOutVw addSubview:profile1ImgVw];
}
- (IBAction)occupancyTimeOutsliderValueChanged:(UISlider *)sender {
    
    // int sliderValue = (ceil(sender.value*9 - 0.5f)+1 )*10;  // To get 1 - 10 slider with equal spacing.
    int sliderValue = ceil(sender.value*9 + 0.5 );
    
    occupancyTimeOutLbl.text = [NSString stringWithFormat:@"Occupancy Timeout :"];
    occupancyTimeOutTF.text=[NSString stringWithFormat:@"%ld", (long)sliderValue];
    occupancytimerBlueImgVw.image=[UIImage imageNamed:@"timer-blue.png"];
    self.profile1TimeValue=[NSString stringWithFormat:@"%ld", (long)sliderValue];
}
#pragma mark Power Save View
-(void)showPowerSaveVw
{
    UIView *powerSaveVw=[[UIView alloc]initWithFrame:CGRectMake(0, editTimeScrollVw.frame.size.height/2.5 + 160, editTimeScrollVw.frame.size.width, 70)];
    powerSaveVw.backgroundColor=[UIColor whiteColor];
    [editTimeScrollVw addSubview:powerSaveVw];
    
    powerSaveLbl=[[UILabel alloc]initWithFrame:CGRectMake(powerSaveVw.frame.size.width/2-80, 5, 120, 30)];
    powerSaveLbl.text=[NSString stringWithFormat:NSLocalizedString(@"POWER_SAVE_LIGHT_LEVEL", nil)];
    powerSaveLbl.textAlignment=NSTextAlignmentCenter;
    powerSaveLbl.textColor=[UIColor blackColor];
    powerSaveLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [powerSaveVw addSubview:powerSaveLbl];
    
    
    powerSaveTF=[[UITextField alloc]initWithFrame:CGRectMake(powerSaveVw.frame.size.width/2-80+125, 7, 50, 25)];
    [powerSaveVw addSubview:powerSaveTF];
    powerSaveTF.borderStyle = UITextBorderStyleRoundedRect;
    powerSaveTF.autocorrectionType = UITextAutocorrectionTypeNo;
    powerSaveTF.delegate=self;
   
    powerSaveTF.text=[NSString stringWithFormat:@"%@",self.profile2BrightnessValue];
    powerSaveTF.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    powerSaveTF.textAlignment=NSTextAlignmentCenter;
    powerSaveTF.keyboardType=UIKeyboardTypeNumberPad;
    powerSaveTF.tag=3;
    
    UILabel *powerSaveRgtVwLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 25)];
    powerSaveRgtVwLbl.text=@"%";
    powerSaveRgtVwLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    powerSaveTF.rightViewMode=UITextFieldViewModeAlways;
    powerSaveTF.rightView=powerSaveRgtVwLbl;
    
    powerSaveSlider=[[UISlider alloc]initWithFrame:CGRectMake(40, 30, powerSaveVw.frame.size.width-80, 30)];
    [powerSaveVw addSubview:powerSaveSlider];
    [powerSaveSlider addTarget:self action:@selector(powerSaveSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [powerSaveSlider setValue:0.4];
    powerSaveSlider.minimumValue=-0.1;
    powerSaveSlider.maximumValue=11.0;
    if ([_profile2BrightnessValue isEqualToString:@"100"]) {
        [powerSaveSlider setValue:11.0];
    }
    else{
        [powerSaveSlider setValue:([_profile2BrightnessValue floatValue]-0.5)/9];
    }
    UIImageView *lowBrighnessImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 25, 25)];
    lowBrighnessImgVw.image=[UIImage imageNamed:@"light-sun.png"];
    [powerSaveVw addSubview:lowBrighnessImgVw];
    
    UIImageView *highBrighnessImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(powerSaveVw.frame.size.width-35, 27, 30, 30)];
    highBrighnessImgVw.image=[UIImage imageNamed:@"sun.png"];
    [powerSaveVw addSubview:highBrighnessImgVw];
    
    UIImageView *profile2ImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(50, 5, 15, 15)];
    profile2ImgVw.image=[UIImage imageNamed:@"light2.png"];
    [powerSaveVw addSubview:profile2ImgVw];
    self.profile2BrightnessValue=[secondBrightnessLbl.text substringToIndex:[secondBrightnessLbl.text length] - 1];
    powerSaveSlider.enabled=true;
    
}
- (IBAction)powerSaveSliderValueChanged:(UISlider *)sender {
    
    int sliderValue = (ceil(sender.value*9 - 0.5f)+1 );  // To get 1 - 10 slider with equal spacing.
    self.profile2BrightnessValue=[NSString stringWithFormat:@"%ld", (long)sliderValue];
    powerSaveTF.text=[NSString stringWithFormat:@"%ld", (long)sliderValue];
}
#pragma mark Transition Timeout View
-(void)showTransitionTimeoutVw
{
    UIView *transitionTimeOutVw=[[UIView alloc]initWithFrame:CGRectMake(0, editTimeScrollVw.frame.size.height/2.5 + 235, editTimeScrollVw.frame.size.width, 75)];
    transitionTimeOutVw.backgroundColor=[UIColor whiteColor];
    [editTimeScrollVw addSubview:transitionTimeOutVw];
    if (self.view.frame.size.height<568) {
        editTimeScrollVw.contentSize=CGSizeMake(editTimeScrollVw.frame.size.width, 525);
    }
    transitionTimeOutLbl=[[UILabel alloc]initWithFrame:CGRectMake(transitionTimeOutVw.frame.size.width/2-70, 2, 100, 30)];
    transitionTimeOutLbl.text=[NSString stringWithFormat:NSLocalizedString(@"TRANSITION_TIMEOUT", nil)];
    transitionTimeOutLbl.textAlignment=NSTextAlignmentCenter;
    transitionTimeOutLbl.textColor=[UIColor blackColor];
    transitionTimeOutLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [transitionTimeOutVw addSubview:transitionTimeOutLbl];
    
    transitionTimeOutTF=[[UITextField alloc]initWithFrame:CGRectMake(transitionTimeOutVw.frame.size.width/2-70+105, 4, 70, 25)];
    [transitionTimeOutVw addSubview:transitionTimeOutTF];
    transitionTimeOutTF.borderStyle = UITextBorderStyleRoundedRect;
    transitionTimeOutTF.autocorrectionType = UITextAutocorrectionTypeNo;
    transitionTimeOutTF.delegate=self;
    if ([secondTimeLbl.text isEqualToString:@"Infinity"]) {
        self.profile2TimeValue=[secondTimeLbl.text substringToIndex:[secondTimeLbl.text length]];
    }
    else{
       self.profile2TimeValue=[secondTimeLbl.text substringToIndex:[secondTimeLbl.text length] - 5];
    }
    
    transitionTimeOutTF.text=[NSString stringWithFormat:@"%@",self.profile2TimeValue];
    transitionTimeOutTF.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    transitionTimeOutTF.textAlignment=NSTextAlignmentCenter;
    transitionTimeOutTF.keyboardType=UIKeyboardTypeNumberPad;
    transitionTimeOutTF.tag=4;
    
    UILabel *transitionTimeOutRgtVwLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    transitionTimeOutRgtVwLbl.text=@"mins";
    transitionTimeOutRgtVwLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    transitionTimeOutTF.rightViewMode=UITextFieldViewModeAlways;
    transitionTimeOutTF.rightView=transitionTimeOutRgtVwLbl;
    
    
    transitionTimeOutSlider=[[UISlider alloc]initWithFrame:CGRectMake(40, 25, transitionTimeOutVw.frame.size.width-80, 30)];
    [transitionTimeOutVw addSubview:transitionTimeOutSlider];
    [transitionTimeOutSlider addTarget:self action:@selector(transitionTimeOutsliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    transitionTimeOutSlider.minimumValue=-0.1;
    transitionTimeOutSlider.maximumValue=28.0;
    
    UIImageView *timerGrayImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(10, 27, 27, 30)];
    timerGrayImgVw.image=[UIImage imageNamed:@"timer-gray.png"];
    [transitionTimeOutVw addSubview:timerGrayImgVw];
    
    transitionTimerBlueImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(transitionTimeOutVw.frame.size.width-35, 27, 27, 30)];
    [transitionTimeOutVw addSubview:transitionTimerBlueImgVw];
    
    if ([_profile2TimeValue isEqualToString:@"Infinity"]) {
        [transitionTimeOutSlider setValue:28.0];
        transitionTimerBlueImgVw.image=[UIImage imageNamed:@"timer-red.png"];
    }
    else{
        [transitionTimeOutSlider setValue:([_profile2TimeValue floatValue]-0.5)/9];
        transitionTimerBlueImgVw.image=[UIImage imageNamed:@"timer-blue.png"];
    }
    
    UIImageView *profile2ImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(50, 5, 15, 15)];
    profile2ImgVw.image=[UIImage imageNamed:@"light2.png"];
   
    [transitionTimeOutVw addSubview:profile2ImgVw];
    
}
- (IBAction)transitionTimeOutsliderValueChanged:(UISlider *)sender {
    
    int sliderValue = (ceil(sender.value*9 - 0.5f)+1 );  // To get 1 - 10 slider with equal spacing.
    
    if (sliderValue>240)
    {
        transitionTimeOutLbl.text = [NSString stringWithFormat:@"Transition Timeout :"];
        transitionTimeOutTF.text=@"Infinity";
        transitionTimerBlueImgVw.image=[UIImage imageNamed:@"timer-red.png"];
        self.profile2TimeValue=@"Infinity";
    }
    else
    {
        transitionTimeOutLbl.text  = [NSString stringWithFormat:@"Transition Timeout:"];
        transitionTimeOutTF.text=[NSString stringWithFormat:@"%ld", (long)sliderValue];
        transitionTimerBlueImgVw.image=[UIImage imageNamed:@"timer-blue.png"];
        self.profile2TimeValue=[NSString stringWithFormat:@"%ld",(long)sliderValue];
    }
}
-(void)showDoneBtnOnKeyPad
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    onLevelTF.inputAccessoryView = numberToolbar;
    occupancyTimeOutTF.inputAccessoryView=numberToolbar;
    powerSaveTF.inputAccessoryView=numberToolbar;
    transitionTimeOutTF.inputAccessoryView=numberToolbar;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setViewMovedUp:NO];
    if (textField.tag==1)
    {
        if ([textField.text floatValue]<1 || [textField.text floatValue]>100) {
            UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Invalid Data"
                                                               message:@"Please Enter data in range 1-100"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            
            [alertMsg show];
            onLevelTF.text=@"1";
        }
        else{
            [onLevelSlider setValue:([onLevelTF.text floatValue]-0.5)/9];
        }
        self.profile1BrightnessValue=[NSString stringWithFormat:@"%ld",[onLevelTF.text integerValue]];
        
    }
    else if (textField.tag==2)
    {
        
        if ([textField.text floatValue]<1 || [textField.text floatValue]>60) {
            UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Invalid Data"
                                                               message:@"Please Enter data in range 1-60"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            
            [alertMsg show];
            occupancyTimeOutTF.text=@"1";
        }
        else{
            [occupancyTimeOutSlider setValue:([occupancyTimeOutTF.text floatValue]-0.5)/9];
        }
        self.profile1TimeValue=[NSString stringWithFormat:@"%ld",[occupancyTimeOutTF.text integerValue]];
        
    }
    else if (textField.tag==3)
    {
        if ([textField.text floatValue]<0 || [textField.text floatValue]>100) {
            UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Invalid Data"
                                                               message:@"Please Enter data in range 0-100"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            
            [alertMsg show];
            powerSaveTF.text=@"0";
        }
        else{
            [powerSaveSlider setValue:([powerSaveTF.text floatValue]-0.5)/9];
        }
        self.profile2BrightnessValue=[NSString stringWithFormat:@"%ld",[powerSaveTF.text integerValue]];
    }
    else if (textField.tag==4)
    {
        if ([transitionTimeOutTF.text floatValue] >240.0) {
            [transitionTimeOutSlider setValue:28.0];
            transitionTimerBlueImgVw.image=[UIImage imageNamed:@"timer-red.png"];
            transitionTimeOutTF.text=@"Infinity";
            self.profile2TimeValue=@"Infinity";
        }
        else{
            [transitionTimeOutSlider setValue:([transitionTimeOutTF.text floatValue]-0.5)/9];
            transitionTimerBlueImgVw.image=[UIImage imageNamed:@"timer-blue.png"];
            self.profile2TimeValue=[NSString stringWithFormat:@"%ld",[transitionTimeOutTF.text integerValue]];
        }
    }
}
- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    
    [self storeValuesToControllerImage];
    selectedProfile = segment.selectedSegmentIndex;
    [self loadValuesFromControllerImage];
    [self updateGui];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setViewMovedUp:YES];
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}
-(void)doneWithNumberPad
{
    [onLevelTF resignFirstResponder];
    [occupancyTimeOutTF resignFirstResponder];
    [powerSaveTF resignFirstResponder];
    [transitionTimeOutTF resignFirstResponder];
}


- (void)viewDidUnload
{
    [self setTimer1Label:nil];
    [self setTimer2Label:nil];
    [self setTimer3Label:nil];
    [self setLevel1BrightnessLabel:nil];
    [self setLevel2BrightnessLevel:nil];
    [self setLevel3BrightnessLevel:nil];
    [self setAbsenceSettingSwitch:nil];
    [self setLinkingSwitch:nil];
    [self setHarvestSwitch:nil];
    [self setPhotocellLabel:nil];
    [self setPhotocellStepper:nil];
    [self setProfileSegmentedControl:nil];
    [self setSyncButton:nil];
    [self setSaveProfileButton:nil];
    [self setHideAllView:nil];
    [timer invalidate];
    [self setTimer:nil];
    [self setDsiDaliSwitch:nil];
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    [self setTimer:nil];
    [self storeValuesToControllerImage];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    selectedProfile = appDelegate.activeProfileOnStatusScreen;
    [self setParentVC:(iPhoneTabBarController *)[[self parentViewController] parentViewController]];
    if ((parentVC.offline == NO) && (parentVC.readAllDLCSettings == NO))
    {
        [self.view bringSubviewToFront:hideAllView];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerExpired) userInfo:nil repeats:YES];
    }
    else
    {
        [self showProfileInfo];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    //appDelegate.selectedProfile=selectedProfile;
}
- (void)timerExpired
{
    if ((parentVC.offline == YES) || (parentVC.readAllDLCSettings == YES)) 
    {
        [timer invalidate];
        [self setTimer:nil];
        
        if ((parentVC.readAllDLCSettings == YES) && ([parentVC passwordOK] == NO))
        {
            parentVC.offline = YES;
            [controller initialiseControllerData];
        }
        
        [self showProfileInfo];
    }
}

- (void)showProfileInfo
{
    [self.view sendSubviewToBack:hideAllView];
    
    [self loadValuesFromControllerImage];
    profileSegmentedControl1.selectedSegmentIndex = selectedProfile;
    
    [self updateGui];
    [self updateSyncButton];
}

-(void)updateGui
{
    absenceSwitch.on=absenceEnable;
    brightOutSwitch.on=brightOutEnable;
    constantLightSwitch.on=constantLightEnable;
    lightLevelAdjustValueLbl.text=[[NSString alloc] initWithFormat:@"%lu", photocellValue];
    lightLevelAdjustStepper.value=photocellValue;
    
    firstTimeLbl.text=[[NSString alloc] initWithFormat:@"%02d mins", timerMax[0]];
    
    if (timerMax[1]>=241) {
        secondTimeLbl.text=[[NSString alloc] initWithFormat:@"Infinity"];
    }
    else{
        secondTimeLbl.text=[[NSString alloc] initWithFormat:@"%02d mins", timerMax[1]];
    }
    
    
   
    if (constantLightSwitch.on==true && absenceSwitch.on==false) {
      // old 6/10  brightOutSwitch.enabled=true;
        //new
brightOutSwitch.enabled=true;
    }
    else{
        
        brightOutSwitch.enabled=false;
        brightOutSwitch.on=false;
        brightOutEnable=brightOutSwitch.on;
    }
    if (constantLightSwitch.on==true)
    {
        firstBrighnessLbl.text=@"CL";
    }
    else{
        firstBrighnessLbl.text=[[NSString alloc] initWithFormat:@"%02d %%", dimLevel[0]];
        
        self.profile1BrightnessValue=[firstBrighnessLbl.text substringToIndex:[firstBrighnessLbl.text length] - 1];
        
    }
    secondBrightnessLbl.text=[[NSString alloc] initWithFormat:@"%02d %%", dimLevel[1]];
    self.profile2BrightnessValue=[secondBrightnessLbl.text substringToIndex:[secondBrightnessLbl.text length] - 1];
    
     [self.view setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self storeValuesToControllerImage];
    
    if ([[segue identifier] isEqualToString:@"toTimersView"])
    {
        ((iPhoneTimersViewController *)segue.destinationViewController).delegate = self;
        ((iPhoneTimersViewController *)segue.destinationViewController).selectedProfile =(int) selectedProfile;
    }
    else if ([[segue identifier] isEqualToString:@"toProfileNameView"])
    {
        ((iPhoneProfileNameViewController *)segue.destinationViewController).delegate = self;
        ((iPhoneProfileNameViewController *)segue.destinationViewController).callingScreen = kProfileScreen;
    }
    else if ([[segue identifier] isEqualToString:@"toLinkView"])
    {
        ((iPhoneLinkViewController *)segue.destinationViewController).delegate = self;
        ((iPhoneLinkViewController *)segue.destinationViewController).selectedProfile =(int) selectedProfile;
    }
}

- (void)viewTimers
{
    [self performSegueWithIdentifier:@"toTimersView" sender:self];
}

- (IBAction)saveProfile:(id)sender 
{
    [self performSegueWithIdentifier:@"toProfileNameView" sender:self];
}

- (IBAction)writeProfileToController:(id)sender 
{
    [self storeValuesToControllerImage];
    [parentVC writeProfileSettings];
    [self updateSyncButton];
}

-(void)updateSyncButton
{
    if ([controller userChangedSettings])
        self.navigationItem.rightBarButtonItems[1].enabled=YES;
    else
        self.navigationItem.rightBarButtonItems[1].enabled=NO;
    
    if (parentVC.offline == YES)
        self.navigationItem.rightBarButtonItems[1].enabled=NO;
}

- (void)setup
{
    [self setupDefaults];
    [self setupOverflowItems];
    [self setupOverflowButton];
    [self handleOverflowBlocks];
}

- (void)setupDefaults
{
    
    
}

- (void)setupOverflowItems
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    
    ASJOverflowItem *item = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"helpprofile"];
    
    [temp addObject:item];
    NSLog(@"%@", temp);
    _overflowItems = [NSArray arrayWithArray:temp];
}

- (void)setupOverflowButton
{
    UIImage *image = [UIImage imageNamed:@"Menuright"];
    
    _overflowButton = [[ASJOverflowButton alloc] initWithImage:image items:_overflowItems];
    _overflowButton.dimsBackground = YES;
    _overflowButton.hidesSeparator = NO;
    _overflowButton.hidesShadow = NO;
    _overflowButton.dimmingLevel = 0.3f;
    _overflowButton.menuItemHeight = 30.0f;
    _overflowButton.widthMultiplier = 0.5f;
    _overflowButton.itemHighlightedColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    _overflowButton.menuMargins = MenuMarginsMake(7.0f, 7.0f, 7.0f);
    _overflowButton.separatorInsets = SeparatorInsetsMake(10.0f, 5.0f);
    _overflowButton.menuAnimationType = MenuAnimationTypeZoomIn;
    _overflowButton.itemFont = [UIFont fontWithName:@"Verdana" size:13.0f];
    
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sync.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clkOnSyncBtnOfGeneralprofileSetting:)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_overflowButton,rightBarBtn,nil];
    self.navigationItem.rightBarButtonItems[1].enabled=NO;
    // self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks
{
    
    
    [_overflowButton setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx)
     {
         if([item.titlecheck  isEqual: @"helpprofile"]){
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"Profile_Settings_Help";
             theTabBar.tempTitle = @"Profile Setting Help";
             [self.navigationController pushViewController:theTabBar animated:YES];
         }else{
             
         }
     }];
    
    [_overflowButton setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}

- (void)setup2
{
    [self setupDefaults2];
    [self setupOverflowItems2];
    [self setupOverflowButton2];
    [self handleOverflowBlocks2];
}

- (void)setupDefaults2
{
    
    
}

- (void)setupOverflowItems2
{
    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
    
    
    ASJOverflowItem *item2 = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"timeOutEdit"];
    
    [temp2 addObject:item2];
    NSLog(@"%@", temp2);
    _overflowItems2 = [NSArray arrayWithArray:temp2];
}

- (void)setupOverflowButton2
{
    UIImage *image = [UIImage imageNamed:@"Menuright"];
    
    _overflowButton2 = [[ASJOverflowButton alloc] initWithImage:image items:_overflowItems2];
    _overflowButton2.dimsBackground = YES;
    _overflowButton2.hidesSeparator = NO;
    _overflowButton2.hidesShadow = NO;
    _overflowButton2.dimmingLevel = 0.3f;
    _overflowButton2.menuItemHeight = 30.0f;
    _overflowButton2.widthMultiplier = 0.5f;
    _overflowButton2.itemHighlightedColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    _overflowButton2.menuMargins = MenuMarginsMake(7.0f, 7.0f, 7.0f);
    _overflowButton2.separatorInsets = SeparatorInsetsMake(10.0f, 5.0f);
    _overflowButton2.menuAnimationType = MenuAnimationTypeZoomIn;
    _overflowButton2.itemFont = [UIFont fontWithName:@"Verdana" size:13.0f];
    
    
    
    
    
    self.navigationItem.rightBarButtonItem = _overflowButton2;
    //self.navigationItem.rightBarButtonItem.enabled=NO;
    // self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks2
{
    
    
    [_overflowButton2 setItemTapBlock:^(ASJOverflowItem *item2, NSInteger idx)
     {
         if([item2.titlecheck  isEqual: @"timeOutEdit"]){
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"Edit_Timeouts_Help";
             theTabBar.tempTitle = @"Edit Timeouts Help";
             [self.navigationController pushViewController:theTabBar animated:YES];
         }else{
             
         }
     }];
    
    [_overflowButton2 setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}


@end
