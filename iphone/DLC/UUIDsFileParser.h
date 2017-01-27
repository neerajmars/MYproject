//
//  UUIDsFileParser.h
//  DLC
//
//  Created by mr king on 26/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UUIDs;

@interface UUIDsFileParser : NSObject
{
    
}

+ (UUIDs *)loadSavedControllerIDs;
+ (void)saveDevices:(UUIDs *)idsToSave;
@end
