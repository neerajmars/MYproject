//
//  FileManagerVC.h
//  DLC
//
//  Created by mr king on 27/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@class iPhoneTabBarController;
@class DLCOne;

@interface FileManagerVC : BaseVC
{
    int     selectedFile;
    bool    offline;
}

- (void)setControllerOffline;
- (void)setSelectedFile: (int)index;
- (void)setNewControllerWithUUID:(NSString *)uuid;
- (BOOL)loadDLCConfiguration:(NSString *)filename;
- (BOOL)loadiDimOrbitConfigurationFromFile:(NSString *)filePath;
@end
