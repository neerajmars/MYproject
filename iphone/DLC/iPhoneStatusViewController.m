//
//  iPhoneStatusViewController.m
//  iDimOrbit
//
//  Created by mr Ankit on 24/07/2016.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "iPhoneStatusViewController.h"
#import "iPhoneTabBarController.h"
#import "ASJOverflowButton.h"
#import "webViewController.h"

@interface iPhoneStatusViewController ()
{
    UIView *scrollVw;
    SensorView *sensorVw;
    UIView *showlightSensorInfoVw;
    UILabel *titlelbl;
}

@property (strong, nonatomic) ASJOverflowButton *overflowButton;
@property (strong, nonatomic) ASJOverflowButton *overflowButton2;
@property (copy, nonatomic) NSArray *overflowItems;
@property (copy, nonatomic) NSArray *overflowItems2;
@property (strong, nonatomic) ASJOverflowButton *overflowButton3;
@property (copy, nonatomic) NSArray *overflowItems3;
@property (strong, nonatomic) ASJOverflowButton *overflowButton4;
@property (copy, nonatomic) NSArray *overflowItems4;
@property (strong, nonatomic) ASJOverflowButton *overflowButton5;
@property (copy, nonatomic) NSArray *overflowItems5;
- (void)setup;
- (void)setupDefaults;
- (void)setupOverflowItems;
- (void)setupOverflowButton;
- (void)handleOverflowBlocks;


@end

@implementation iPhoneStatusViewController
@synthesize timerValueLabel;
@synthesize activeProfileLabel;
@synthesize timerStageImage;
@synthesize lightLevelImage;
@synthesize PIRImage;
@synthesize pirStatusSensorImgVw;
@synthesize timer;
@synthesize schedulerImgVw;
@synthesize targetLevelSensorImgVw;
@synthesize pirSettingBtn;

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
    //
    // use for all right button 
    [self setup];
   
	// Do any additional setup after loading the view.
    onOffStrings = [NSArray arrayWithObjects: NSLocalizedString(@"STATUS_OFF", nil), NSLocalizedString(@"STATUS_ON", nil), nil];

    timerStageImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"small0.png"], [UIImage imageNamed:@"small1.png"], [UIImage imageNamed:@"small2.png"], [UIImage imageNamed:@"timerE.png"],nil];
    
   // lightLevelImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"PIR_off.png"], [UIImage imageNamed:@"PIR_green.png"], [UIImage imageNamed:@"PIR_off.png"], nil];
    
    PIRImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"PIR_red.png"], [UIImage imageNamed:@"PIR_green.png"], [UIImage imageNamed:@"PIR_green.png"],nil];
    
     LED_FlashImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"LEDFlashRed.png"], [UIImage imageNamed:@"LEDFlashGreen.png"], [UIImage imageNamed:@"LEDFlashRed.png"],nil];
    timerStatus=0;
    
    dimLevelValueA=MIN_DIMLEVEL_VALUE;
    dimLevelValueB=MIN_DIMLEVEL_VALUE;
   
    
   // titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.titleView = titlelbl;
    titlelbl.textAlignment=NSTextAlignmentCenter;
    [self LiveStatusHeaderVw];
  //  [self showlightSensorFlyOutInfo];
    
   // 9f3880e4858797d4bb22b966cb3a99cf1bef46ec
    
    
    
}
-(void)LiveStatusHeaderVw
{
    //titlelbl.text=@"Live Status";
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sync.png"] style:UIBarButtonItemStylePlain target:self action:@selector(ClkOnSyncBtnOnStatus:)];
   // self.navigationItem.rightBarButtonItem=rightBarBtn;
    
    UIBarButtonItem * leftBarBtnItm = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helvarLogo.png"]]];
    
    UIBarButtonItem * leftBarBtnItm1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helvarLogo.png"]]];
    
    UIBarButtonItem * leftBarBtnItm2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(ClkOnSyncBtnOnStatus :)];
    
    
    self.navigationItem.leftBarButtonItem = leftBarBtnItm;
//    self.navigationItem.leftItemsSupplementBackButton = YES;
//    self.navigationItem.leftBarButtonItems = @[leftBarBtnItm1,leftBarBtnItm2];
    
    self.navigationItem.hidesBackButton=YES;
   // self.navigationItem.rightBarButtonItem.enabled=NO;
    
}
- (IBAction)ClkOnSyncBtnOnStatus:(UIButton *)sender
{
    [self writeUpdatedValue];
    self.navigationItem.rightBarButtonItems[1].enabled=NO;
}

- (void)viewDidUnload
{
  
    [self setTimerValueLabel:nil];
    [self setActiveProfileLabel:nil];
    [self setTimerStageImage:nil];
    [self setLightLevelImage:nil];
    [self setPIRImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self.timer invalidate];
    [self setTimer:nil];
    timerStageImages = nil;
   // lightLevelImages = nil;
    PIRImages = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setParentVC:(iPhoneTabBarController *)[[self parentViewController] parentViewController]];
    
        lightsDebounceCounter = 4;
        dimLevelDebounceCounterA = 5;
        dimLevelDebounceCounterB = 5;
        _setConstantLightBtn.enabled = YES;
        _setConstantLightBtn.alpha = 1.0;
        
        [self updateAll];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerExpired) userInfo:nil repeats:YES];
        _walkTestSwitch.on=false;
    modalNameSTR=[parentVC getmodelNumberString];
    NSLog(@"MDlSTR=%@",modalNameSTR);
  //  modalNameSTR=@"OB-1101";
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
   // ...... appDelegate.activeProfileOnStatusScreen......
    

//    selectedProfile=appDelegate.selectedProfile;
    
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    // These function for Live Status Subscreens......
    [self loadValuesFromControllerImage];
    [self functionForDALIchannel2ManualStepperControlerEnabled];
    [self functionForRelayManualSwitchControlerEnabled];
    
    [self showDaliChannel1SettingVw];
    [scrollVw removeFromSuperview];
    [self showDaliChannel2SettingVw];
    [scrollVw removeFromSuperview];
    [self showRelayChannel3SettingVw];
    [scrollVw removeFromSuperview];
    [self LiveStatusHeaderVw];
}

- (void)viewWillDisappear:(BOOL)animated
{
   
    [self.timer invalidate];
    timer = nil;
    [scrollVw removeFromSuperview];
     [sensorVw removeFromSuperview];
    _mainVw.hidden=NO;
}

- (void)timerExpired
{
    // After suitable delay, make manual override switch match light status
    if ([controller getRelayStatus] != _relayChannelSwitch.on)
    {
        if (lightsDebounceCounter < 10)
            lightsDebounceCounter++;
        
        if (lightsDebounceCounter > 4)
        {
             _relayChannelSwitch.on = [controller getRelayStatus];
            [self.view setNeedsDisplay];
            lightsDebounceCounter = 0;
            
        }
    }
    if (dimLevelDebounceCounterA <= 5)
        dimLevelDebounceCounterA++;
    if (dimLevelDebounceCounterB <= 5)
        dimLevelDebounceCounterB++;
    
    if (dimLevelDebounceCounterA == 5)
    {
        [super setDimLevelOverrideToA:dimLevelValueA];
    }
    if (dimLevelDebounceCounterB == 5)
    {
        [super setDimLevelOverrideToB:dimLevelValueB];
    }

    
    // Re-enable calibration button after couple of seconds.
    if (++calibrationDebounceCounter == 4)
    {
        calibrationDebounceCounter = 4;
        _setConstantLightBtn.enabled = YES;
        _setConstantLightBtn.alpha = 1.0;
    }
    if (parentVC.newStatusReceived == true)
    {
        [self updateAll];
        parentVC.newStatusReceived = false;
    }
}

