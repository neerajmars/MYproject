//
//  AppDelegate.m
//  DLC
//
//  Created by A King on 14/02/2013.
//  Copyright (c) 2013 A King. All rights reserved.
//
#import "AppDelegate.h"
#import "ProfileFilesParser.h"
#import "ProfileFile.h"
#import "ProfileList.h"
#import "UUIDsFileParser.h"
#import "UUID.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"
#include "constants.h"
#include "FileManagerVC.h"
#import "iPhoneFileManagerViewController.h"


@implementation AppDelegate
@synthesize savedProfiles;
@synthesize knownControllerIDs;
@synthesize window = _window;
@synthesize filePath;
@synthesize modelNumberStr;
@synthesize importFile;
@synthesize activeProfileOnStatusScreen;
//@synthesize selectedProfile;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    importFile=0;
   // selectedProfile=0;
    //detect device type //text = [UIDevice currentDevice].model;
    // Override point for customization after application launch.
    savedProfiles = [ProfileFilesParser loadSavedProfiles];
    knownControllerIDs = [UUIDsFileParser loadSavedControllerIDs];
    tbc = (TabVC *)self.window.rootViewController;
    /*if (savedProfiles != nil)
     {
     for (ProfileFile *file in savedProfiles.profileList.defaultProfileList)
         NSLog(@"DEFAULT: %@ %@ %@", file.filename, file.name, file.description);
     for (ProfileFile *file in savedProfiles.profileList.customProfileList)
         NSLog(@"CUSTOM: %@ %@ %@", file.filename, file.name, file.description);
     }*/
    
     /*if (knownControllerIDs != nil)
     {
     for (UUID *device in knownControllerIDs.knownUUIDs)
     NSLog(@"%@ %@ %@", device.controllerID, device.controllerName, device.profileFilename);
     }*/
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Setup in plist file for this app not to run in the background. Means any DLCs will automatically timeout & disconnect.
}

- (UUID *)getUUIDForDeviceWith:(NSString *)foundID
{
    for (UUID *i in knownControllerIDs.knownUUIDs)
    {
        if ([i.controllerID isEqualToString:foundID])
        {
            return (i);
        }
    }
    return (nil);
}

- (BOOL)updateSavedProfilesWithNewProfileOfName: (NSString*)filename andDescription:(NSString *)description andLocation:(NSString *)location
{
    ProfileFile* newProfile = [[ProfileFile alloc] initWithFilename:filename controllerName:location andDescription:description];
    bool replacedFileDetails = false;
    
    // If this filename already exists in the saved profile list then update it instead of adding a useless duplicate.
    if (savedProfiles != nil)
    {
        for (ProfileFile *file in savedProfiles.profileList.customProfileList)
        {
            if ([file.filename isEqualToString:filename])
            {
                replacedFileDetails = true;
                file.name = location;
                file.description = description;
                break;
            }
        }
    }

    if (replacedFileDetails == false)
    {
        [savedProfiles.profileList.customProfileList addObject:newProfile];
    }
    
    [ProfileFilesParser saveProfiles:savedProfiles];
    return (YES);
}

- (BOOL)updateSavedProfilesByRemovingCustomProfileAtIndex:(int)index
{
    if (index < savedProfiles.profileList.customProfileList.count)
    {
        [savedProfiles.profileList.customProfileList removeObjectAtIndex:index];
        [ProfileFilesParser saveProfiles:savedProfiles];
        return (YES);
    }
    return (NO);
}

- (BOOL)updateKnownControllersWithDevice:(NSString *)newID andName: (NSString *)newName andProfile: (NSString *)newProfile
{
    //already got this UUID?
    for (UUID *i in knownControllerIDs.knownUUIDs)
    {
        if ([i.controllerID isEqualToString:newID])
        {
            i.controllerName = newName;
            i.profileFilename = newProfile;
            [UUIDsFileParser saveDevices:knownControllerIDs];
            return (YES);
        }
    }
    
    //append new UUID
    UUID *newUUID = [[UUID alloc] initWithControllerID:newID andName:newName andProfile:newProfile];
    [knownControllerIDs.knownUUIDs addObject:newUUID];
    [UUIDsFileParser saveDevices:knownControllerIDs];
    return (YES);
}

- (int)getKnownControllersCount
{
    return ((int)[knownControllerIDs.knownUUIDs count]);
}

-(int)getSavedProfileIndexFor:(NSString *)filename
{
    int index = NO_FILE_SELECTED;
    
    if (savedProfiles != nil)
    {
        int i = 0;
        for (ProfileFile * profile in savedProfiles.profileList.defaultProfileList)
        {
            if ([profile.filename isEqualToString:filename])
            {
                return (i);
            }
            
            i++;
        }

        i = 0;
        for (ProfileFile * profile in savedProfiles.profileList.customProfileList)
        {
            if ([profile.filename isEqualToString:filename])
            {
                return (100 + i);
            }
            
            i++;
        }
        
    }
    
    return (index);
}

-(NSString *)getProfileFileFor:(NSString *)filename
{
    if (savedProfiles != nil)
    {
        for (ProfileFile * profile in savedProfiles.profileList.defaultProfileList)
        {
            if ([profile.filename isEqualToString:filename])
            {
                return (profile.description);
            }
        }
        
        for (ProfileFile * profile in savedProfiles.profileList.customProfileList)
        {
            if ([profile.filename isEqualToString:filename])
            {
                return (profile.description);
            }
        }
    }
    return (nil);
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (url)
    {
        importFile=1;
        filePath=url.path;
        [tbc setSelectedIndex:kPROFILE_TAB];
        [self moveToProfiles];
    }
    return YES;
}


- (void)moveToProfiles
{
    [tbc setSelectedIndex:kFILE_TAB];
}
@end

