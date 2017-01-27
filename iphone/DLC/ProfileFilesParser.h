//
//  FileParser.h
//  DLC
//
//  Created by mr king on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SavedProfiles;

@interface ProfileFilesParser : NSObject
{
    
}

+ (SavedProfiles *)loadSavedProfiles;
+ (void)saveProfiles:(SavedProfiles *)profilesToSave;

@end
