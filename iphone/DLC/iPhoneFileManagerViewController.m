//
//  iPhoneFileManagerViewController.m
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneFileManagerViewController.h"
#import "iPhoneTabBarController.h"
#import "AppDelegate.h"
#import "ProfileList.h"
#import "ProfileFile.h"
#import "ProfileFilesParser.h"
#import "NameVC.h"
#include "constants.h"
#import "ASJOverflowButton.h"
#import "webViewController.h"

typedef enum
{
    kDEFAULT_SECTION,
    kCUSTOM_SECTION,
    kNUM_SECTIONS
} FileTableSection;

@interface iPhoneFileManagerViewController (){
    UILabel *titlelbl;
    NSString *filename;
    NSInteger importfile;
    int overwriteFile_Section;
    int overwriteFile_row;
    int overwriteFile_SelectedFile;
    BOOL isCheckMark;
    BOOL selectedCheckMarkIndex;
    NSString *filePath;
}

@property (strong, nonatomic) ASJOverflowButton *overflowButton;
@property (copy, nonatomic) NSArray *overflowItems;

- (void)setup;
- (void)setupDefaults;
- (void)setupOverflowItems;
- (void)setupOverflowButton;
- (void)handleOverflowBlocks;

@end

@implementation iPhoneFileManagerViewController
@synthesize fileTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
 
    [super viewDidLoad];
     [self setup];
    
    images = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"FileManger.png"], [UIImage imageNamed:@"FileManger.png"], nil];
	// Do any additional setup after loading the view.
    
    titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.navigationItem.titleView = titlelbl;
    titlelbl.textAlignment=NSTextAlignmentCenter;
    titlelbl.text=NSLocalizedString(@"FM_TITLE", nil);
    UIBarButtonItem * leftBarBtnItm = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helvarLogo.png"]]];
    self.navigationItem.leftBarButtonItem = leftBarBtnItm;
    
    
    profileFolderNameArray=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"FM_DEFAULT", nil), NSLocalizedString(@"FM_OFFICE", nil),NSLocalizedString(@"FM_CLASSROOMS", nil), nil];
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
}
- (void)viewDidUnload
{
    [self setFileTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    appDelegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    savedProfiles = appDelegate.savedProfiles;
    noCustomProfileFiles = [savedProfiles.profileList.customProfileList count];
    noDefaultProfileFiles = [savedProfiles.profileList.defaultProfileList count];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%ld",(long)appDelegate.importFile);
    if (appDelegate.importFile==1) {
        receiveFilePath=appDelegate.filePath;
        [self setParentVC:(iPhoneTabBarController *)[[self parentViewController] parentViewController]];
        [self loadiDimOrbitConfigurationFromFile:appDelegate.filePath];
     
        NameVC *nameVC=[[NameVC alloc]init];
        
        NSLog(@"[controller getDeviceName]:-%@",[controller getDeviceName]);
        NSLog(@"[controller getDeviceName]:-%@",[controller getProfileName]);
        NSLog(@"[controller getDeviceName]:-%@",[controller getdeviceDescription]);
        NSLog(@"[controller getDeviceName]:-%@",[controller getdeviceLocation]);
        
        
      //  if ([nameVC savedXMLFileWithName:[controller getDeviceName] andDescription:[controller getdeviceDescription] andLocation:[controller getdeviceLocation]] == YES)
            if ([nameVC savedXMLFileWithName:[controller getProfileName] andDescription:[controller getdeviceDescription] andLocation:[controller getdeviceLocation]] == YES)
        {
            savedProfiles = appDelegate.savedProfiles;
            noCustomProfileFiles = [savedProfiles.profileList.customProfileList count];
            noDefaultProfileFiles = [savedProfiles.profileList.defaultProfileList count];
           // [self loadiDimOrbitConfigurationFromFile:appDelegate.filePath];
        }
        appDelegate.importFile=0;
        
    }
    [self setParentVC:(iPhoneTabBarController *)[[self parentViewController] parentViewController]];
    [fileTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)moveToProfiles
{
    [self.tabBarController setSelectedIndex:kPROFILE_TAB];
}
- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  //  return (noDefaultProfileFiles+1);
    return (noDefaultProfileFiles-1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if ([self tableView:tableView canCollapseSection:section])
        {
            if ([expandedSections containsIndex:section])
            {
// old
//                if (section>=0 && section<noDefaultProfileFiles) {
//                    return 2;
//                }
//                 else if (section==noDefaultProfileFiles)
//                 {
//                    return (noCustomProfileFiles+1);
//                }
                
 //  New
                if (section==0) {
                    return 2;
                }
                else if (section==1)
                {
                    return 3;
                }
                else if (section==2)
                {
                    return 3;
                }
                else if (section==noDefaultProfileFiles-2)
                {
                    return (noCustomProfileFiles+1);
                }

            }
    
            return 1; // only top row showing
        }
    
        // Return the number of rows in the section.
        return 1;
    
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //new...
    if (section == 0)
    {
    return (NSLocalizedString(@"FM_APPLICATION_FILES", nil));
    }
      //  else if (section==noDefaultProfileFiles)
    else if (section==noDefaultProfileFiles-2)
        {
            return (NSLocalizedString(@"FM_CUSTOM_APPLICATION_FILES", nil));
        }
        else{
            return @"";
        }
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger checkedFile = selectedFile;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"profileCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    } 
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0f];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.userInteractionEnabled = YES;
    
    // Configure the cell...
    
        if ([self tableView:tableView canCollapseSection:indexPath.section])
        {
            if (!indexPath.row)
            {
                // first row
               // only top row showing
                
                if (indexPath.section>=0 && indexPath.section<noDefaultProfileFiles-2)
                {
//                    ProfileFile *file = [savedProfiles.profileList.defaultProfileList objectAtIndex:indexPath.section];
//                    cell.textLabel.text = file.name;
                    
                    cell.textLabel.text=[NSString stringWithFormat:@"%@",profileFolderNameArray[indexPath.section]];
                    cell.detailTextLabel.text = @"";
                }
                else if (indexPath.section >= noCustomProfileFiles)
                {
                    cell.textLabel.text = NSLocalizedString(@"FM_CREATE_CUSTOM_FILE", nil);
                  //  cell.detailTextLabel.text = NSLocalizedString(@"FM_CREATE_BLANK_PROFILE", nil);
                    cell.detailTextLabel.text = @"";
                }
    
                UIImage *cellImage = [UIImage imageNamed:@"folder-icon.png"];
                cell.imageView.image = cellImage;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                // all other rows
                if (indexPath.section>=0 && indexPath.section<noDefaultProfileFiles-2)
                {
                    ProfileFile *file;
                    if (indexPath.section==0) {
                        file = [savedProfiles.profileList.defaultProfileList objectAtIndex:indexPath.section];
                    }
                    else if (indexPath.section==1)
                    {
                        if (indexPath.row==1) {
                            file = [savedProfiles.profileList.defaultProfileList objectAtIndex:1];
                        }
                        else if (indexPath.row==2)
                        {
                            file = [savedProfiles.profileList.defaultProfileList objectAtIndex:2];
                        }
                        
                    }
                    else if (indexPath.section==2)
                    {
                        if (indexPath.row==1) {
                            file = [savedProfiles.profileList.defaultProfileList objectAtIndex:3];
                        }
                        else if (indexPath.row==2)
                        {
                            file = [savedProfiles.profileList.defaultProfileList objectAtIndex:4];
                        }
                        
                    }
                    
                    cell.textLabel.text = file.name;
                    cell.detailTextLabel.text = file.description;
                }
                else
                {
                    if (savedProfiles.profileList.customProfileList.count>0)
                    {
                        ProfileFile *file = [savedProfiles.profileList.customProfileList objectAtIndex:indexPath.row-1];
                        cell.textLabel.text = file.name;
                        cell.detailTextLabel.text = file.description;
                    }
                
                }
                UIImage *cellImage = [UIImage imageNamed:@""];
                cell.imageView.image = cellImage;
            }
        }
        else
        {
            cell.accessoryView = nil;
            cell.textLabel.text = @"Normal Cell";
            
        }
    
    //is it the currently selected file?
    
//    if (((indexPath.section * 100) + indexPath.row) == checkedFile)
//    {
//        if (indexPath.row>0) {
//            if ( cell.accessoryType == UITableViewCellAccessoryCheckmark)
//            {
//                NSLog(@"Break point");
//                goto BAIL;
//            }
//        }
//    }
    

    
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
    {
        if (indexPath.row>0) {
            if (isCheckMark) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                isCheckMark=false;
                
            }
        
        }
        
    }
    else
    {
        if (indexPath.row>0)
        {
            
            if (isCheckMark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if (selectedCheckMarkIndex)
             {
                cell.accessoryType = UITableViewCellAccessoryNone;
                selectedCheckMarkIndex=false;
            }
         
        }
        
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alertDialog;
    
        if ([self tableView:tableView canCollapseSection:indexPath.section])
        {
            if (!indexPath.row)
            {
                // only first row toggles exapand/collapse
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                NSInteger section = indexPath.section;
                BOOL currentlyExpanded = [expandedSections containsIndex:section];
                NSInteger rows;
    
                NSMutableArray *tmpArray = [NSMutableArray array];
    
                if (currentlyExpanded)
                {
                    rows = [self tableView:tableView numberOfRowsInSection:section];
                    [expandedSections removeIndex:section];
    
                }
                else
                {
                    [expandedSections addIndex:section];
                    rows = [self tableView:tableView numberOfRowsInSection:section];
                }
                for (int i=1; i<rows; i++)
                {
                    NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                    [tmpArray addObject:tmpIndexPath];
                }
    
               // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
    
                if (currentlyExpanded)
                {
                    [tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationNone];
                }
                else
                {
                  //  [tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
                     [tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
        
        NSLog(@"section :%ld,row:%ld",(long)indexPath.section,(long)indexPath.row);
    selectedFile = (int)(indexPath.section * 100) + (int)indexPath.row;
    
    self.lastIndexPath = indexPath;
   
    
    if (indexPath.row>0) {
        alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FM_WHAT_WOULD_YOU_LIKE_TO_DO_WITH_THE_SELECTED_FILE", nil) message: NSLocalizedString(@"FM_LOADING_PROFILE_WARNING", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GEN_CANCEL", nil) otherButtonTitles: @"Import",@"Share", nil];
       
    }
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (isCheckMark) {
//        if (indexPath.row>0) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//    }
//    else{
//        cell.accessoryType=UITableViewCellStyleDefault;
//    }
     [fileTableView reloadData];
    
        alertDialog.alertViewStyle = UIAlertViewStyleDefault;
        [alertDialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    
    if ( [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share"] )
    {
        int section = selectedFile / 100;
        int row = selectedFile - (section * 100);
        
        //request blank form
        if ((section == noDefaultProfileFiles-2) && (row == noCustomProfileFiles+1))
        {
            NSString * password = [controller getPassword];
            [self setNewControllerWithUUID:@""];
            [self initialiseControllerImagePassword:password];
            [self setSelectedFile:selectedFile];
        }
        else if ((selectedFile != NO_FILE_SELECTED) || (section < kNUM_SECTIONS))
        {
            //load profile from file
            ProfileFile *file;
            if (section>=0 && section<noDefaultProfileFiles-2)
            {
                file = [savedProfiles.profileList.defaultProfileList objectAtIndex:section];
                
                 [self share:file.filename];
                            }
            else
            {
                file = [savedProfiles.profileList.customProfileList objectAtIndex:row-1];
                [self shareCustomFile:file.filename];
                
            }}
       
       
    }
    if ( [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Import"] )
    {
        
                 UIAlertView *alertDialog1;
                 alertDialog1 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"IT_WILL_OVERWRITE_EXISTING_SETTING", nil) message: NSLocalizedString(@"DO_YOU_WANT_TO_PROCEED", nil) delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: @"No", nil];
                [alertDialog1 show];
        
        
        overwriteFile_Section = selectedFile / 100;
        overwriteFile_row = selectedFile - (overwriteFile_Section * 100);
        overwriteFile_SelectedFile=selectedFile;
    }
    if ( [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"] )
    {
        
                //request blank form
                if ((overwriteFile_Section == noDefaultProfileFiles-2) && (overwriteFile_row == noCustomProfileFiles+1))
                {
                    NSString * password = [controller getPassword];
                    [self setNewControllerWithUUID:@""];
                    [self initialiseControllerImagePassword:password];
                    [self setSelectedFile:selectedFile];
                }
                else if ((overwriteFile_SelectedFile != NO_FILE_SELECTED) || (overwriteFile_Section < kNUM_SECTIONS))
                {
                    //load profile from file
                    ProfileFile *file;
                    if (overwriteFile_Section>=0 && overwriteFile_Section<noDefaultProfileFiles-2)
                    {
                        if (overwriteFile_Section==0) {
                            file = [savedProfiles.profileList.defaultProfileList objectAtIndex:overwriteFile_Section];
                        }
                        else if (overwriteFile_Section==1)
                        {
                            if (overwriteFile_row==1) {
                                file = [savedProfiles.profileList.defaultProfileList objectAtIndex:1];
                            }
                            else if (overwriteFile_row==2)
                            {
                                file = [savedProfiles.profileList.defaultProfileList objectAtIndex:2];
                            }
                        }
                        else if (overwriteFile_Section==2)
                        {
                            if (overwriteFile_row==1) {
                                file = [savedProfiles.profileList.defaultProfileList objectAtIndex:3];
                            }
                            else if (overwriteFile_row==2)
                            {
                                file = [savedProfiles.profileList.defaultProfileList objectAtIndex:4];
                            }
                        }
                        
                    }
                    else
                    {
                        file = [savedProfiles.profileList.customProfileList objectAtIndex:overwriteFile_row-1];
                    }
                    NSString * password = [controller getPassword];
        
                    [self loadDLCConfiguration:file.filename];
                    [self initialiseControllerImagePassword:password];
                    [self setSelectedFile:overwriteFile_SelectedFile];
                    [self moveToProfiles];
                    isCheckMark=true;
                    selectedCheckMarkIndex=true;
                    
                }
                else
                {
                    [self setSelectedFile: NO_FILE_SELECTED];
                    [fileTableView reloadData];
                }
    }
        else //cancel
        {
            [self loadValuesFromControllerImage];
            [fileTableView reloadData];
        }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewHeader = [[UIView alloc]init];
    viewHeader.frame = CGRectMake(0, 0, 320, 20);
    
    UILabel *viewHeaderLabel = [[UILabel alloc]init];
    viewHeaderLabel.frame = viewHeader.frame;
    viewHeaderLabel.textColor=[UIColor lightGrayColor];
    if (section == 0){
      //  NSLog(NSLocalizedString(@"FM_APPLICATION_FILES", nil));
        viewHeaderLabel.text = NSLocalizedString(@"FM_APPLICATION_FILES", nil);
    }else if (section==noDefaultProfileFiles-2){
       // NSLog(NSLocalizedString(@"FM_CUSTOM_APPLICATION_FILES", nil));
        viewHeaderLabel.text = NSLocalizedString(@"FM_CUSTOM_APPLICATION_FILES", nil);
    }else{
        viewHeaderLabel.text = @"";
    }
   // NSLog(@"Index of section, %ld",(long)section);
    [viewHeader addSubview:viewHeaderLabel];
    
    return viewHeader;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
     if ((indexPath.section>=0 && indexPath.section<noDefaultProfileFiles-2))
     {
         return (NO);
     }
    else if ((indexPath.section==noDefaultProfileFiles-2 && indexPath.row==0))
    {
        return (NO);
    }
    else{
        return (YES);
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ((indexPath.section>=0 && indexPath.section<noDefaultProfileFiles-2))
        {
            return;
        }
        else 
        {
            if (indexPath.row <= noCustomProfileFiles)
            {
                BOOL ok = [appDelegate updateSavedProfilesByRemovingCustomProfileAtIndex:(int)indexPath.row-1];
                
                if (ok == YES)
                {
                    noCustomProfileFiles--;
                    [fileTableView reloadData];
                    [self setSelectedFile:NO_FILE_SELECTED];
                }
            }
        }
    }
}

- (void) initialiseControllerImagePassword:(NSString *)password
{
    // Set password in controller image to match existing one if connected to a controller
    // or to the default password if offline or there is no current password.
    if ((parentVC.selectedController != NO_CONTROLLER_CONNECTED) && (parentVC.offline == FALSE) && (password != nil))
    {
        [controller setPassword:password];
    }
    else
    {
        [controller setPassword:DEFAULT_PASSWORD];
    }
}

- (void)share :file
{
    /* Share Functionality....*/
    NSArray *fileComponents = [file componentsSeparatedByString:@"."];
    
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:[fileComponents objectAtIndex:0] ofType:[fileComponents objectAtIndex:1]];
    NSURL *url =[NSURL fileURLWithPath:filePath1];
    NSArray *objectsToShare = @[url];

//    UIActivityViewController *controllers = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
//    
//    // Present the controller
//    [self presentViewController:controllers animated:YES completion:nil];

}

-(void)shareCustomFile:file
{
    
    filePath = [controller dataFilePath:TRUE andWithFilename:file];
    NSURL *url =[NSURL fileURLWithPath:filePath];
     NSArray *objectsToShare = @[url];
    
    UIActivityViewController *controllers = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    controllers.excludedActivityTypes=@[];
    // Present the controller
    [self presentViewController:controllers animated:YES completion:nil];
    
    
    
}


- (void)setup
{
    [self setupDefaults];
    [self setupOverflowItems];
    [self setupOverflowButton];
    [self handleOverflowBlocks];
}

- (void)setupDefaults
{
    
    
}

- (void)setupOverflowItems
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    
    ASJOverflowItem *item = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"helpFM"];
    
    [temp addObject:item];
    NSLog(@"%@", temp);
    _overflowItems = [NSArray arrayWithArray:temp];
}

- (void)setupOverflowButton
{
    UIImage *image = [UIImage imageNamed:@"Menuright"];
    
    _overflowButton = [[ASJOverflowButton alloc] initWithImage:image items:_overflowItems];
    _overflowButton.dimsBackground = YES;
    _overflowButton.hidesSeparator = NO;
    _overflowButton.hidesShadow = NO;
    _overflowButton.dimmingLevel = 0.3f;
    _overflowButton.menuItemHeight = 30.0f;
    _overflowButton.widthMultiplier = 0.5f;
    _overflowButton.itemHighlightedColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    _overflowButton.menuMargins = MenuMarginsMake(7.0f, 7.0f, 7.0f);
    _overflowButton.separatorInsets = SeparatorInsetsMake(10.0f, 5.0f);
    _overflowButton.menuAnimationType = MenuAnimationTypeZoomIn;
    _overflowButton.itemFont = [UIFont fontWithName:@"Verdana" size:13.0f];
    
    

    self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks
{
    
    
    [_overflowButton setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx)
     {
         if([item.titlecheck  isEqual: @"helpFM"]){
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"Manage_Files_Help";
             theTabBar.tempTitle = NSLocalizedString(@"APPLICATION_FILES_PAGE_HELP", nil);
             
             [self.navigationController pushViewController:theTabBar animated:YES];
         
         }else{
             
         }
     }];
    
    [_overflowButton setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}
@end
