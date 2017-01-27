//
//  Profiles.m
//  DLC
//
//  Created by mr king on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileList.h"

@implementation ProfileList
@synthesize defaultProfileList;
@synthesize customProfileList;

- (id)init 
{    
    if ((self = [super init])) 
    {
        defaultProfileList = [[NSMutableArray alloc] init];
        customProfileList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) dealloc 
{
    defaultProfileList = nil; 
    customProfileList = nil;
}
@end

//-----------------------------------------------------------------------------
@implementation SavedProfiles
@synthesize profileList;

- (id)init 
{    
    if ((self = [super init])) 
    {
        profileList = [[ProfileList alloc] init];
    }
    
    return self;
}

- (void) dealloc 
{
    profileList = nil; 
}
@end