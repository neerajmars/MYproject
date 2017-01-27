//
//  iPhoneFindViewController.h
//  DLC
//
//  Created by mr king on 18/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "constants.h"
#include "FindVC.h"

@interface iPhoneFindViewController : FindVC <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSArray     *controllerImages;
    NSArray     *menuItems;
    BOOL isDefaultPassword;
    UIButton *editDeviceNmBtn;
    UIButton *editDevicePwdBtn;
    
    UIView *sectionHeaderView;
    UILabel *controllerLbl;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *scanButton;
@property (strong, nonatomic) IBOutlet UITableView *controllerTableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *searchNavigationItem;
@property (nonatomic, assign) NSInteger proximityValue;
@property (strong, nonatomic) IBOutlet UILabel *selectedSignalStrengthLabel;

- (IBAction)startScanning:(UIBarButtonItem *)sender;
@end

//setEmergencyTestTime