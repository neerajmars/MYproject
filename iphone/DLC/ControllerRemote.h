//
//  ControllerRemote.h
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include "constants.h"

@interface ControllerRemote : NSObject
{
    @private
    
    unsigned char calibrateSensor;
    unsigned char manualOverride;
    unsigned char dimLevelOverride;
    
    unsigned char dimLevelOverrideA;
    unsigned char dimLevelOverrideB;
  //  unsigned char dimLevelOverride1;
    unsigned char walkTestEnable;
    unsigned char daliReset;
    unsigned char emcOverride;
    unsigned char spare1;
    unsigned char spare2;
    unsigned char spare3;
//    unsigned char spare4;
//    unsigned char spare5;
}

@property (nonatomic) unsigned char calibrateSensor;
@property (nonatomic) unsigned char manualOverride;
@property (nonatomic) unsigned char dimLevelOverride;
//@property (nonatomic) unsigned char dimLevelOverride1;
@property (nonatomic) unsigned char walkTestEnable;
@property (nonatomic) unsigned char daliReset;
@property (nonatomic) unsigned char emcOverride;
@property (nonatomic) unsigned char dimLevelOverrideA;
@property (nonatomic) unsigned char dimLevelOverrideB;

-(id)init;
@end
