//
//  TabBC.m
//  DLC
//
//  Created by mr king on 19/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabBC.h"

@interface TabBC ()

@end

@implementation TabBC
@synthesize controller;
@synthesize selectedController;
@synthesize offline;
@synthesize selectedFile;

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
    
    // initialise BLE
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scan
{
    [self disconnectFromPeripherals];
    
    [t findBLEPeripherals:2];   
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark BLE delegates
//Method from BLEDeviceDelegate, called when BLE device has been found and all services have been discovered
-(void) deviceReady 
{
    [t enableRelay:[t activePeripheral]];               // Enable relay service (if found)
    [t enableLightSensor:[t activePeripheral]];         // Enable light level service (if found)
    // Start timer to read relay status every 2s
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(relayStatusTimer:) userInfo:nil repeats:NO]; 
}

// Method from BLEDeviceDelegate, called when light sensor values are updated
-(void) lightSensorValueUpdate:(char)lightLevel
{
    printf("Light sensor level updated!\n");
}

// Method from BLEDeviceDelegate, called when relay output is updated
-(void) relayOutputUpdate:(char)sw 
{
    printf("Relay output updated!\n");
    // do what you have to do
}

- (void)disconnectFromPeripherals
{
    if (t.activePeripheral)
    {
        if(t.activePeripheral.isConnected) 
        {
            [[t CM] cancelPeripheralConnection:[t activePeripheral]];
        }
    }
    
    if (t.peripherals) 
    {
        t.peripherals = nil;
    }    
}

- (void)newControllerWithUUID:(int)uuid
{
    //create once a controller's been selected and connected to
    controller = nil;
    controller = [[DLCOne alloc] initWithDeviceID:uuid];
    
    if (uuid)
    {
        
    }
}

@end
