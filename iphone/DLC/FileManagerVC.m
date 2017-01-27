//
//  FileManagerVC.m
//  DLC
//
//  Created by mr king on 27/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileManagerVC.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"
@interface FileManagerVC ()

@end

@implementation FileManagerVC

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

- (void)setParentVC:(iPhoneTabBarController *)p
{
    [super setParentVC:p];
    selectedFile = (int)parentVC.selectedFile;
    offline = parentVC.offline;
}

- (void)loadValuesFromControllerImage
{
    selectedFile = (int)parentVC.selectedFile;
}

- (void)storeValuesToControllerImage
{
    parentVC.selectedFile = selectedFile;
}

- (void)setControllerOffline
{
    parentVC.offline = YES;
}

- (void)setSelectedFile: (int)index
{
    parentVC.selectedFile = index;
    selectedFile = index;
}

- (void)setNewControllerWithUUID:(NSString *)uuid
{
    [parentVC newControllerWithUUID:uuid];
}

- (BOOL)loadDLCConfiguration:(NSString *)filename
{
    if ([parentVC.controller loadDLCOneConfigurationFromFile:filename] == YES)
        return (YES);
    else
        return (NO);
}
- (BOOL)loadiDimOrbitConfigurationFromFile:(NSString *)filePath
{
     
    
    if ([parentVC.controller loadiDimOrbitConfigurationFromFile:filePath] == YES)
        return (YES);
    else
        return (NO);
    
}
@end