- (void)updateAll
{
   // [self updateDimmingFormat];
    [self updateActiveProfile];
    if (dimLevelDebounceCounterA > 5)
    {
        [self updateBrightnessForA];
    }
    else
    {
        [self updateDimLevelStepperValueForA];
    }

    if (dimLevelDebounceCounterB > 5)
    {
        [self updateBrightnessForB];
    }
    else
    {
        [self updateDimLevelStepperValueForB];
    }
   // [self updateTargetLevel];
    [self updateRelayStatus];
    [self updateLux];
    [self updatePIRStatusForSensors];
    [self updateWalkTestStatus];
    [self updateTimerStage];
   
}
-(void)updateWalkTestStatus
{
    walkTestEnable=[controller getWalkTestStatus];
    if (walkTestEnable==0) {
        _walkTestSwitch.on=false;
    }
    else{
        _walkTestSwitch.on=true;
    }
}
- (void)updateDimLevelStepperValueForA
{
        _daliChannel1ValueLbl.text=[[NSString alloc] initWithFormat:@"%d%%", dimLevelValueA];
        _dali1Stepper.value=dimLevelValueA;
//    _daliChannel1ValueLbl.textColor=[UIColor blackColor];
}
- (void)updateDimLevelStepperValueForB
{
        _daliChannel2ValueLbl.text=[[NSString alloc] initWithFormat:@"%d%%", dimLevelValueB];
        _dali2Stepper.value=dimLevelValueB;
//    _daliChannel2ValueLbl.textColor=[UIColor blackColor];
}

- (void)updateBrightnessForA
{
    unsigned char brightness = [controller getDimmingLevelA];
    if (brightness > MAX_PERCENT)
    {
        brightness = MAX_PERCENT;
    }
    dimLevelValueA = brightness;
    _daliChannel1ValueLbl.text=[[NSString alloc] initWithFormat:@"%d%%", brightness];
    _dali1Stepper.value=dimLevelValueA;
    _daliChannel1ValueLbl.textColor=[UIColor blackColor];
}
- (void)updateBrightnessForB
{
    unsigned char brightness = [controller getDimmingLevelB];
    if (brightness > MAX_PERCENT)
    {
        brightness = MAX_PERCENT;
    }
    dimLevelValueB = brightness;
    _daliChannel2ValueLbl.text=[[NSString alloc] initWithFormat:@"%d%%", brightness];
    _dali2Stepper.value=dimLevelValueB;
    _daliChannel2ValueLbl.textColor=[UIColor blackColor];
    
}
//- (void)updateDimmingFormat
//{
//    if ([controller getModelNumber] == (kDLC100 + 1))
//    {
//        _dali1Stepper.enabled = NO;
//        _dali1Stepper.alpha = 0.4;
//        _daliChannel1ValueLbl.textColor = [UIColor lightGrayColor];
//        _dali2Stepper.enabled = NO;
//        _dali2Stepper.alpha = 0.4;
//        _daliChannel2ValueLbl.textColor = [UIColor lightGrayColor];
//    }
//    else
//    {
//        _dali1Stepper.enabled = YES;
//        _dali1Stepper.alpha = 1.0;
//        _daliChannel1ValueLbl.textColor = [UIColor blackColor];
//        _dali2Stepper.enabled = YES;
//        _dali2Stepper.alpha = 1.0;
//        _daliChannel2ValueLbl.textColor = [UIColor blackColor];
//    }
//
//    Switch dimmingFormat = [controller getDimmingFormat];
//    //TODO: Revisit once more models in
//    if (dimmingFormat > 1)
//    {
//        dimmingFormat = 1;
//    }
//}
- (void)updateRelayStatus
{
    Switch relayStatus = [controller getRelayStatus];
    _relayChannelValueLbl.text=[onOffStrings objectAtIndex:relayStatus];
    if ([_relayChannelValueLbl.text isEqualToString:@"ON"])
    {
        [_relayChannelSwitch setOn:YES animated:YES];
    }
    else
    {
        [_relayChannelSwitch setOn:NO animated:YES];
    }
}
- (void)updateActiveProfile
{
    Profile activeProfile = [controller getActiveProfile];
 //  Profile activeProfile =1;
    appDelegate.activeProfileOnStatusScreen=activeProfile;
    if (activeProfile > NUM_PROFILES)
    {
        activeProfile = NUM_PROFILES;
    }
    
    activeProfileLabel.text = [[NSString alloc] initWithFormat:@"Profile %d",(activeProfile + 1)];
    if ([activeProfileLabel.text isEqualToString:@"Profile 1"]) {
        schedulerImgVw.image=[UIImage imageNamed:@"cal.png"];
    }
    else{
        schedulerImgVw.image=[UIImage imageNamed:@"cal2.png"];
    }
}

- (void)updateTimerStage
{
    unsigned char timerValue = [controller getTimerValue];
    Stage timerStage = [controller getTimerStage];
    if (timerStage > NUM_STAGES)
    {
        timerStage = NUM_STAGES;
    }
    if (timerValue == 0)
    {
        timerStage = 0;
    }
    if (timerValue > MAX_TIMER_MINS)
    {
        timerValue = MAX_TIMER_MINS;
    }
    timerStageImage.image = [timerStageImages objectAtIndex:timerStage];
    if (timerStatus==0) {
         timerValueLabel.text = [[NSString alloc] initWithFormat:@"%d mins", timerValue];
    }
    else if (timerStatus==1)
    {
         timerValueLabel.text = [[NSString alloc] initWithFormat:@"%d Sec", timerValue];
        if (timerStage==2 && timerValue==1) {
            timerStatus=0;
            timerValueLabel.text = [[NSString alloc] initWithFormat:@"%d mins", timerValue];
        }
    }
    if (!_walkTestSwitch.on)
    {
        timerValueLabel.text = [[NSString alloc] initWithFormat:@"%d mins", timerValue];
    }
}
//- (void)updateTargetLevel
//{
//    unsigned char lightLevel = [controller getLightLevel];
//    NSLog(@"%d",NUM_LIGHT_LEVELS);
//    
//    if (lightLevel > NUM_LIGHT_LEVELS)
//    {
//        lightLevel = NUM_LIGHT_LEVELS-1;
//    }
//    targetLevelSensorImgVw.image = [lightLevelImages objectAtIndex:lightLevel];
//}

- (void)updateLux
{
    long lux = [controller getLuxLevel];
    if (lux > MAX_PHOTOCELL_VALUE)
    {
        lux = MAX_PHOTOCELL_VALUE;
    }
    _lightLevelValueLbl.text = [[NSString alloc] initWithFormat:@"%lu", lux];
    _lightLevelValueLbl.textAlignment=NSTextAlignmentCenter;
}

//-(void) updatePIRStatusForSensors
//{
//    PIRState PIRStatus = [controller getPIRState];
//    
//    NSLog(@"%d",PIRStatus);
//    
//    if (PIRStatus > NUM_PIR_STATES)
//    {
//        PIRStatus = NUM_PIR_STATES;
//    }
//    
//    pirStatusSensorImgVw.image = [PIRImages objectAtIndex:PIRStatus];
//  //  sensorVw.ledImgVw.image=[LED_FlashImages objectAtIndex:PIRStatus];
//}
-(void) updatePIRStatusForSensors
{
    NSMutableArray * pirTriggeredArray=[[NSMutableArray alloc]init];
    pirTriggeredArray = [controller getPIRState];
    NSLog(@"NSMutableArray:-%@",pirTriggeredArray);
   
    int PIRStatus=[[pirTriggeredArray objectAtIndex:0]intValue];
    PIRTriggeredValue=[[pirTriggeredArray objectAtIndex:1]intValue ];
    
    if (PIRStatus > NUM_PIR_STATES)
    {
        PIRStatus = NUM_PIR_STATES;
    }
    pirStatusSensorImgVw.image = [PIRImages objectAtIndex:PIRStatus];
    //  sensorVw.ledImgVw.image=[LED_FlashImages objectAtIndex:PIRStatus];
    
  //  [self updateSensorsOnPIRSetting];
}
//-(void)updateSensorsOnPIRSetting
//{
//    if (PIRTriggeredValue==0)
//    {
//        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
//    }
//    else if (PIRTriggeredValue==1)
//    {
//        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGreenSensor.png"] forState:UIControlStateNormal];
//    }
//    else if (PIRTriggeredValue==2)
//    {
//        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
//    }
//    else if (PIRTriggeredValue==4)
//    {
//        
//        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
//
//    }
//    else if (PIRTriggeredValue==8)
//    {
//        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
//    }
//    else if (PIRTriggeredValue==16)
//    {
//
//        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
//
//    }
//}


#pragma mark ALL Setting Button Actions....


