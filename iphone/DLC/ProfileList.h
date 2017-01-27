//
//  Profiles.h
//  DLC
//
//  Created by mr king on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileList : NSObject
{
    NSMutableArray *defaultProfileList;
    NSMutableArray *customProfileList;
}

@property (strong, nonatomic) NSMutableArray *defaultProfileList;
@property (strong, nonatomic) NSMutableArray *customProfileList;

@end

//-------------------------------------------------------------------------
@interface SavedProfiles : NSObject
{
    ProfileList *profileList;
}

@property (strong, nonatomic) ProfileList *profileList;


@end
