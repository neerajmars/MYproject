//
//  iPhoneFileManagerViewController.h
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileManagerVC.h"
@class AppDelegate;
@class SavedProfiles;

@interface iPhoneFileManagerViewController : FileManagerVC <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSInteger noDefaultProfileFiles;
    NSInteger noCustomProfileFiles;
      NSArray     *images;
    AppDelegate *appDelegate;
    SavedProfiles *savedProfiles;
    NSString *receiveFilePath;
    NSMutableIndexSet *expandedSections;
    NSMutableArray *profileFolderNameArray;
}

@property (strong, nonatomic) IBOutlet UITableView *fileTableView;
@property (strong, nonatomic) NSMutableArray *notes;
@property(strong)  NSIndexPath* lastIndexPath;

- (void)moveToProfiles;
@end
