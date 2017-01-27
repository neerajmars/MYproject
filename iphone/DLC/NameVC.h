//
//  NameVC.h
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@class iPhoneTabBarController;
@class DLCOne;

@interface NameVC : BaseVC
{
    int                     callingScreen;
    NSString                *originalXmlFilename;
    NSString                *description;
    NSString                *location;
    NSString                *filename;
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSString *originalXmlFilename;
@property int callingScreen;

- (BOOL)invalidFilename:(NSString *)newFilename;
- (BOOL)savedXMLFileWithName:(NSString *)newFilename andDescription:(NSString *)newDescription andLocation:(NSString*)newLocation;
- (void)updateProfileListAndKnownControllers;

@end
