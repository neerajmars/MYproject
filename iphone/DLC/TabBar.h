//
//  TabBar.h
//  DLC
//
//  Created by mr king on 19/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCOne.h"
#include "BLEDevice.h"

@interface TabBar : UITabBarController <BLEDeviceDelegate>
{
    //access these properties from individual scene using parentViewController
    BLEDevice   *t;                 //TI BLE class (private)
    
    NSInteger   selectedController;
    NSInteger   selectedFile;
    BOOL        offline;
    DLCOne *    controller;

}

@property (nonatomic)DLCOne *    controller;
@property (nonatomic)NSInteger selectedController;
@property (nonatomic)NSInteger selectedFile;
@property (nonatomic)BOOL offline;

- (void)newControllerWithUUID:(int)uuid;
- (void)scan;
- (void)setSelectedController:(NSInteger)value;
- (int)getSelectedController;

@end
