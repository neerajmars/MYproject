//
//  WeekVC.h
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#include "constants.h"

@class iPhoneTabBarController;
@class DLCOne;

//picker definitions
enum 
{
    kProfileComponent,
    kDayComponent,
    kHoursComponent,
    kMinutesComponent,
    kComponentCount
} PickerComponents;

@interface WeekVC : BaseVC
{
    DayOfWeek selectedDay;
    Profile   selectedProfile;
    TimeOfDay selectedTime;
}

@property (strong, nonatomic) id delegate;

@end
