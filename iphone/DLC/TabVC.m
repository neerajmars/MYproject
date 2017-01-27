//
//  TabBC.m
//  DLC
//
//  Created by mr king on 19/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabVC.h"

@interface TabVC ()

@end

@implementation TabVC
@synthesize controller;
@synthesize selectedController;
@synthesize offline;
@synthesize selectedFile;
@synthesize newStatusReceived;
@synthesize readAllDLCSettings;
@synthesize password1;
@synthesize password2;
@synthesize passwordIsDefault;
@synthesize editingDeviceName;

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
    selectedController = NO_CONTROLLER_CONNECTED;
    offline = YES;   
    selectedFile = NO_FILE_SELECTED;
    newDeviceFound = false;
    readAllDLCSettings = NO;
    
    // Initialise BLE
    t = [[BLEDevice alloc] init];       // Init BLEDevice class.
    [t controlSetup:1];                 // Do initial setup of BLEDevice class.
    t.delegate = self;                  // Set BLEDevice delegate class to point at methods implemented in this class.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    [self setController:nil];
    t = nil;
    [self setPassword1:nil];
    [self setPassword2:nil];
}

- (void)viewWillUnload
{
    [super viewWillUnload];
    [self disconnectFromPeripherals];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSNumber *)getDeviceRSSI:(NSInteger)index {
    
    if (t.rssiValues.count > index) {
        
        return t.rssiValues[index];
    }
    
    return nil;
}
- (void)scan
{
    newDeviceFound = false;
    [self disconnectFromPeripherals];
    
    [t findBLEPeripherals];
}

- (int)getDevicesCount
{
    return ((int)[t.peripherals count]);
}

- (void)stopScanning
{
    [t stopBLEScanning];
}

- (NSString *)getUUID:(int)index
{
    NSString * uuidStr = @"";
    
    if ([t.peripherals count] > index)
    {
        CBPeripheral *p = [t.peripherals objectAtIndex:index];
        if ((p == NULL) || (!p.identifier))
        {
            return (@"");
        }
        
        //CFStringRef s = CFUUIDCreateString(NULL, p.UUID);
        //const char *cs = CFStringGetCStringPtr(s, 0);
        //uuidStr = [NSString stringWithUTF8String:cs];
        uuidStr = [t UUIDToString:p.identifier];
    }
    
    return (uuidStr);
}

