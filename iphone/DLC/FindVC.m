
//
//  FindVC.m
//  DLC
//
//  Created by mr king on 19/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FindVC.h"
#import "iPhoneTabBarController.h"
#import "AppDelegate.h"
#import "DLCOne.h"

@interface FindVC ()

@end

@implementation FindVC
@synthesize scanTimer;
@synthesize loginTimer;
@synthesize confirmedPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        lastControllersFound = 0;
        controllersFound = 0;
        tableRowSelected = NO_CONTROLLER_CONNECTED;
        xmlFilename = [NSString stringWithFormat:@""];    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScanTimer:nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self.scanTimer invalidate];
    [self setScanTimer:nil];
    [self.loginTimer invalidate];
    [self setLoginTimer:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    editingDeviceName = NO;
    controllersFound = [parentVC getDevicesCount];
    
    if (controllersFound == 0)
    {
        parentVC.offline = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadValuesFromControllerImage
{
    dstSetting=[controller getDSTSetting];
}

- (void)storeValuesToControllerImage
{
    [controller setDSTSetting:dstSetting];
    [parentVC writeGlobalSettings];
}

- (void)startScanning
{
    lastControllersFound = 0;
    controllersFound = 0;
    [parentVC scan];

    scanTimer = [NSTimer scheduledTimerWithTimeInterval:SCAN_FOR_BLE_DEVICES_TIME target:self selector:@selector(scanTimerExpired) userInfo:nil repeats:NO];
}

- (void)startLoginTimer
{
    loginDelayCount = 0;
    loginTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loginTimerExpired) userInfo:nil repeats:YES];
}

- (void)findTimerExpired
{
    [scanTimer invalidate];
    scanTimer = nil;
    controllersFound = [parentVC getDevicesCount];
    
    if (controllersFound != lastControllersFound)
    {
        for (int index = 0; index < controllersFound; index++)
        {
            NSString * uuid = [parentVC getUUID:index];
            
            if ([uuid isEqualToString: @""] == NO)
            {
                foundUUIDs[index] = uuid;
            }
        }
        
        scanTimer = [NSTimer scheduledTimerWithTimeInterval:SCAN_FOR_BLE_DEVICES_TIME target:self selector:@selector(scanTimerExpired) userInfo:nil repeats:NO];
    }
    else
    {
        [parentVC stopScanning];
    }
}

// Needed??
- (void)clearFoundUUIDs
{
    for (int index = 0; index < 500; index++)
    {
        foundUUIDs[index] = @"";
    }
}

- (BOOL)controllersFoundChanged
{
    if (controllersFound != lastControllersFound)
    {
        lastControllersFound = controllersFound;
        return (YES);
    }
    
    return (NO);
}

- (BOOL)validConfigFilename:(NSString *)filename
{
    if ((filename != nil) && [filename isEqualToString:@""] == NO)
    {
        return (YES);
    }
    else
    {
        return (NO);
    }
}

- (BOOL)selectedControllerEquals:(int)index
{
    if (parentVC.selectedController == index)
    {
        return (YES);
    }
    else
    {
        return (NO);
    }
}

- (void)setSelectedController:(int)index
{
    [parentVC disconnectFromActivePeripheral];   //disconnect from anything we're already connected to
    parentVC.selectedController = index;
}

- (void)setNewControllerWithUUID:(NSString *)uuid
{
    [parentVC newControllerWithUUID:uuid];
    controller = parentVC.controller;
}

- (void)setControllerOfflineAndNotSelected:(BOOL)notSelected
{
    parentVC.offline = YES;
    parentVC.readAllDLCSettings = NO;
    
    if (notSelected == YES)
    {
        parentVC.selectedController = NO_CONTROLLER_CONNECTED;
    }
}

- (BOOL)loggedOntoController:(int)index
{
    if ((parentVC.selectedController == index) && (parentVC.offline == NO))
    {
        return (YES);
    }
    else
    {
        return (NO);
    }
}

- (void)setControllerOnline
{
    parentVC.offline = NO;
}

- (BOOL)loadDLCConfiguration
{
    if ([parentVC.controller loadDLCOneConfigurationFromFile:xmlFilename] == YES)
    {
        return (YES);
    }
    else
    {
        return (NO);
    }
}

