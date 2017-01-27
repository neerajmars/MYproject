//
//  WeeklySchedule.m
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeeklySchedule.h"

@implementation WeeklySchedule

-(id)init
{
    self = [super init];
    if (self) 
    {
        // Custom initialization
        for (NSInteger profile = 0; profile < 2; profile++)
        {
            for (DayOfWeek day = MONDAY; day <= SUNDAY; day++)
            {
                weeklySchedule[profile][day].profile = profile;
                weeklySchedule[profile][day].day = day;
                weeklySchedule[profile][day].time.hours24Clock = 0;
                weeklySchedule[profile][day].time.minutes = 0;
            }
        }
    }
    return self;
}

-(BOOL)updateScheduleForSchedule:(BOOL)profile forDay:(DayOfWeek)day andForTime:(TimeOfDay)time
{
    BOOL setOK = false;
    weeklySchedule[profile][day].time.hours24Clock = time.hours24Clock;
    weeklySchedule[profile][day].time.minutes = time.minutes;
    
    return (setOK);
}
@end