- (NSString *)getUUIDName:(int)index
{
    NSString * nameStr = @"";
    
    if ([t.peripherals count] > index)
    {
        CBPeripheral *p = [t.peripherals objectAtIndex:index];
        if ((p == nil) || (!p.name))
        {
            return (@"");
        }
        
        const char* s = [p.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
        nameStr = [NSString stringWithUTF8String:s];
    }
    
    return (nameStr);
}
-(void)setWalkTestEnable:(BOOL)state
{
    unsigned char wt = (state > 0) ? 1 : 2;
     [controller setwalkTestEnableOverrideTo:wt];
    
    [t writeRemoteControl:controller p:[t activePeripheral] ForRemoteObject:11];
    [controller setwalkTestEnableOverrideTo:0];
}

- (void)setLightsTo:(BOOL)state
{
    unsigned char sw = (state > 0) ? 1 : 2;
    [controller setSwitchOverrideTo:sw];
    [t writeRemoteControl:controller p:[t activePeripheral] ForRemoteObject:2];
    [controller setSwitchOverrideTo:0];    // actioned so clear
}

- (void)setCalibrateSensorForSelectedProfile:(int)selectedProfile
{
    [controller setCalibrateSensorTo:selectedProfile+1];
    [t writeRemoteControl:controller p:[t activePeripheral] ForRemoteObject:1];
    [controller setCalibrateSensorTo:0];   // actioned so clear
    
    // copy over latest lux level into our controller images for both profiles (saves reading them back).
    uint photocellValue = [controller getLuxLevel];
    [controller setPhotocellCalibrationForProfile:selectedProfile withCalibrationValue:photocellValue];
}
-(void)setDaliResetTo:(int)channel
{
    [controller setDaliResettoTo:channel];
    [t writeRemoteControl:controller p:[t activePeripheral] ForRemoteObject:10];
    [controller setDaliResettoTo:0];
}
-(void)setDimLevelOverrideToA:(unsigned char)value
{
    [controller setDimLevelOverrideToA:value];
    [t writeRemoteControl:controller p:[t activePeripheral] ForRemoteObject:3];
    [NSThread sleepForTimeInterval:0.05];
    [controller setDimLevelOverrideToA:0];   // actioned so clear
    
}
-(void)setDimLevelOverrideToB:(unsigned char)value
{
    [controller setDimLevelOverrideToB:value];
    [t writeRemoteControl:controller p:[t activePeripheral] ForRemoteObject:13];
    [NSThread sleepForTimeInterval:0.05];
    [controller setDimLevelOverrideToB:0];   // actioned so clear
    
}
-(void)setEMCOverride:(unsigned char)value
{
    [controller setEMCOverride:value];
    [t writeRemoteControl:controller p:[t activePeripheral] ForRemoteObject:12];
    [controller setEMCOverride:0];
}
- (void) writeRemoteControl
{
    // Ensure we write to DLC controller remote control at least once in order to
    // update the clock, but do here once we've read everything and the password has been written.
    
    [t writeRemoteControl:controller p:[t activePeripheral] ForRemoteObject:0];
    
}

- (void) writeGlobalSettings
{
    [t writeGlobalSettings:controller p:[t activePeripheral]];
}

// Now both writeScheduleSettings and this method write every setting to the controller.
- (void) writeProfileSettings
{
    if ([controller userChangedGlobalSettings])
    {
        [t writeGlobalSettings:controller p:[t activePeripheral]];
        [NSThread sleepForTimeInterval:0.05];
    }

    if ([controller userChangedProfileSettings])
    {
        [t writePrimaryProfile:controller p:[t activePeripheral]];
        [NSThread sleepForTimeInterval:0.05];

        [t writeSecondaryProfile:controller p:[t activePeripheral]];
        [NSThread sleepForTimeInterval:0.05];
    }
    
    if ([controller userChangedExtendProfileSettings])
    {
        [t writePrimaryExtendProfile:controller p:[t activePeripheral]];
        [NSThread sleepForTimeInterval:0.05];

        [t writeSecondaryExtendProfile:controller p:[t activePeripheral]];
    }
}

- (void) writeScheduleSettings
{
    [self writeProfileSettings];
}

- (void) writeDeviceInformation
{
    [t writeDeviceInfomation:controller p:[t activePeripheral]];
}

-(void) readDeviceInformation
{
    [t readDeviceInformation:[t activePeripheral]];
}

- (void)readControllerSettings
{
    [t readModelNumber:[t activePeripheral]];
    [t readGlobalSettings:[t activePeripheral]];
    [t readPrimaryProfile:[t activePeripheral]];
    [t readSecondaryProfile:[t activePeripheral]];
    [t readPrimaryExtend:[t activePeripheral]];
    [t readSecondaryExtend:[t activePeripheral]];
}

#pragma mark -
#pragma mark BLE delegates
// Method from BLEDeviceDelegate, called when BLE device has been found and all services have been discovered
-(void) deviceReady 
{
    [t enableDLCStatus:[t activePeripheral]];         // Enable light level service (if found)
    
    [t readDeviceInformation:[t activePeripheral]];
    [self readControllerSettings];
    
    offline = false;
}

-(void) deviceDisconnected
{
    // Connection lost: so show it. Go back to empty find screen.
    readAllDLCSettings = false;
    offline = true;
    
    if (editingDeviceName == NO)
    {
        selectedController = NO_CONTROLLER_CONNECTED;
        [self setPassword1:nil];
        [self setPassword2:nil];
        [self setSelectedIndex:kSTATUS_TAB];
        [self setSelectedIndex:kFIND_TAB];
    }
    else
    {
        [self connectToPeripheral:(int) selectedController];
    }
}

// Method from BLEDeviceDelegate, called when a new UUID is found.
-(void) newDeviceFoundWithUUID:(NSString *)newUUIDstr
{
    printf("New device found: %s", [newUUIDstr UTF8String]);
    newDeviceFound = true;
}

// Method from BLEDeviceDelegate, called when light sensor values are updated
-(void) controllerStatusUpdate:(uint8_t *)newStatus
{
    printf("DLC status update!\n");
    if (controller != nil)
    {
        [controller updateAllStatusWithData:newStatus];
        //printf("controller: %x ", controller);
        newStatusReceived = true;
    }
}

// Method from BLEDeviceDelegate, called when relay output is updated
-(void) relayOutputUpdate:(char)sw 
{
    printf("Relay output updated!\n");
    // Nothing to do: catered for by status notifications.
}

// Method from BLEDeviceDelegate, called when global settings updated
-(void) globalSettingsUpdate:(uint8_t *)newGlobalSettings
{
    printf("DLC global settings update!\n");
    if (controller != nil)
    {
        [controller updateGlobalSettingsWithData:newGlobalSettings];
        [controller updateDLCGlobalSettingsChecksum:newGlobalSettings WithLength: BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_READ_LEN];
    }
}

// Method from BLEDeviceDelegate, called when primary settings updated
-(void) primarySettingsUpdate:(uint8_t *)newPrimarySettings
{
    printf("DLC primary profile settings update!\n");
    if (controller != nil)
    {
        [controller updateProfile:PROFILE1 WithData:newPrimarySettings];
        [controller updateDLCProfileChecksumForProfile:PROFILE1 ForData:newPrimarySettings WithLength: BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_READ_LEN];
    }
}

// Method from BLEDeviceDelegate, called when secondary settings updated
-(void) secondarySettingsUpdate:(uint8_t *)newSecondarySettings
{
    printf("DLC secondary profile settings update!\n");
    if (controller != nil)
    {
        [controller updateProfile:PROFILE2 WithData:newSecondarySettings];
        [controller updateDLCProfileChecksumForProfile:PROFILE2 ForData:newSecondarySettings WithLength:BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_READ_LEN];
    }
}

-(void) primaryExtendSettingsUpdate:(uint8_t *)newPrimaryExtendSettings
{
    printf("DLC primary extend settings update!\n");
    if (controller != nil)
    {
        [controller updateExtend:PROFILE1 WithData:newPrimaryExtendSettings];
        [controller getScheduleDataArrayFor:PROFILE1];      // ensure csum matches what's just been read
        [controller updateDLCExtendChecksumForProfile:PROFILE1 ForData:newPrimaryExtendSettings WithLength:BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_READ_LEN];
    }
}

-(void) secondaryExtendSettingsUpdate:(uint8_t *)newSecondaryExtendSettings
{
    printf("DLC secondary extend settings update!\n");
    if (controller != nil)
    {
        [controller updateExtend:PROFILE2 WithData:newSecondaryExtendSettings];
        [controller getScheduleDataArrayFor:PROFILE2];  // ensure csum matches what's just been read
        [controller updateDLCExtendChecksumForProfile:PROFILE2 ForData:newSecondaryExtendSettings WithLength:BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_READ_LEN];
        readAllDLCSettings = YES;
    }
}

-(void) deviceNameUpdate:(uint8_t *)newDeviceName ofLength:(uint8_t)length
{
    printf("DLC device name update!\n");
    if (controller != nil)
    {
        uint8_t deviceName[BLE_DEVICE_DLC_CHAR_DEVICE_NAME_READ_LEN + 1];

        // pad with spaces
        for (int b = 0; b < length; b++)
        {
            deviceName[b] = newDeviceName[b];
        }
        
        for (int b = length; b < BLE_DEVICE_DLC_CHAR_DEVICE_NAME_READ_LEN; b++)
        {
            deviceName[b] = ' ';
        }
        
        deviceName[BLE_DEVICE_DLC_CHAR_DEVICE_NAME_READ_LEN] = NULL;
        NSString *s = [NSString stringWithUTF8String:(char *)deviceName];
        
        [controller updateDeviceNameWith:s];
    }
}

-(void) modelNumberUpdate:(char *)modelNoString
{
  //  NSString *modelNoStr = [NSString stringWithUTF8String:modelNoString];
    modelNumberStr= [NSString stringWithUTF8String:modelNoString];
    NSLog(@"modelNumberUpdate= %@",modelNumberStr);
    
//    if (([modelNoStr length] >= 6) && ([modelNoStr rangeOfString:@"DLC1-"].location != NSNotFound))
//    {
//        [controller updateModelNo:[modelNoStr characterAtIndex:5]];
//    }
}

-(NSString *)getmodelNumberString
{
    return modelNumberStr;
}

- (void)disconnectFromPeripherals
{
    offline = true;
    
    if (t.activePeripheral)
    {
        if (t.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[t CM] cancelPeripheralConnection:[t activePeripheral]];
        }
    }
    
    if (t.peripherals)
    {
        t.peripherals = nil;
    }
}

- (void)disconnectFromActivePeripheral
{
    if (t.activePeripheral)
    {
        if (t.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[t CM] cancelPeripheralConnection:[t activePeripheral]];
        }
    }
}


- (void)connectToPeripheral:(int)index
{
    offline = true;
    if (t.peripherals.count > index)
    {
        [t connectPeripheral:[t.peripherals objectAtIndex:index]];
        offline = false;
        selectedController = index; // Allow select different DLC from list
    }
}

- (void)newControllerWithUUID:(NSString *)uuid
{
    //create once a controller's been selected and connected to
    controller = nil;
    controller = [[DLCOne alloc] initWithDeviceID:uuid];    
}

- (BOOL)passwordOK
{
    BOOL passwordOK = NO;
    passwordIsDefault = NO;
    NSString * cp = [controller getPassword];
    NSLog(@"%@ %@", password2, cp);
    
    if ([password2 isEqualToString:DT_PASSWORD] || [cp isEqualToString:password2])
    {
        passwordOK = YES;
            
        if ([password2 isEqualToString:DEFAULT_PASSWORD])
        {
            passwordIsDefault = YES;
        }
           
    }
    
    return (passwordOK);
}


@end