- (void)setDeviceID:(NSString *)ID
{
    [parentVC.controller setDeviceWithID:ID];
}

- (BOOL)exceededMaximumControllersCountingUUID:(NSString *)uuid
{
    BOOL exceededMax = NO;
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];

    if (([appDelegate getUUIDForDeviceWith:uuid] == nil) && ([appDelegate getKnownControllersCount] >= MAX_FREE_DLC_LOGONS))
    {
        //exceededMax = YES;        //TODO: put back in for later revisions where limit applies
    }
        
    return (exceededMax);
}

- (void)invalidateTimer
{
    [self.loginTimer invalidate];
    [self setLoginTimer:nil];
}

- (void)initialiseControllerOnline
{
    int controllerIndex = (int)[self parentVC].selectedController;
    NSString * foundDeviceID = foundUUIDs[controllerIndex];
    
    [parentVC writeGlobalSettings];     // writes csum to DLC after login
    [parentVC writeRemoteControl];      // ensure update clock
    
    [self setControllerOnline];
    [self setDeviceID:foundDeviceID];

    NSString *name = [[NSString alloc] initWithString:[parentVC getUUIDName:controllerIndex]];
    NSString *filename = [[NSString alloc] initWithString:[controller getProfileName]];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) updateKnownControllersWithDevice: foundDeviceID andName:name andProfile:filename];
    
    if (filename != nil)
    {
        int index = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) getSavedProfileIndexFor:filename];
        [parentVC setSelectedFile:index];
        NSString* description = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) getProfileFileFor:filename];
        [controller setDeviceDescriptorAs:description];
    }
    else
    {
        [parentVC setSelectedFile:NO_FILE_SELECTED];
    }
        
    //printf("Change: %x %x\n", controller, parentVC.controller);
    [self.tabBarController setSelectedIndex:kSTATUS_TAB];
}

- (void)initialiseIncorrectPassword
{
    [self setControllerOfflineAndNotSelected:YES];
    [self setNewControllerWithUUID:@""];
    [controller initialiseControllerData];
    
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_NOT_CONNECT", nil) message: NSLocalizedString(@"FIND_INCORRECT_PASSCODE", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alertDialog.alertViewStyle = UIAlertViewStyleDefault;
    [alertDialog show];
}

- (void)failedToReadPassword
{
    [self.loginTimer invalidate];
    [self setLoginTimer:nil];
    [self setControllerOfflineAndNotSelected:YES];
    [self setNewControllerWithUUID:@""];
    [controller initialiseControllerData];
    
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_NOT_CONNECT", nil) message: NSLocalizedString(@"FIND_UNABLE_TO_READ_PASSCODE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertDialog show];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)showEditPasswordBox 
{
    confirmedPassword = NO;
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_EDIT_PASSCODE", nil) message: NSLocalizedString(@"FIND_ENTER_NEW_PASSCODE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"FIND_QUIT", nil) otherButtonTitles:NSLocalizedString(@"FIND_CHANGE", nil), nil];
    alertDialog.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertDialog show];
}

- (void)showEditDeviceName
{
    editingDeviceName = YES;
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_NEW_DEVICENAME", nil) message: NSLocalizedString(@"FIND_ENTER_NEW_DEVICENAME", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"FIND_QUIT", nil) otherButtonTitles:NSLocalizedString(@"FIND_CHANGE", nil), nil];
    alertDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertDialog show];
}

- (void)showReconfirmPasswordBox
{
    confirmedPassword = YES;
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_EDIT_PASSCODE", nil) message: NSLocalizedString(@"FIND_CONFIRM_NEW_PASSCODE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"FIND_QUIT", nil) otherButtonTitles:NSLocalizedString(@"FIND_CHANGE", nil), nil];
    alertDialog.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertDialog show];
}

-(void)showInvalidPasswordBox
{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_LOGIN", nil) message:
                   NSLocalizedString(@"FIND_DEFAULT_PASSWORD_SET", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
}
- (void)writeNewPasswordToController
{
    [parentVC writeGlobalSettings];
}

@end
