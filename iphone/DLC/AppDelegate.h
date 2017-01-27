//
//  AppDelegate.h
//  DLC
//
//  Created by A King on 14/02/2013.
//  Copyright (c) 2013 A King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "GDataXMLNode.h"
#import "TabVC.h"
#import "NameVC.h"

@class SavedProfiles;
@class UUIDs;
@class UUID;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    SavedProfiles *savedProfiles;
    UUIDs         *knownControllerIDs;
    TabVC *tbc;
    NSString *filePath;
     NSString *modelNumberStr;
    NSInteger importFile;
  //  NSInteger selectedProfile;
    NSInteger activeProfileOnStatusScreen;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SavedProfiles *savedProfiles;
@property (strong, nonatomic) UUIDs *knownControllerIDs;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *modelNumberStr;
@property (nonatomic, assign) NSInteger importFile;
//@property (nonatomic, assign) NSInteger selectedProfile;
@property (nonatomic, assign) NSInteger activeProfileOnStatusScreen;

- (UUID *)getUUIDForDeviceWith:(NSString *)foundID;
- (BOOL)updateSavedProfilesWithNewProfileOfName: (NSString*)filename andDescription:(NSString *)description andLocation:(NSString *)location;
- (BOOL)updateSavedProfilesByRemovingCustomProfileAtIndex:(int)index;
- (BOOL)updateKnownControllersWithDevice:(NSString *)newID andName: (NSString *)newName andProfile: (NSString *)newProfile;
- (int)getKnownControllersCount;
-(int)getSavedProfileIndexFor:(NSString *)filename;
-(NSString *)getProfileFileFor:(NSString *)filename;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
