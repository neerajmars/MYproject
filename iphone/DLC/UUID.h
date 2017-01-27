//
//  UUID.h
//  DLC
//
//  Created by mr king on 26/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUIDs : NSObject
{
    NSMutableArray *knownUUIDs;
}

@property (strong, nonatomic) NSMutableArray *knownUUIDs;
@end

//---------------------------------------------------------------------
@interface UUID : NSObject
{
    NSString *      controllerID;
    NSString *      controllerName;
    NSString *      profileFilename;
}

@property (nonatomic) NSString * controllerID;
@property (nonatomic) NSString * controllerName;
@property (strong, nonatomic) NSString *profileFilename;

- (id)initWithControllerID:(NSString *)ID andName:(NSString*)name andProfile:(NSString *)filename;
@end
