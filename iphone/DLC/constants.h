//
//  constants.h
//  DLC
//
//  Created by mr king on 18/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#ifndef dlc_constants_h
#define dlc_constants_h

#define kAPP_VERSION @"01.12" //ver no

#define kPURCHASE   @"co.uk.4kconsulting.DLC.allcontrolleraccess"
#define DLC_URL     @"https://www.helvar.com/solutions/idim/idim-orbit/"

#define DLC4_NUM_CHANNELS           3
#define NO_CONTROLLER_CONNECTED     -1
#define NO_FILE_SELECTED            -1
#define MAX_FREE_DLC_LOGONS         0
#define SCAN_FOR_BLE_DEVICES_TIME   5   //secs
#define DLC_ONE_DSI_DALI_BLE_NAME   @"DLC-One DSI/DALI"
#define DLC_ONE_BLE_NAME            @"DLC-One"

#define MIN_TIMER_MINS  0
#define MAX_TIMER_MINS  60
#define MAX_TRANSITION_TIMER_MINS  241
#define MIN_PERCENT     0
#define MAX_PERCENT     100
#define MIN_EXIT_TIMER   0
#define MAX_EXIT_TIMER   30

//photocell stepper constants
#define MIN_PHOTOCELL_VALUE     0
#define MAX_PHOTOCELL_VALUE     4000
#define PHOTOCELL_STEPCHANGE    1.0f
//dim level stepper constants
#define MIN_DIMLEVEL_VALUE     10
#define MAX_DIMLEVEL_VALUE     100
#define DIMLEVEL_STEPCHANGE    1.0f

#define NUM_EMERGENCY_TEST_TIMES    3
#define NUM_SCENES                  4

#define DEFAULT_PASSWORD @"00000"
#define DT_PASSWORD @"02113"

//DLC 100 model number range
#define kDLC100  100

typedef enum
{
    kProfileScreen,
    kSchedulerScreen
}IPhoneScreen;

typedef enum
{
    kFIND_TAB,
    kSTATUS_TAB,
    kPROFILE_TAB,
    kSCHEDULER_TAB,
    kFILE_TAB,
    kNUM_TABS
}TabViewIndex;

typedef enum 
{
    OFF,
    ON
}Switch;

typedef enum
{
    STAGE_OFF,
    STAGE1,
    STAGE2,
    STAGE3,
    NUM_STAGES
}Stage;

typedef enum
{
   // LIGHT_OFF,
    LO,
    OK,
    HI,
    NUM_LIGHT_LEVELS
}LightLevel;

typedef enum
{
    ABSENT,
    PRESENT
    
}PIRMode;

typedef enum
{
    NOT_TRIGGERED,  //grey led
    PRESENCE_TRIGGERED, //green
    ABSENCE_TRIGGERED, //red
    NUM_PIR_STATES
}PIRState;

typedef enum
{
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY,
    NUM_DAYS
}DayOfWeek;

typedef enum
{
    PROFILE1,
    PROFILE2,
    NUM_PROFILES
}Profile;

typedef enum
{
    TIMER1,
    TIMER2,
    TIMER3,
    NUM_TIMERS
} Timer;

typedef struct
{
    NSInteger   hours24Clock;
    NSInteger   minutes;    
}TimeOfDay;

typedef struct
{
    TimeOfDay time;
} Schedule;

typedef enum
{
    DALI,
    DSI,
    _10V,
    NUM_DIMMING_FORMATS
} DimmingFormat;


#endif
