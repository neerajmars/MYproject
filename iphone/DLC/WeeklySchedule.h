//
//  WeeklySchedule.h
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "constants.h"

@interface WeeklySchedule : NSObject
{
    ScheduleTime weeklySchedule[NUM_PROFILES][NUM_DAYS];
}

@end
