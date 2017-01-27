//
//  UUID.m
//  DLC
//
//  Created by mr king on 26/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UUID.h"

@implementation UUIDs
@synthesize knownUUIDs;

- (id)init 
{    
    if ((self = [super init])) 
    {
        knownUUIDs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) dealloc 
{
    knownUUIDs = nil; 
}

@end
//------------------------------------------------------------------------------------

@implementation UUID
@synthesize controllerName;
@synthesize controllerID;
@synthesize profileFilename;

- (id)init 
{    
    if ((self = [super init])) 
    {
        controllerID = 0;
        profileFilename = @"";
        controllerName = @"";
    }
    
    return self;
}

- (void) dealloc 
{
    profileFilename = nil;
}


- (id)initWithControllerID:(NSString *)ID andName:(NSString *)name andProfile:(NSString *)filename
{
    if ((self = [super init])) 
    {
        controllerID = ID;
        controllerName = name;
        profileFilename = filename;
    }
    
    return (self);
}
@end
