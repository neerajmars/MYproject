//
//  iPhoneProfileNameViewController.h
//  DLC
//
//  Created by mr king on 09/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameVC.h"
#include "constants.h"

@class DLCOne;
@interface iPhoneProfileNameViewController : NameVC <UIActionSheetDelegate>
{
    int noOfActionSheetButtons;
}

@property (strong, nonatomic) IBOutlet UITextField *txtDescription;
@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtFilename;
@property (strong, nonatomic) IBOutlet UILabel *lblWarning;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)saveToFile:(id)sender;

- (IBAction)detailsChanged:(id)sender;

@end
