//
//  FindVC.h
//  DLC
//
//  Created by mr king on 19/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@class iPhoneTabBarController;
@class DLCOne;

@interface FindVC : BaseVC
{
    NSUserDefaults *defaults;
    NSInteger   controllersFound;
    NSInteger   lastControllersFound;
    NSInteger   tableRowSelected;
    NSString    *xmlFilename;
    
    int         selectedUUID;
    NSString *   foundUUIDs[500];
    int          loginDelayCount;
    BOOL        confirmedPassword;
    BOOL        editingDeviceName;
    int         dstSetting;
}

@property (strong, nonatomic) NSTimer *scanTimer;
@property (strong, nonatomic) NSTimer *loginTimer;
@property (nonatomic) BOOL confirmedPassword;

- (void)startScanning;
- (void)findTimerExpired;
- (BOOL)controllersFoundChanged;
- (void)startLoginTimer;
- (void)invalidateTimer;
- (void)initialiseControllerOnline;
- (void)initialiseIncorrectPassword;
- (void)failedToReadPassword;
- (void)showEditPasswordBox;
- (void)showEditDeviceName;
- (void)showReconfirmPasswordBox;
-(void)showInvalidPasswordBox;
- (void)writeNewPasswordToController;

- (BOOL)selectedControllerEquals:(int)index;
- (void)setSelectedController:(int)index;
- (void)setNewControllerWithUUID:(NSString *)uuid;
- (void)setControllerOfflineAndNotSelected:(BOOL)notSelected;
- (BOOL)loggedOntoController:(int)index;
- (void)setControllerOnline;
- (BOOL)loadDLCConfiguration;
- (void)setDeviceID:(NSString *)ID;
- (BOOL)validConfigFilename:(NSString *)filename;
- (BOOL)exceededMaximumControllersCountingUUID:(NSString *)uuid;
@end
