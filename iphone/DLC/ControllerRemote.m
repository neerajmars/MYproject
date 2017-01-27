//
//  ControllerRemote.m
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControllerRemote.h"

@implementation ControllerRemote
@synthesize calibrateSensor;
@synthesize manualOverride;
@synthesize dimLevelOverride;
//@synthesize dimLevelOverride1;
@synthesize walkTestEnable;
@synthesize daliReset;
@synthesize emcOverride;
@synthesize dimLevelOverrideA;
@synthesize dimLevelOverrideB;


-(id)init
{
    if (self = [super init]) 
    {
        // set to defaults
        calibrateSensor = NO;
        manualOverride = NO;
        dimLevelOverride = 0;
        dimLevelOverrideA = 0;
        dimLevelOverrideB = 0;
        walkTestEnable=0;
        daliReset=0;
        emcOverride=0;
        //not used by DLCOne
        spare1 = 0;
        spare2 = 0;
        spare3 = 0;
//        spare4 = 0;
//        spare5 = 0;       
    }
    return self; 
}

- (void) dealloc 
{
}

@end
