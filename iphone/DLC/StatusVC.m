//
//  StatusVC.m
//  DLC
//
//  Created by mr king on 27/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusVC.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"

@interface StatusVC ()

@end

@implementation StatusVC

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
  //  selectedProfile = PROFILE1;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadValuesFromControllerImage
{
     daliPowerSaveModeState=[controller getDaliPowerSaveMode];
    timeClockEnable=[controller getTimeClockEnable];
    singlePoleSwitch=[controller getSinglePoleSwitch];
    pirEnableMask=[controller getPirEnableMask];
    
//    pirEnableStatus=[controller getPirEnableCheckBoxTo:0];
//    dimOffsetValue=[controller getMimicChannel1Value:0];
//    channelFunction = [controller getChannelFunctionForProfile:0];
//    exitDelayTimer=[controller getExitDelayTimer:0];
    
    for (int i=0; i<=1; i++) {
        pirEnableStatus=[controller getPirEnableCheckBoxTo:i];
        dimOffsetValue=[controller getMimicChannel1Value:i];
        channelFunction = [controller getChannelFunctionForProfile:i];
        exitDelayTimer=[controller getExitDelayTimer:i];
    }
    
    
//    pirEnableStatus=[controller getPirEnableCheckBoxTo:(int)selectedProfile];
//    dimOffsetValue=[controller getMimicChannel1Value:(int)selectedProfile];
//    channelFunction = [controller getChannelFunctionForProfile:(int)selectedProfile];
//    exitDelayTimer=[controller getExitDelayTimer:(int)selectedProfile];
}

- (void)storeValuesToControllerImage
{
    [controller setDaliPowerSaveMode:daliPowerSaveModeState];
    [controller setTimeClockEnable:timeClockEnable];
    [controller setSinglePoleSwitch:singlePoleSwitch];
    
//    [controller setPirEnableCheckboxTo:pirEnableStatus ForProfile:0];
//    [controller setMimicChannel1Value:dimOffsetValue ForProfile:0];
//    [controller setChannelFunctionForProfile:0 withValue:channelFunction];
//    [controller setExitDelayTimer:0 withValue:exitDelayTimer];
    
    
    [controller setPirEnableMask:pirEnableMask];
    
//    NSLog(@"MDlSTR modalNameSTR=%@",modalNameSTR);
//    if ([modalNameSTR isEqualToString:@"OB-1501"])
//    {
//        [controller setPirEnableMask:pirEnableMask];
//    }
    for (int i=0; i<=1; i++)
    {
        [controller setPirEnableCheckboxTo:pirEnableStatus ForProfile:i];
        [controller setMimicChannel1Value:dimOffsetValue ForProfile:i];
        [controller setChannelFunctionForProfile:i withValue:channelFunction];
        [controller setExitDelayTimer:i withValue:exitDelayTimer];
    }
    
    
//    [controller setPirEnableCheckboxTo:pirEnableStatus ForProfile:(int)selectedProfile];
//    [controller setMimicChannel1Value:dimOffsetValue ForProfile:(int)selectedProfile];
//    [controller setChannelFunctionForProfile:(int)selectedProfile withValue:channelFunction];
//    [controller setExitDelayTimer:(int)selectedProfile withValue:exitDelayTimer];
}
-(void)writeUpdatedValue
{
    [parentVC writeGlobalSettings];
    [parentVC writeProfileSettings];
}

- (void)setLightsTo:(BOOL)state
{
    [parentVC setLightsTo:state];
}
- (void)setWalkTestEnable:(BOOL)state
{
    [parentVC setWalkTestEnable:state];
}
- (void)setLightsTo:(BOOL)state ForChannel:(int)channel
{
    [parentVC setLightsTo:state ForChannel:(int)channel];
}

- (void)setCalibrateSensorTo:(long)calLevelValue
{
    for (Profile p = PROFILE1; p < NUM_PROFILES; p++)
    {
        [controller setPhotocellCalibrationForProfile:p withCalibrationValue:(int)calLevelValue];
    }

    [parentVC setCalibrateSensor];
}
- (void)setDimLevelOverrideToA:(unsigned char)dimLevelValue
{
    [parentVC setDimLevelOverrideToA:dimLevelValue+1];
}
- (void)setDimLevelOverrideToB:(unsigned char)dimLevelValue
{
    [parentVC setDimLevelOverrideToB:dimLevelValue+1];
}
-(void)setEMCOverride:(unsigned char)value
{
    [parentVC setEMCOverride:value];
}
@end