- (IBAction)settingBtnAction:(id)sender
{

    [self setup2];
    
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"PRO_ALL_BACK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clkOnBackBtnOfDaliChannel1Setting:)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
   // self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
     [self showDaliChannel1SettingVw];
    _mainVw.hidden=YES;
    
//        NSMutableString *version = [NSMutableString string];
//        unsigned char msb = [controller getDLCFirmwareVersion:true];
//        unsigned char lsb = [controller getDLCFirmwareVersion:false];
//        [version appendFormat:@"%02d", msb];
//        [version appendFormat:@".%02d", lsb];
//        NSLog(@"Version=%@",version);
    
}

- (IBAction)settingBtnchannel2:(id)sender
{
    [self setup3];
    
    _mainVw.hidden=YES;
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"PRO_ALL_BACK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clkOnBackBtnOfDaliChannel2Setting:)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
    //self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    [self showDaliChannel2SettingVw];
}

- (IBAction)settingBtnrelayAction:(id)sender
{
    
     [self setup4];
    _mainVw.hidden=YES;
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"PRO_ALL_BACK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clkOnBackBtnOfrelayActionSetting:)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
   // self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    [self showRelayChannel3SettingVw];
}

- (IBAction)clkOnPirSettingBtn:(id)sender {
    
    [self setup5];
    
    _mainVw.hidden=YES;
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"PRO_ALL_BACK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clkOnBackBtnOfPirSetting:)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
   // self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    [self showSensorVw];
}
#pragma mark Dali Channel 1 Setting Vw
-(void)showDaliChannel1SettingVw
{
    
    [self loadValuesFromControllerImage];
    titlelbl.text=@"DALI Channel 1 Settings";
    scrollVw=[[UIScrollView alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, 200)];
    scrollVw.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:scrollVw];
    
    UILabel *switchHeadingLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-110, 50, 220, 20)];
    switchHeadingLbl.text=NSLocalizedString(@"STATUS_SWITCH_INPUT", nil);
    [scrollVw addSubview:switchHeadingLbl];
    switchHeadingLbl.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    
    
    daliChannel1singlePoleCheckboxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-80, 80, 20, 20)];
    [scrollVw addSubview:daliChannel1singlePoleCheckboxBtn];
    [daliChannel1singlePoleCheckboxBtn addTarget:self action:@selector(clkOnDaliChannel1singlePoleCheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *singlePoleCheckboxLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-150, 80, 220, 20)];
    singlePoleCheckboxLbl.text=NSLocalizedString(@"STATUS_SINGLE_POLE", nil);
    [scrollVw addSubview:singlePoleCheckboxLbl];
    
    
    daliChannel1doublePoleCheckboxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-80, 110, 20, 20)];
    [scrollVw addSubview:daliChannel1doublePoleCheckboxBtn];
    [daliChannel1doublePoleCheckboxBtn addTarget:self action:@selector(clkOnDaliChannel1doublePoleCheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *doublePoleCheckboxLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-150, 110, 220, 20)];
    doublePoleCheckboxLbl.text=NSLocalizedString(@"STATUS_DOUBLE_POLE", nil);
    [scrollVw addSubview:doublePoleCheckboxLbl];
    
    
    
    UIButton *daliChannel1ResetBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-80, 140, 160, 40)];
    [scrollVw addSubview:daliChannel1ResetBtn];
    [daliChannel1ResetBtn setBackgroundImage:[UIImage imageNamed:@"blue-btn.png"] forState:UIControlStateNormal];
    [daliChannel1ResetBtn setTitle:NSLocalizedString(@"DALI_RESET_1", nil) forState:UIControlStateNormal];
    [daliChannel1ResetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [daliChannel1ResetBtn addTarget:self action:@selector(clkOnDali1ResetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self updateForSinglePoleSwitch];
    
}
#pragma mark till here tablevw Delegate
-(void)updateForSinglePoleSwitch
{
    if (singlePoleSwitch==0 ) {
        [daliChannel1singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel1doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel2doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
    }
    else if (singlePoleSwitch==1)
    {
        [daliChannel1singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel1doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel2singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel2doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
    }
    else if (singlePoleSwitch==2)
    {
        [daliChannel1singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel1doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }else if (singlePoleSwitch==3)
    {
        [daliChannel1singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel1doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel2singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)clickONsensorBtn:(id)sender
{
//    if (showlightSensorInfoVw.hidden) {
//        showlightSensorInfoVw.hidden=NO;
//    }
//    else{
//        showlightSensorInfoVw.hidden=YES;
//    }
    
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:nil message:@"Shows the measured light level at the sensor. To be used in conjunction with a light meter on the working plane when setting Constant Light" delegate:self cancelButtonTitle:nil otherButtonTitles: NSLocalizedString(@"OK", nil), nil]; 
    
    [alertDialog show];
}
//- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
//{
//    showlightSensorInfoVw.hidden=YES;
//}

- (IBAction)daliChannel1StepperChanged:(id)sender
{
    UIStepper *stepper=(UIStepper*)sender;
    
    if (_daliChannel1ValueLbl.textColor == [UIColor redColor])
    {
        dimLevelValueA = stepper.value;
    }
    else // first touch (when showing brightness) only displays the current dim level value, not alter it
    {
        _daliChannel1ValueLbl.textColor = [UIColor redColor];
        dimLevelValueA = [controller getDimmingLevelA];
        stepper.value = dimLevelValueA;
    }
    if (dimLevelValueA > MAX_DIMLEVEL_VALUE)
    {
        dimLevelValueA = MAX_DIMLEVEL_VALUE;
    }
     _daliChannel1ValueLbl.text=[NSString stringWithFormat:@"%d%%",dimLevelValueA];
    stepper.value = dimLevelValueA;
    [self.view setNeedsDisplay];
    
    if (parentVC.selectedController != NO_CONTROLLER_CONNECTED)
    {
       // dimLevelDebounceCounter = 0;
        dimLevelDebounceCounterA = 0;
    }
}

- (IBAction)daliChannel2stepperChaged:(id)sender
{
    UIStepper *stepper=(UIStepper*)sender;
    if (_daliChannel2ValueLbl.textColor == [UIColor redColor])
    {
        dimLevelValueB = stepper.value;
    }
    else // first touch (when showing brightness) only displays the current dim level value, not alter it
    {
        _daliChannel2ValueLbl.textColor = [UIColor redColor];
        dimLevelValueB = [controller getDimmingLevelB];
        stepper.value = dimLevelValueB;
    }
    if (dimLevelValueB > MAX_DIMLEVEL_VALUE)
    {
        dimLevelValueB = MAX_DIMLEVEL_VALUE;
    }
    _daliChannel2ValueLbl.text=[NSString stringWithFormat:@"%d%%",dimLevelValueB];
    stepper.value = dimLevelValueB;
    [self.view setNeedsDisplay];
    
    if (parentVC.selectedController != NO_CONTROLLER_CONNECTED)
    {
       // dimLevelDebounceCounter = 0;
        dimLevelDebounceCounterB = 0;
    }
}

- (IBAction)clkOnSetConstantLgtBtn:(id)sender
{
    if (parentVC.selectedController != NO_CONTROLLER_CONNECTED)
    {
      //  [parentVC setCalibrateSensorForSelectedProfile:(int)appDelegate.activeProfileOnStatusScreen];
        
        [parentVC setCalibrateSensorForSelectedProfile:0];
        [parentVC setCalibrateSensorForSelectedProfile:1];
        _setConstantLightBtn.enabled = NO;
        _setConstantLightBtn.alpha = 0.4;
        calibrationDebounceCounter = 0;
    }
}

- (IBAction)relayChannel3SwitchValue:(id)sender
{
    if (parentVC.selectedController != NO_CONTROLLER_CONNECTED)
    {
    if (_relayChannelSwitch.isOn)
    {
        _relayChannelValueLbl.text=@"ON";
      //  dimLevelDebounceCounter = 5;
        dimLevelDebounceCounterA = 5;
        dimLevelDebounceCounterB = 5;
    }
    else{
        _relayChannelValueLbl.text=@"OFF";
    }
    [super setLightsTo:_relayChannelSwitch.on];
    lightsDebounceCounter = 0;
}
}

- (IBAction)walkTestSwitchValueChanged:(id)sender
{
    [super setWalkTestEnable:_walkTestSwitch.on];
    timerStatus=1;
}
//-(void)showlightSensorFlyOutInfo
//{
//    showlightSensorInfoVw=[[UIView alloc]initWithFrame:CGRectMake(20, 150, 150, 60)];
//    [self.mainVw addSubview:showlightSensorInfoVw];
//    showlightSensorInfoVw.backgroundColor=[UIColor whiteColor];
//    showlightSensorInfoVw.layer.borderWidth=1.0f;
//    showlightSensorInfoVw.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    UILabel *lightSensorInfoLbl=[[UILabel alloc]initWithFrame:CGRectMake(2, 0, 145, 60)];
//    lightSensorInfoLbl.text=@"Shows the measured light level at the sensor. To be used in conjunction with a light meter on the working plane when setting Constant Light";
//    lightSensorInfoLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
//    [showlightSensorInfoVw addSubview:lightSensorInfoLbl];
//    lightSensorInfoLbl.numberOfLines=0;
//    lightSensorInfoLbl.lineBreakMode=NSLineBreakByWordWrapping;
//    lightSensorInfoLbl.textAlignment=NSTextAlignmentCenter;
//    
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handleSingleTap:)];
//    [self.mainVw addGestureRecognizer:singleFingerTap];
//    showlightSensorInfoVw.hidden=YES;
//    
//   
//}


-(void)storePirValue
{
    if ([[daliChannel2PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]] && [[relayChannel3_PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]] )
    {
        pirEnableStatus=0;
    }
    else if ([[daliChannel2PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]] && [[relayChannel3_PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]] )
    {
        pirEnableStatus=1;
    }
    else if ([[daliChannel2PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]] && [[relayChannel3_PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]] )
    {
        pirEnableStatus=2;
    }
    else if ([[daliChannel2PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]] && [[relayChannel3_PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]] )
    {
        pirEnableStatus=3;
    }
    
 // for mimic setting..
    if ([[daliChannel2MimicChaneel1CheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]] ) {
        channelFunction=0;
    }
    else if ([[daliChannel2MimicChaneel1CheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]])
    {
        channelFunction=1;
    }
}
-(void)updateForPirValue
{
    if (pirEnableStatus==0)
    {
        [daliChannel2PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableStatus==1)
    {
        [daliChannel2PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableStatus==2)
    {
        [daliChannel2PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
       
    }
    else if (pirEnableStatus==3)
    {
        [daliChannel2PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
    }
}
-(void)updateForDaliChannel2Mimic
{
    if (channelFunction==0)
    {
        [daliChannel2MimicChaneel1CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        mimicChannelVw.hidden=YES;
    }
    else if (channelFunction==1)
    {
        [daliChannel2MimicChaneel1CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        mimicChannelVw.hidden=NO;
        
    }
    
    
    
    if (((pirEnableStatus==0 || pirEnableStatus==2) && channelFunction==0)) {
        [daliChannel2ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
    }
}
-(void)clkOnDali1ResetBtn:(UIButton *)sender
{
    UIAlertView *alertVw=[[UIAlertView alloc]initWithTitle:@"DALI Channel 1 Reset" message:@"Do you want to reset all DALI settings?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertVw show];
    alertVw.tag=100;
}
-(void)clkOnDali2ResetBtn:(UIButton *)sender
{
    UIAlertView *alertVw1=[[UIAlertView alloc]initWithTitle:@"DALI Channel 2 Reset" message:@"Do you want to reset all DALI settings?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertVw1 show];
    alertVw1.tag=101;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"])
    {
        if (alertView.tag==100)
        {
            [parentVC setDaliResetTo:1];
        }
        else if (alertView.tag==101)
        {
            [parentVC setDaliResetTo:2];
        }
        
    }
}


- (void)clkOnDaliChannel1singlePoleCheckboxBtn:(id)sender
{
    if ([[daliChannel1singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [daliChannel1singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel1doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        
    }
//    else
//    {
//        [daliChannel1singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//        [daliChannel1doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
//    }
}
- (void)clkOnDaliChannel1doublePoleCheckboxBtn:(id)sender
{
    if ([[daliChannel1doublePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [daliChannel1doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel1singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
//    else
//    {
//        [daliChannel1doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//        [daliChannel1singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
//    }
}

-(void)setValueForSinglePoleSwitch
{
    if ([[daliChannel1singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]] && [[daliChannel2singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]])
    {
        singlePoleSwitch=3;
    }
    else if ([[daliChannel1singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]] && [[daliChannel2singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        singlePoleSwitch=1;
    }
    else if ([[daliChannel1singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]] && [[daliChannel2singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]])
    {
        singlePoleSwitch=2;
    }
    else if ([[daliChannel1singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]] && [[daliChannel2singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        singlePoleSwitch=0;
    }
}

#pragma mark Back Button Of Dali Channel1 Setting..
- (void)clkOnBackBtnOfDaliChannel1Setting:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self setValueForSinglePoleSwitch];
    [self storeValuesToControllerImage];
    [scrollVw removeFromSuperview];
    _mainVw.hidden=NO;
    [self LiveStatusHeaderVw];
    [self setup];
    [self functionForCheckChanges];
}
#pragma mark Dali Channel 2 Setting Vw

-(void)showDaliChannel2SettingVw
{
    NSMutableArray *temp1 = [[NSMutableArray alloc] init];
    
    
    ASJOverflowItem *item1 = [ASJOverflowItem itemWithName:@"help" titlecheck:@"DALI2"];
    
    [temp1 addObject:item1];
    NSLog(@"%@", temp1);
    _overflowItems = [NSArray arrayWithArray:temp1];
    
    [self loadValuesFromControllerImage];
    titlelbl.text=@"DALI Channel 2 Settings";
    scrollVw=[[UIScrollView alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, 335)];
    scrollVw.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:scrollVw];
    
    UILabel *switchHeadingLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-110, 20, 220, 20)];
    switchHeadingLbl.text=NSLocalizedString(@"STATUS_SWITCH_INPUT", nil);
    [scrollVw addSubview:switchHeadingLbl];
    switchHeadingLbl.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    
    
    
    
    daliChannel2singlePoleCheckboxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-60, 50, 20, 20)];
    [scrollVw addSubview:daliChannel2singlePoleCheckboxBtn];
    [daliChannel2singlePoleCheckboxBtn addTarget:self action:@selector(clkOndaliChannel2singlePoleCheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *singlePoleCheckboxLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-150, 50, 220, 20)];
    singlePoleCheckboxLbl.text=NSLocalizedString(@"STATUS_SINGLE_POLE", nil);
    [scrollVw addSubview:singlePoleCheckboxLbl];

    daliChannel2doublePoleCheckboxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-60, 80, 20, 20)];
    [scrollVw addSubview:daliChannel2doublePoleCheckboxBtn];
    [daliChannel2doublePoleCheckboxBtn addTarget:self action:@selector(clkOndaliChannel2doublePoleCheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *doublePoleCheckboxLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-150, 80, 220, 20)];
    doublePoleCheckboxLbl.text=NSLocalizedString(@"STATUS_DOUBLE_POLE", nil);
    [scrollVw addSubview:doublePoleCheckboxLbl];
    
    UILabel *outputHeadingLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-110, 120, 150, 20)];
    outputHeadingLbl.text = NSLocalizedString(@"STATUS_OUTPUT_SETTING",nil);
    [scrollVw addSubview:outputHeadingLbl];
    outputHeadingLbl.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    
    
    daliChannel2ManualControlCheckBoxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-60, 150, 20, 20)];
    [scrollVw addSubview:daliChannel2ManualControlCheckBoxBtn];
     [daliChannel2ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    [daliChannel2ManualControlCheckBoxBtn addTarget:self action:@selector(clkOnDaliChannel2ManualControlCheckBoxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *daliChannel2ManualControlLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-140, 150, 240, 20)];
    daliChannel2ManualControlLbl.text=NSLocalizedString(@"MANUAL_CONTORL_ONLY",nil);
    [scrollVw addSubview:daliChannel2ManualControlLbl];
    
    
    daliChannel2PirCheckBoxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-60, 180, 20, 20)];
    [scrollVw addSubview:daliChannel2PirCheckBoxBtn];
    [daliChannel2PirCheckBoxBtn addTarget:self action:@selector(clkOnDaliChannel2PirCheckBoxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *pirLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-140, 180, 220, 20)];
    pirLbl.text=NSLocalizedString(@"PIR_TIMER_MANUAL",nil);
    [scrollVw addSubview:pirLbl];

    UILabel *mimicChannel1CheckboxLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-140, 210, 220, 20)];
    mimicChannel1CheckboxLbl.text=NSLocalizedString(@"MIMIC_CHANNEL_1",nil);;
    [scrollVw addSubview:mimicChannel1CheckboxLbl];
    
    daliChannel2MimicChaneel1CheckboxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-60, 210, 20, 20)];
    [scrollVw addSubview:daliChannel2MimicChaneel1CheckboxBtn];
    [daliChannel2MimicChaneel1CheckboxBtn addTarget:self action:@selector(clkOndaliChannel2MimicChaneel1CheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    [self showMimicChannel1SliderVw];
    
    UIButton *daliChannel2ResetBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-60, 285, 160, 40)];
    [scrollVw addSubview:daliChannel2ResetBtn];
    [daliChannel2ResetBtn setBackgroundImage:[UIImage imageNamed:@"blue-btn.png"] forState:UIControlStateNormal];
    [daliChannel2ResetBtn setTitle:NSLocalizedString(@"DALI_RESET_2",nil) forState:UIControlStateNormal];
    [daliChannel2ResetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [daliChannel2ResetBtn addTarget:self action:@selector(clkOnDali2ResetBtn:) forControlEvents:UIControlEventTouchUpInside];
   [self updateForSinglePoleSwitch];
    [self updateForPirValue];
    
    [self updateForDaliChannel2Mimic];

}

-(void)showMimicChannel1SliderVw
{
    mimicChannelVw=[[UIView alloc]initWithFrame:CGRectMake(5, 235, scrollVw.frame.size.width-10, 30)];
    [scrollVw addSubview:mimicChannelVw];
    mimicChannel1Slider=[[UISlider alloc]initWithFrame:CGRectMake(30, 20, mimicChannelVw.frame.size.width-60, 20)];
    [mimicChannelVw addSubview:mimicChannel1Slider];
    [mimicChannel1Slider addTarget:self action:@selector(mimicChannel1SliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    mimicChannel1Slider.minimumValue=-0.1;
    mimicChannel1Slider.maximumValue=21.9;
    [mimicChannel1Slider setValue:((dimOffsetValue + 98.5f)/9)];
    
    UILabel *lowOffsetlbl=[[UILabel alloc]initWithFrame:CGRectMake(5, 32, 50, 20)];
    lowOffsetlbl.text=@"-99%";
    [mimicChannelVw addSubview:lowOffsetlbl];
    
    lowOffsetlbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    
    UILabel *highOffsetLbl=[[UILabel alloc]initWithFrame:CGRectMake(mimicChannelVw.frame.size.width-40, 32, 50, 20)];
    highOffsetLbl.text=@"+99%";
    [mimicChannelVw addSubview:highOffsetLbl];
    highOffsetLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    
    offsetValueLbl=[[UILabel alloc]initWithFrame:CGRectMake(mimicChannelVw.frame.size.width/2-50, 0, 100, 15)];
    offsetValueLbl.text=[NSString stringWithFormat:@"Value :%d%%",dimOffsetValue];
    
    [mimicChannelVw addSubview:offsetValueLbl];
    offsetValueLbl.font=[UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    offsetValueLbl.textAlignment=NSTextAlignmentCenter;

}
#pragma mark DALI channel 2 checkboxes Functions
- (void)clkOndaliChannel2singlePoleCheckboxBtn:(id)sender
{
    if ([[daliChannel2singlePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [daliChannel2singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        singlePoleSwitch=2;
    }
//    else
//    {
//        [daliChannel2singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//        [daliChannel2doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
//    }
}
- (void)clkOndaliChannel2doublePoleCheckboxBtn:(id)sender
{
    if ([[daliChannel2doublePoleCheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [daliChannel2doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
//    else
//    {
//        [daliChannel2doublePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//        [daliChannel2singlePoleCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
//        
//    }
}
- (void)clkOnDaliChannel2ManualControlCheckBoxBtn:(id)sender
{
    if ([[daliChannel2ManualControlCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [daliChannel2ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel2MimicChaneel1CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        channelFunction=0;
        mimicChannelVw.hidden=YES;
        
    }
//    else
//    {
//        [daliChannel2ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//    }
}
- (void)clkOnDaliChannel2PirCheckBoxBtn:(id)sender
{
    if ([[daliChannel2PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [daliChannel2PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2MimicChaneel1CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel2ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        mimicChannelVw.hidden=YES;
    }
//    else
//    {
//        [daliChannel2PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//    }
}

- (void)clkOndaliChannel2MimicChaneel1CheckboxBtn:(id)sender
{
    if ([[daliChannel2MimicChaneel1CheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [daliChannel2MimicChaneel1CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [daliChannel2PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [daliChannel2ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        mimicChannelVw.hidden=NO;
   } 
//    else
//    {
//        [daliChannel2MimicChaneel1CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//        mimicChannelVw.hidden=YES;
//    }
}
#pragma mark Back Button Of Dali Channel 2 Setting..
- (void)clkOnBackBtnOfDaliChannel2Setting:(id)sender
{
    [self setValueForSinglePoleSwitch];
    [self storePirValue];
    [self storeValuesToControllerImage];
    [scrollVw removeFromSuperview];
    _mainVw.hidden=NO;
    [self LiveStatusHeaderVw];
    [self functionForCheckChanges];
    [self functionForDALIchannel2ManualStepperControlerEnabled];
    
}

#pragma mark Relay Channel 3 Setting Vw
-(void)showRelayChannel3SettingVw
{
   [self loadValuesFromControllerImage];
    titlelbl.text=@"Relay Channel 3 Settings";
    scrollVw=[[UIScrollView alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, 220)];
    scrollVw.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:scrollVw];
    
    relayChannel3_ManualControlCheckBoxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-80, 40, 20, 20)];
    [scrollVw addSubview:relayChannel3_ManualControlCheckBoxBtn];
     [relayChannel3_ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
      [relayChannel3_ManualControlCheckBoxBtn addTarget:self action:@selector(clkOnrelayChannel3_ManualControlCheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *relayChannel3ManualControlLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-120, 40, 160, 20)];
    relayChannel3ManualControlLbl.text=NSLocalizedString(@"MANUAL_CONTORL_ONLY",nil);
    [scrollVw addSubview:relayChannel3ManualControlLbl];
    
    relayChannel3_PirCheckBoxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-80, 70, 20, 20)];
    [scrollVw addSubview:relayChannel3_PirCheckBoxBtn];
    [relayChannel3_PirCheckBoxBtn addTarget:self action:@selector(clkOnrelayChannel3_pirCheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *relayChannel3_PirCheckboxLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-120, 70, 140, 20)];
    relayChannel3_PirCheckboxLbl.text=NSLocalizedString(@"PIR_TIMER_MANUAL",nil);
    [scrollVw addSubview:relayChannel3_PirCheckboxLbl];
    
    relayChannel3_DaliPowerSaveMode_CheckboxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-80, 100, 20, 20)];
    [scrollVw addSubview:relayChannel3_DaliPowerSaveMode_CheckboxBtn];
    [relayChannel3_DaliPowerSaveMode_CheckboxBtn addTarget:self action:@selector(clkOnrelayChannel3DaliPowerSaveModeCheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *relayChannel3DaliPowerSaveModeCheckboxLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-120, 100, 190, 20)];
    relayChannel3DaliPowerSaveModeCheckboxLbl.text=NSLocalizedString(@"DALI_POWER_SAVE_MODE",nil);
    [scrollVw addSubview:relayChannel3DaliPowerSaveModeCheckboxLbl];
    
    
    relayChannel3_TimeClock_CheckboxBtn=[[UIButton alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width-80, 130, 20, 20)];
    [scrollVw addSubview:relayChannel3_TimeClock_CheckboxBtn];
    [relayChannel3_TimeClock_CheckboxBtn addTarget:self action:@selector(clkOnrelayChannel3_TimeClock_CheckboxBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *relayChannel3_TimeClock_CheckboxLbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-120, 130, 180, 20)];
    relayChannel3_TimeClock_CheckboxLbl.text=NSLocalizedString(@"TIME_CLOCK_CONTROL",nil);
    [scrollVw addSubview:relayChannel3_TimeClock_CheckboxLbl];
    
    
    UILabel *relayChannel3Profile1Lbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-140, 175, 70, 20)];
    relayChannel3Profile1Lbl.text=NSLocalizedString(@"PROFILE_1_SEG",nil);
    [scrollVw addSubview:relayChannel3Profile1Lbl];
    
    relayChannel3Profile1Switch=[[UISwitch alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2-70, 170, 0, 0)];
    [scrollVw addSubview:relayChannel3Profile1Switch];
    relayChannel3Profile1Switch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
    [relayChannel3Profile1Switch addTarget:self action:@selector(changeRelayChannel3Profile1Switch:) forControlEvents:UIControlEventValueChanged];
    relayChannel3Profile1Switch.on=true;
    
    UILabel *relayChannel3Profile2Lbl=[[UILabel alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2, 175, 70, 20)];
    relayChannel3Profile2Lbl.text=NSLocalizedString(@"PROFILE_2_SEG",nil);
    [scrollVw addSubview:relayChannel3Profile2Lbl];
    
    relayChannel3Profile2Switch=[[UISwitch alloc]initWithFrame:CGRectMake(scrollVw.frame.size.width/2+80, 170, 0, 0)];
    [scrollVw addSubview:relayChannel3Profile2Switch];
    relayChannel3Profile2Switch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
    [relayChannel3Profile2Switch addTarget:self action:@selector(changeRelayChannel3Profile2Switch:) forControlEvents:UIControlEventValueChanged];
    [self updateValueForRelayChannel3ManualController];
    [self updateDaliPowerSaveModeValue];
    [self updateForPirValue];
    [self updatedValuesForTimeClock];
  //  [self updatedValuesForRelayChannel];
    
}
-(void)updateValueForRelayChannel3ManualController
{
    if (!daliPowerSaveModeState && timeClockEnable==0 && (pirEnableStatus==0 || pirEnableStatus==1)) {
        [relayChannel3_ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
    }
    else{
        [relayChannel3_ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
}
-(void)updateDaliPowerSaveModeValue
{
    if (daliPowerSaveModeState) {
        [relayChannel3_DaliPowerSaveMode_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
    }
    else{
        [relayChannel3_DaliPowerSaveMode_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
}
-(void)updatedValuesForTimeClock
{
    if (timeClockEnable==0)
    {
        [relayChannel3_TimeClock_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        relayChannel3Profile1Switch.enabled=NO;
        relayChannel3Profile2Switch.enabled=NO;
        relayChannel3Profile1Switch.onTintColor=[UIColor lightGrayColor];
        relayChannel3Profile2Switch.onTintColor=[UIColor lightGrayColor];
    }
    else
    {
        if (timeClockEnable==1)
        {
            relayChannel3Profile1Switch.on=YES;
            relayChannel3Profile2Switch.on=NO;
            
        }
        else if (timeClockEnable==2)
        {
            relayChannel3Profile1Switch.on=NO;
            relayChannel3Profile2Switch.on=YES;
        }
        [relayChannel3_TimeClock_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        relayChannel3Profile1Switch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
        relayChannel3Profile2Switch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
        relayChannel3Profile1Switch.enabled=YES;
        relayChannel3Profile2Switch.enabled=YES;
    }
    
}

-(void)functionForRelayManualSwitchControlerEnabled
{
    if (daliPowerSaveModeState) {
        _relayChannelSwitch.enabled=NO;
        _relayChannelSwitch.onTintColor=[UIColor lightGrayColor];
    }
    else{
        _relayChannelSwitch.enabled=YES;
        _relayChannelSwitch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
    }
}
-(void)functionForDALIchannel2ManualStepperControlerEnabled
{
    if (channelFunction==0)
    {
        self.dali2Stepper.minimumValue=0;
        self.dali2Stepper.maximumValue=100;
        self.dali2Stepper.tintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
    }
    else if (channelFunction==1)
    {
        self.dali2Stepper.minimumValue=0;
        self.dali2Stepper.maximumValue=0;
        self.dali2Stepper.tintColor=[UIColor lightGrayColor];
    }
}
- (IBAction)changeRelayChannel3Profile1Switch:(id)sender
{
    if (relayChannel3Profile1Switch.on) {
        
        relayChannel3Profile2Switch.on=NO;
    }
    else{
        relayChannel3Profile2Switch.on=YES;
    }
}
- (IBAction)changeRelayChannel3Profile2Switch:(id)sender
{
    if (relayChannel3Profile2Switch.on)
    {
        relayChannel3Profile1Switch.on=NO;
    }
    else{
        relayChannel3Profile1Switch.on=YES;
    }
}
-(void)saveValueforRelayChannel
{
    if ([[relayChannel3_TimeClock_CheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        timeClockEnable=0;
    }
    else
    {
        if ([[relayChannel3_TimeClock_CheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]] && (relayChannel3Profile1Switch.on) )
        {
             timeClockEnable=1;
        }
        else if ([[relayChannel3_TimeClock_CheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"selectedCheckbox.png"]] && (relayChannel3Profile2Switch.on))
        {
            timeClockEnable=2;
        }
    }
}
- (void)clkOnrelayChannel3_ManualControlCheckboxBtn:(id)sender
{
    if ([[relayChannel3_ManualControlCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [relayChannel3_ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_DaliPowerSaveMode_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_TimeClock_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        relayChannel3Profile1Switch.onTintColor=[UIColor lightGrayColor];
        relayChannel3Profile2Switch.onTintColor=[UIColor lightGrayColor];
        relayChannel3Profile1Switch.enabled=NO;
        relayChannel3Profile2Switch.enabled=NO;

        daliPowerSaveModeState=false;
        timeClockEnable=0;
       // [self storePirValue];
        
    }
//    else
//    {
//        [relayChannel3_ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//    }
}
- (void)clkOnrelayChannel3_pirCheckboxBtn:(id)sender
{
    if ([[relayChannel3_PirCheckBoxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        [relayChannel3_ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_DaliPowerSaveMode_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_TimeClock_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        relayChannel3Profile1Switch.onTintColor=[UIColor lightGrayColor];
        relayChannel3Profile2Switch.onTintColor=[UIColor lightGrayColor];
        relayChannel3Profile1Switch.enabled=NO;
        relayChannel3Profile2Switch.enabled=NO;
        
        daliPowerSaveModeState=false;
        timeClockEnable=0;
        
        
    }
//    else
//    {
//        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//    }
}

- (void)clkOnrelayChannel3DaliPowerSaveModeCheckboxBtn:(id)sender
{
    if ([[relayChannel3_DaliPowerSaveMode_CheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [relayChannel3_DaliPowerSaveMode_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        daliPowerSaveModeState=1;
        
        [relayChannel3_ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_TimeClock_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
                relayChannel3Profile1Switch.onTintColor=[UIColor lightGrayColor];
                relayChannel3Profile2Switch.onTintColor=[UIColor lightGrayColor];
                relayChannel3Profile1Switch.enabled=NO;
                relayChannel3Profile2Switch.enabled=NO;
        timeClockEnable=0;
        
    }
//    else
//    {
//        [relayChannel3_DaliPowerSaveMode_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//        daliPowerSaveModeState=0;
//    }
}
- (void)clkOnrelayChannel3_TimeClock_CheckboxBtn:(id)sender
{
    if ([[relayChannel3_TimeClock_CheckboxBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox.png"]])
    {
        [relayChannel3_TimeClock_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheckbox.png"] forState:UIControlStateNormal];
        relayChannel3Profile1Switch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
        relayChannel3Profile2Switch.onTintColor=[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
        relayChannel3Profile1Switch.enabled=YES;
        relayChannel3Profile2Switch.enabled=YES;
        
        [relayChannel3_ManualControlCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_PirCheckBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [relayChannel3_DaliPowerSaveMode_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        daliPowerSaveModeState=false;
        
    }
//    else
//    {
//        [relayChannel3_TimeClock_CheckboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//        relayChannel3Profile1Switch.onTintColor=[UIColor lightGrayColor];
//        relayChannel3Profile2Switch.onTintColor=[UIColor lightGrayColor];
//        relayChannel3Profile1Switch.enabled=NO;
//        relayChannel3Profile2Switch.enabled=NO;
//    }
}
- (IBAction)mimicChannel1SliderValueChanged:(UISlider *)sender
{
    NSLog(@"Value:-%@",sender);
    signed int sliderValue = (ceil(sender.value*9 - 0.5f)+1 )-99;
    NSLog(@"Value()%ld%%",(long)sliderValue);
    offsetValueLbl.text=[NSString stringWithFormat:@"Value : %ld%%", (long)sliderValue];
    dimOffsetValue=sliderValue;
}
#pragma mark Back Button Of relay Action Setting..
- (void)clkOnBackBtnOfrelayActionSetting:(id)sender
{
    [self storePirValue];
    [self saveValueforRelayChannel];
    [self storeValuesToControllerImage];
    [scrollVw removeFromSuperview];
    _mainVw.hidden=NO;
    [self LiveStatusHeaderVw];
    [self functionForCheckChanges];
    [self functionForRelayManualSwitchControlerEnabled];
}
#pragma mark Sensor Vw
-(void)showSensorVw
{
    [self loadValuesFromControllerImage];
    titlelbl.text=@"PIR Settings";
    sensorVw =[[SensorView alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, self.view.frame.size.height)];
    [sensorVw setSensorView:1];
    sensorVw.backgroundColor=[UIColor clearColor];
    [self.view addSubview:sensorVw];
    sensorVw.delegate=self;
    sensorVw.exitTimerValueLbl.text=[NSString stringWithFormat:@"%@ :%d mins",NSLocalizedString(@"EXIT_DELAY",nil),exitDelayTimer];
    [ sensorVw.exitTimerSlider setValue:(exitDelayTimer-0.5)/9];
    NSLog(@"%d",pirEnableMask);
    
//    if ([modalNameSTR isEqualToString:@"OB-1501"])
//    {
//        sensorVw.leftSensorBtn.enabled=YES;
//        sensorVw.rightSensorBtn.enabled=YES;
//        sensorVw.upSensorBtn.enabled=YES;
//        sensorVw.downSensorBtn.enabled=YES;
//    }
//    else if ([modalNameSTR isEqualToString:@"OB-1101"])
//    {
//        sensorVw.leftSensorBtn.enabled=NO;
//        sensorVw.rightSensorBtn.enabled=NO;
//        sensorVw.upSensorBtn.enabled=NO;
//        sensorVw.downSensorBtn.enabled=NO;
//        
//    }
    
    [self updatePirEnableMAskValue];
}
#pragma  mark PIR Setting
//-(void)updatePirEnableMAskValue
//{
//    if (pirEnableMask==0)
//    {
//        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//    }
//    else if (pirEnableMask==1)
//    {
//        
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        
//        /* Before Rotating 90 degree Clockwise*/
//    }
//    else if (pirEnableMask==2)
//    {
//        
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//    }
//    else if (pirEnableMask==3)
//    {
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//    }
//    else if (pirEnableMask==4)
//    {
//        
//              [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//              [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//              [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//              [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==5)
//    {
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==6)
//    {
//        
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==7)
//    {
//        
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//    }
//    else if (pirEnableMask==8)
//    {
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==9)
//    {
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==10)
//    {
//        
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==11)
//    {
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==12)
//    {
//        
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==13)
//    {
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==14)
//    {
//                [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//                [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        
//    }
//    else if (pirEnableMask==15)
//    {
//        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
//    }
//    [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
//    sensorVw.centerSensorBtn.enabled=NO;
//}
//-(void)getActiveSensorValue
//{
//    if (([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]) || [[sensorVw.centerSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
//    {
//        pirEnableMask=15;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
//    {
//        pirEnableMask=14;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
//    {
//        pirEnableMask=13;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
//    {
//        pirEnableMask=12;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
//    {
//        pirEnableMask=11;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
//    {
//        pirEnableMask=10;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
//    {
//        pirEnableMask=9;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
//    {
//        pirEnableMask=8;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
//    {
//        pirEnableMask=7;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
//    {
//        pirEnableMask=6;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
//    {
//        pirEnableMask=5;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
//    {
//        pirEnableMask=4;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
//    {
//        pirEnableMask=3;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
//    {
//        pirEnableMask=2;
//    }
//    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
//    {
//        pirEnableMask=1;
//    }
//    else if (([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]) || [[sensorVw.centerSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"centerGraySensor.png"]] )
//    {
//        pirEnableMask=0;
//    }
//}
-(void)updatePirEnableMAskValue
{
    if (pirEnableMask==0)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==1)
    {
        /* After Rotating 90 degree Clockwise*/
        
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==2)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==3)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==4)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==5)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==6)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==7)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==8)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==9)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==10)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==11)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==12)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==13)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==14)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
    }
    else if (pirEnableMask==15)
    {
        [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
    }
     [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
    sensorVw.centerSensorBtn.enabled=NO;
}




-(void)getActiveSensorValue
{
    if (([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]) || [[sensorVw.centerSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
    {
        pirEnableMask=15;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
    {
        pirEnableMask=14;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
    {
        pirEnableMask=13;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
    {
        pirEnableMask=12;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
    {
        pirEnableMask=11;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
    {
        pirEnableMask=10;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
    {
        pirEnableMask=9;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
    {
        pirEnableMask=8;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
    {
        pirEnableMask=7;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
    {
        pirEnableMask=6;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
    {
        pirEnableMask=5;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
    {
        pirEnableMask=4;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
    {
        pirEnableMask=3;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
    {
        pirEnableMask=2;
    }
    else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
    {
        pirEnableMask=1;
    }
    else if (([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]&& [[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]] && [[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]]) || [[sensorVw.centerSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"centerGraySensor.png"]] )
    {
        pirEnableMask=0;
    }
}
//
// delegate methods of sensor screens
#pragma mark delegate methods of sensor screens

- (IBAction)exitTimerSliderValueChanged:(UISlider *)sender
{
    int sliderValue = (ceil(sender.value*9 - 0.5f)+1 );
   sensorVw.exitTimerValueLbl.text=[NSString stringWithFormat:@"Exit Delay : %ld mins", (long)sliderValue];
    exitDelayTimer=(int)sliderValue;
}
- (void)ClkOnleftSensorBtn:(id)sender
{
        if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
        {
            [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        }
        else if ([[sensorVw.leftSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
        {
            [sensorVw.leftSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        }
}
- (void)ClkOnRightSensorBtn:(id)sender
{
        if ([[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
        {
            [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        }
        else if ([[sensorVw.rightSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
        {
            [sensorVw.rightSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        }
}

- (void)ClkOnUpSensorBtn:(id)sender
{
        if ([[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
        {
            [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        }
        else if ([[sensorVw.upSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
        {
            [sensorVw.upSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        }
}
- (void)ClkOnDownSensorBtn:(id)sender
{
        if ([[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightGreenSensor.png"]])
        {
            [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightRedSensor.png"] forState:UIControlStateNormal];
        }
        else if ([[sensorVw.downSensorBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"rightRedSensor.png"]])
        {
            [sensorVw.downSensorBtn setBackgroundImage:[UIImage imageNamed:@"rightGreenSensor.png"] forState:UIControlStateNormal];
        }
    }
- (void)ClkOnCenterSensorBtn:(id)sender
{
    if (sensorVw.centerArrowImgVw.hidden) {
        sensorVw.centerArrowImgVw.hidden=NO;
        if (pirEnableMask==0) {
            [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
        }
        
        else if (pirEnableMask==10) {
            [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGreenSensor.png"] forState:UIControlStateNormal];
        }
        else{
            [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerRedSensor.png"] forState:UIControlStateNormal];
        }
    }

    else{
        sensorVw.centerArrowImgVw.hidden=YES;
        [sensorVw.centerSensorBtn setBackgroundImage:[UIImage imageNamed:@"centerGraySensor.png"] forState:UIControlStateNormal];
    }
}
#pragma mark Back Button Of PIR Setting..
- (void)clkOnBackBtnOfPirSetting:(id)sender
{
    [self getActiveSensorValue];
   [self storeValuesToControllerImage];
    [sensorVw removeFromSuperview];
    _mainVw.hidden=NO;
    [self LiveStatusHeaderVw];
    [self functionForCheckChanges];
    
}

-(void)functionForCheckChanges
{
    if ([controller userChangedProfileSettings] || [controller userChangedGlobalSettings]) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
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
    ASJOverflowItem *item = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"StatusHelp"];
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
    
    
    UIBarButtonItem *rightBarBtn2=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sync.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(ClkOnSyncBtnOnStatus:)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_overflowButton,rightBarBtn2,nil];
  self.navigationItem.rightBarButtonItems[1].enabled=NO;
    self.navigationItem.hidesBackButton=YES;
    // self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks
{
    
    
    [_overflowButton setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx)
     {
         if([item.titlecheck  isEqual: @"StatusHelp"]){
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"Live_Status_Page_Help";
             theTabBar.tempTitle = NSLocalizedString(@"LIVE_STATUS_PAGE_HELP", nil); 
             [self.navigationController pushViewController:theTabBar animated:YES];
        
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
    ASJOverflowItem *item2 = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"DALI1"];
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
    self.navigationItem.rightBarButtonItems[1].enabled=NO;
    self.navigationItem.hidesBackButton=YES;
    // self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks2
{
    
    
    [_overflowButton2 setItemTapBlock:^(ASJOverflowItem *item2, NSInteger idx)
     {
         NSLog(@"%@", item2.titlecheck);
         if([item2.titlecheck isEqual:@"DALI1"]){
             
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"DALI_Channel_1_Settings_Help";
             theTabBar.tempTitle = @"DALI Channel 1 Page Help";
             [self.navigationController pushViewController:theTabBar animated:YES];
             NSLog(@"in DLE 1 ");
         }
              }];
    
    [_overflowButton2 setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}


- (void)setup3
{
    [self setupDefaults3];
    [self setupOverflowItems3];
    [self setupOverflowButton3];
    [self handleOverflowBlocks3];
}

- (void)setupDefaults3
{
    
    
}

- (void)setupOverflowItems3
{
    NSMutableArray *temp3 = [[NSMutableArray alloc] init];
    ASJOverflowItem *item3 = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"DALI2"];
    [temp3 addObject:item3];
    NSLog(@"%@", temp3);
    _overflowItems3 = [NSArray arrayWithArray:temp3];
}

- (void)setupOverflowButton3
{
    UIImage *image = [UIImage imageNamed:@"Menuright"];
    
    _overflowButton3 = [[ASJOverflowButton alloc] initWithImage:image items:_overflowItems3];
    _overflowButton3.dimsBackground = YES;
    _overflowButton3.hidesSeparator = NO;
    _overflowButton3.hidesShadow = NO;
    _overflowButton3.dimmingLevel = 0.3f;
    _overflowButton3.menuItemHeight = 30.0f;
    _overflowButton3.widthMultiplier = 0.5f;
    _overflowButton3.itemHighlightedColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    _overflowButton3.menuMargins = MenuMarginsMake(7.0f, 7.0f, 7.0f);
    _overflowButton3.separatorInsets = SeparatorInsetsMake(10.0f, 5.0f);
    _overflowButton3.menuAnimationType = MenuAnimationTypeZoomIn;
    _overflowButton3.itemFont = [UIFont fontWithName:@"Verdana" size:13.0f];
    
    
    self.navigationItem.rightBarButtonItem = _overflowButton3;
    self.navigationItem.rightBarButtonItems[1].enabled=NO;
    self.navigationItem.hidesBackButton=YES;
    // self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks3
{
    
    
    [_overflowButton3 setItemTapBlock:^(ASJOverflowItem *item3, NSInteger idx)
     {
         NSLog(@"%@", item3.titlecheck);
         if([item3.titlecheck isEqual:@"DALI2"]){
             
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"DALI_Channel_2_Settings_Help";
             theTabBar.tempTitle = @"DALI Channel 2 Page Help";
             [self.navigationController pushViewController:theTabBar animated:YES];
             NSLog(@"in DLE 1 ");
         }
     }];
    
    [_overflowButton3 setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}

// 4

- (void)setup4
{
    [self setupDefaults4];
    [self setupOverflowItems4];
    [self setupOverflowButton4];
    [self handleOverflowBlocks4];
}

- (void)setupDefaults4
{
    
    
}

- (void)setupOverflowItems4
{
    NSMutableArray *temp4 = [[NSMutableArray alloc] init];
    ASJOverflowItem *item4 = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"RELAY3"];
    [temp4 addObject:item4];
    NSLog(@"%@", temp4);
    _overflowItems4 = [NSArray arrayWithArray:temp4];
}

- (void)setupOverflowButton4
{
    UIImage *image = [UIImage imageNamed:@"Menuright"];
    
    _overflowButton4 = [[ASJOverflowButton alloc] initWithImage:image items:_overflowItems4];
    _overflowButton4.dimsBackground = YES;
    _overflowButton4.hidesSeparator = NO;
    _overflowButton4.hidesShadow = NO;
    _overflowButton4.dimmingLevel = 0.3f;
    _overflowButton4.menuItemHeight = 30.0f;
    _overflowButton4.widthMultiplier = 0.5f;
    _overflowButton4.itemHighlightedColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    _overflowButton4.menuMargins = MenuMarginsMake(7.0f, 7.0f, 7.0f);
    _overflowButton4.separatorInsets = SeparatorInsetsMake(10.0f, 5.0f);
    _overflowButton4.menuAnimationType = MenuAnimationTypeZoomIn;
    _overflowButton4.itemFont = [UIFont fontWithName:@"Verdana" size:13.0f];
    
    
    self.navigationItem.rightBarButtonItem = _overflowButton4;
    self.navigationItem.rightBarButtonItems[1].enabled=NO;
    self.navigationItem.hidesBackButton=YES;
    // self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks4
{
    
    
    [_overflowButton4 setItemTapBlock:^(ASJOverflowItem *item4, NSInteger idx)
     {
         NSLog(@"%@", item4.titlecheck);
         if([item4.titlecheck isEqual:@"RELAY3"]){
             
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"Relay_Channel_3_Settings_Help";
             theTabBar.tempTitle = @"Relay Channel 3 Page Help";
             [self.navigationController pushViewController:theTabBar animated:YES];
             NSLog(@"in DLE 1 ");
         }
     }];
    
    [_overflowButton4 setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}
// 5     //////////////

- (void)setup5
{
    [self setupDefaults5];
    [self setupOverflowItems5];
    [self setupOverflowButton5];
    [self handleOverflowBlocks5];
}

- (void)setupDefaults5
{
    
    
}

- (void)setupOverflowItems5
{
    NSMutableArray *temp5 = [[NSMutableArray alloc] init];
    ASJOverflowItem *item5 = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"PIRSTATUS"];
    [temp5 addObject:item5];
    NSLog(@"%@", temp5);
    _overflowItems4 = [NSArray arrayWithArray:temp5];
}

- (void)setupOverflowButton5
{
    UIImage *image = [UIImage imageNamed:@"Menuright"];
    
    _overflowButton5 = [[ASJOverflowButton alloc] initWithImage:image items:_overflowItems4];
    _overflowButton5.dimsBackground = YES;
    _overflowButton5.hidesSeparator = NO;
    _overflowButton5.hidesShadow = NO;
    _overflowButton5.dimmingLevel = 0.3f;
    _overflowButton5.menuItemHeight = 30.0f;
    _overflowButton5.widthMultiplier = 0.5f;
    _overflowButton5.itemHighlightedColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    _overflowButton5.menuMargins = MenuMarginsMake(7.0f, 7.0f, 7.0f);
    _overflowButton5.separatorInsets = SeparatorInsetsMake(10.0f, 5.0f);
    _overflowButton5.menuAnimationType = MenuAnimationTypeZoomIn;
    _overflowButton5.itemFont = [UIFont fontWithName:@"Verdana" size:13.0f];
    
    
    self.navigationItem.rightBarButtonItem = _overflowButton5;
    self.navigationItem.rightBarButtonItems[1].enabled=NO;
    self.navigationItem.hidesBackButton=YES;
    // self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks5
{
    
    
    [_overflowButton5 setItemTapBlock:^(ASJOverflowItem *item5, NSInteger idx)
     {
         NSLog(@"%@", item5.titlecheck);
         if([item5.titlecheck isEqual:@"PIRSTATUS"]){
             
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"PIR_Settings_Help";
             theTabBar.tempTitle = @"PIR Settings Page Help";
             [self.navigationController pushViewController:theTabBar animated:YES];
             NSLog(@"in DLE 1 ");
         }
     }];
    
    [_overflowButton4 setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}



@end
