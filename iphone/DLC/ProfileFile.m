//
//  Profile.m
//  DLC
//
//  Created by mr king on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileFile.h"

@implementation ProfileFile
@synthesize description;
@synthesize filename;
@synthesize name;

- (id)initWithFilename:(NSString *)aFilename controllerName:(NSString *)aName andDescription:(NSString *)aDescription
{
    if ((self = [super init])) 
    {
        filename = aFilename;
        name = aName;
        description = aDescription;
    }
    
    return (self);
}

- (void) dealloc 
{
    [self setDescription:nil];
    [self setFilename:nil];
    [self setName:nil];
}
@end
