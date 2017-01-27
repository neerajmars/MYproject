 //
//  iPhoneFindViewController.m
//  DLC
//
//  Created by mr king on 18/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneFindViewController.h"
#import "iPhoneTabBarController.h"
#import "iPhoneWebViewController.h"
#import "iPhonePurchaseViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UUID.h"
#import "FindVC.h"
#import "ASJOverflowButton.h"
#import "webViewController.h"

typedef enum
{
    kDEFAULT_SECTION,
    kCONTROLLER_SECTION,
    kNUM_SECTIONS
} FindTableSection;

typedef enum
{
    kUnknown,
    kDLC1,
    kNUM_CONTROLLER_TYPES
} ControllerModel;

@interface iPhoneFindViewController ()
{
    UIView * sliderVw;

}

@property (strong, nonatomic) ASJOverflowButton *overflowButton;
@property (copy, nonatomic) NSArray *overflowItems;

- (void)setup;
- (void)setupDefaults;
- (void)setupOverflowItems;
- (void)setupOverflowButton;
- (void)handleOverflowBlocks;
@end


@implementation iPhoneFindViewController
@synthesize scanButton;
@synthesize controllerTableView;
@synthesize scanTimer;
@synthesize searchNavigationItem;
@synthesize selectedSignalStrengthLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    UIImage *image = [UIImage imageNamed: @"iDimOrbitNewLogo"];
    image = [self imageWithImage:image scaledToSize:CGSizeMake(100, 30)];
    UIImageView *logoView = [[UIImageView alloc] initWithImage: image];
    searchNavigationItem.titleView = logoView;
    
    isDefaultPassword=YES;
    controllersFound = 0;
    controllerTableView.hidden = NO;
    controllerImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"sensorImage.jpg"], [UIImage imageNamed:@"sensorImage.jpg"], nil];
    menuItems = [[NSArray alloc] initWithObjects:NSLocalizedString(@"FIND_WEBSITE", nil), NSLocalizedString(@"FIND_CREDITS", nil), nil];
     [self setParentVC:(iPhoneTabBarController *)[[self parentViewController] parentViewController]];
    [self setNewControllerWithUUID:@""];
    parentVC.offline = YES;
   // UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"Scan" style:UIBarButtonItemStylePlain target:self action:@selector(ClkOnScanBtn:)];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menuright.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(helpviewaction:)];
                                                                              
                                                                              
    //self.navigationItem.rightBarButtonItem=rightBarBtn;
   // UIBarButtonItem *rightBarBtn2=[[UIBarButtonItem alloc]initWithTitle:@"Scan2" style:UIBarButtonItemStylePlain target:self action:@selector(ClkOnScanBtn:)];
    
    UIBarButtonItem *rightBarBtn2=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(ClkOnScanBtn:)];
  //  self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarBtn,rightBarBtn2,nil];

    
    UIBarButtonItem * leftBarBtnItm = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helvarLogo.png"]]];
    self.navigationItem.leftBarButtonItem = leftBarBtnItm;
    
    [self showSliderVw];
    
  
    
    
    /*......This for Country Code....*/
    
     //  [self loadValuesFromControllerImage];
    //    [self FindDSTSettingCodeForFirmware];
    //    [self storeValuesToControllerImage];
  
}
-(void)showSliderVw
{
    sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, controllerTableView.frame.size.width, 70.0)];
    
    sliderVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
  //  [self.view addSubview:sliderVw];
    [sectionHeaderView addSubview:sliderVw];
    self.proximityValue=5;
    self.selectedSignalStrengthLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 2, self.view.frame.size.width-100, 20)];
    self.selectedSignalStrengthLabel.text=[NSString stringWithFormat:NSLocalizedString(@"FIND_FILDER_BY_STRENGTH", nil)];
    selectedSignalStrengthLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:11.0f];
    [sliderVw addSubview:self.selectedSignalStrengthLabel];
    selectedSignalStrengthLabel.textAlignment=NSTextAlignmentCenter;
    
    
    UISlider *signalStrengthSlider=[[UISlider alloc]initWithFrame:CGRectMake(40, 30, self.view.frame.size.width-80, 15)];
    [sliderVw addSubview:signalStrengthSlider];
    [signalStrengthSlider setValue:0.5];
    
    [signalStrengthSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [signalStrengthSlider addTarget:self action:@selector(stoppedDragging:) forControlEvents:UIControlEventTouchUpInside];
    [signalStrengthSlider addTarget:self action:@selector(stoppedDragging:) forControlEvents:UIControlEventTouchUpOutside];

    UIImageView *lowStrengthImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(23, 25, 15, 15)];
    lowStrengthImgVw.image=[UIImage imageNamed:@"signalStrength1.png"];
    [sliderVw addSubview:lowStrengthImgVw];
    
    UIImageView *highStrengthImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, 25, 20, 15)];
    highStrengthImgVw.image=[UIImage imageNamed:@"signalStrength5.png"];
    [sliderVw addSubview:highStrengthImgVw];
    
    controllerLbl=[[UILabel alloc]initWithFrame:CGRectMake(25, 50, 200, 25)];
    controllerLbl.textColor=[UIColor darkGrayColor];
    controllerLbl.font=[UIFont fontWithName:@"Helvetica" size:14.0f];
    [sectionHeaderView addSubview:controllerLbl];
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    self.proximityValue = ceil(sender.value*9 - 0.5f) + 1;  // To get 1 - 10 slider with equal spacing.
    
//    self.selectedSignalStrengthLabel.text = [NSString stringWithFormat:@"Find Orbits with signal strength: %ld", (long)self.proximityValue];
    self.selectedSignalStrengthLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FIND_FILDER_BY_STRENGTH", nil)];
    
    
}
- (IBAction)stoppedDragging:(UISlider *)sender {
    
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(long)self.proximityValue  forKey:@"proximity"];
    [defaults synchronize];
    [self startScanning:self.navigationItem.rightBarButtonItem];
        for (int i=0; i<=controllersFound; i++) {
    
            NSNumber *rssi = [parentVC getDeviceRSSI:i];
            int rssiFloat = rssi.intValue*-1 ;
            NSLog(@"%d" ,rssiFloat/10);
            if (rssiFloat/10==(long)self.proximityValue) {
                [controllerTableView reloadData];
            }
        }
}
-(void)ClkOnScanBtn: (id)sender
{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(long)self.proximityValue  forKey:@"proximity"];
    [self startScanning:sender];
    [controllerTableView reloadData];
}

-(void)helpviewaction: (id)sender
{
 [self performSegueWithIdentifier:@"helpview" sender:self];
    
}

- (void)viewDidUnload
{
    [self setScanButton:nil];
    [self setControllerTableView:nil];
    [self setSearchNavigationItem:nil];
    [super viewDidUnload];
    controllerImages = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
   [parentVC.tabBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setParentVC:(iPhoneTabBarController *)[[self parentViewController] parentViewController]];
    [self showReloadButton];
    [controllerTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}
-(void)viewDidDisappear:(BOOL)animated
{
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return (newImage);
}

- (void)showReloadButton
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)showActivityIndicator
{
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (IBAction)startScanning:(UIButton *)sender
{
  
    [self setControllerOfflineAndNotSelected:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"FIND_SERCHING", nil)];
    [self startScanning];
    controllerTableView.allowsSelection = NO;
    [controllerTableView reloadData];
}

-(void)moveToInAppPurchase
{
    [self performSegueWithIdentifier:@"toInAppPurchase" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toWebView"])
    {
        ((iPhoneWebViewController *)segue.destinationViewController).delegate = self;
       // [parentVC.tabBar setHidden:YES];
    }
    else if ([[segue identifier] isEqualToString:@"toInAppPurchase"])
    {
        ((iPhonePurchaseViewController *)segue.destinationViewController).delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"toCredits"])
    {
        //((iPhonePurchaseViewController *)segue.destinationViewController).delegate = self; TODO:put back in later
    }
//    if ([[segue identifier] isEqualToString:@"toInAppPurchase"])
//    {
//        ((iPhonePurchaseViewController *)segue.destinationViewController).delegate = self;
//    }
    
}

- (void)scanTimerExpired
{
    [self findTimerExpired];
    
    if ([self controllersFoundChanged] == YES)
    {        
        [controllerTableView reloadData];
    }
    else
    {
        [SVProgressHUD dismiss];
        [self showReloadButton];
        controllerTableView.allowsSelection = YES;
    }
    
    if (controllersFound == 0)
    {
        [self showReloadButton];
    }
}

- (void)loginTimerExpired
{
    if (parentVC.readAllDLCSettings == YES)
    {
        [self invalidateTimer];
        [controllerTableView reloadData];
        
        if ([parentVC passwordOK] == YES)
        {            
            [self initialiseControllerOnline];
            isDefaultPassword=NO;
            
            
            if (parentVC.passwordIsDefault == YES)
            {
                [self showEditPasswordBox];
            }
        }
        else //incorrect password
        {
            [self initialiseIncorrectPassword];
            parentVC.offline = YES;
            scanButton.enabled = YES;
        }
    }
    else
    {
        if (++loginDelayCount >= 10)
        {
            [self failedToReadPassword];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (kNUM_SECTIONS);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kDEFAULT_SECTION)
    {
        if ((parentVC.offline == NO) && ([parentVC passwordOK] == YES))
            return (1);
        else
            return (1);
    }
    else
    {
        return (controllersFound);
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == kDEFAULT_SECTION)
    {
        return 0;
    }
    else
    {
        return 70;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == kDEFAULT_SECTION)
    {
        return 0;
    }
    else
    {
        if (controllersFound == 0)
            controllerLbl.text= (NSLocalizedString(@"FIND_NO_CONTROLLERS_FOUND", nil));
        else
            controllerLbl.text= (NSLocalizedString(@"FIND_CONTROLLERS_FOUND", nil));
        return sectionHeaderView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == kDEFAULT_SECTION)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"titleCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = menuItems[indexPath.row];
        
        if (indexPath.row > 1)
        {
          //  cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return (cell);
    }
    else
    {
        NSString* name;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DLCCell"];
    
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DLCCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];

        int index;
        NSString * uuidStr = foundUUIDs[indexPath.row];
        UUID* deviceDetails = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) getUUIDForDeviceWith:foundUUIDs[indexPath.row]];
        
        name = [[NSString alloc] initWithString:[parentVC getUUIDName:(int)indexPath.row]];
        if (deviceDetails != nil)
        {
            index = kDLC1;
        }
        else
        {
            index = [self getImageForDeviceWith:name];
        }
    
    NSNumber *rssi = [parentVC getDeviceRSSI:indexPath.row];
    float rssiFloat = rssi.floatValue;
    NSLog(@" RSSSI VALUE%f",rssiFloat*-1);
        UIImage *signalImage;
        cell.textLabel.text =[NSString stringWithFormat:@"%@",name] ;
    if (rssiFloat>0) {
        if (rssiFloat>100) {
          //  cell.textLabel.text =[NSString stringWithFormat:@"%@   %@",name,@"100"] ;
            
            signalImage=[UIImage imageNamed:@"signalStrength5.png"];
            
        }
        else{
          //  cell.textLabel.text =[NSString stringWithFormat:@"%@   %d",name,[rssi intValue]] ;
            signalImage=[UIImage imageNamed:@"signalStrength4.png"];
        }
        
    }
    else{
      //  cell.textLabel.text =[NSString stringWithFormat:@"%@   %d",name,[rssi intValue]*-1] ;
        if ([rssi intValue]*-1>0 && [rssi intValue]*-1 <=20)
        {
            signalImage=[UIImage imageNamed:@"signalStrength1.png"];
        }
        else if ([rssi intValue]*-1>20 && [rssi intValue]*-1 <=40)
        {
            signalImage=[UIImage imageNamed:@"signalStrength2.png"];
        }
        else if ([rssi intValue]*-1>40 && [rssi intValue]*-1 <=70)
        {
            signalImage=[UIImage imageNamed:@"signalStrength3.png"];
        }
        else if ([rssi intValue]*-1>70 && [rssi intValue]*-1 <=90)
        {
            signalImage=[UIImage imageNamed:@"signalStrength4.png"];
        }
        else if ([rssi intValue]*-1>90 && [rssi intValue]*-1 <=100)
        {
            signalImage=[UIImage imageNamed:@"signalStrength5.png"];
        }
    }

        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", uuidStr];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:8.0f];

        UIImage *cellImage = [controllerImages objectAtIndex:index];
        cell.imageView.image = cellImage;
        [cell sizeToFit];

        UIImageView *signalImgVw=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 20, 20, 20)];
        [cell.contentView addSubview:signalImgVw];
        signalImgVw.image=signalImage;
        
    
    editDeviceNmBtn=[[UIButton alloc]initWithFrame:CGRectMake(90, 52, 100, 20)];
    [cell.contentView addSubview:editDeviceNmBtn];
    [editDeviceNmBtn setBackgroundColor:[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0]];
    [editDeviceNmBtn setTitle:@"Edit device Name" forState:UIControlStateNormal];
    editDeviceNmBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    editDeviceNmBtn.tag=indexPath.row+1;
    [editDeviceNmBtn addTarget:self action:@selector(ClkOnEditDeviceNmBtn :) forControlEvents:UIControlEventTouchUpInside];
    
    editDevicePwdBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 52, 100, 20)];
    [cell.contentView addSubview:editDevicePwdBtn];
    [editDevicePwdBtn setBackgroundColor:[UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0]];
    [editDevicePwdBtn setTitle:@"Edit Password" forState:UIControlStateNormal];
    editDevicePwdBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    editDevicePwdBtn.tag=indexPath.row+100;
    [editDevicePwdBtn addTarget:self action:@selector(ClkOnEditDevicePwdBtn :) forControlEvents:UIControlEventTouchUpInside];
    editDeviceNmBtn.hidden=YES;
    editDevicePwdBtn.hidden=YES;
    
        if ([self selectedControllerEquals: (int)indexPath.row] == YES)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIButton *editDeviceNmBtnWithTag = (UIButton *)[controllerTableView viewWithTag:indexPath.row+1];
            UIButton *editDevicePwdBtnWithTag = (UIButton *)[controllerTableView viewWithTag:indexPath.row+100];
            editDeviceNmBtnWithTag.hidden=NO;
            editDevicePwdBtnWithTag.hidden=NO;

        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIButton *editDeviceNmBtnWithTag1 = (UIButton *)[controllerTableView viewWithTag:indexPath.row+1];
            UIButton *editDevicePwdBtnWithTag1 = (UIButton *)[controllerTableView viewWithTag:indexPath.row+100];
            editDeviceNmBtnWithTag1.hidden=YES;
            editDevicePwdBtnWithTag1.hidden=YES;
        }
        return cell;  
    }
}

- (int)getImageForDeviceWith:(NSString *)controllerName
{
    int model = kUnknown;
    NSString *trimmed = [controllerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([[trimmed uppercaseString] rangeOfString:@"DLC"].location != NSNotFound)
    {
        model = kDLC1;
    }
    return (model);
}
-(void)ClkOnEditDeviceNmBtn:(id)sender
{
    [self showEditDeviceName];
    
}
-(void)ClkOnEditDevicePwdBtn:(id)sender
{
    [self showEditPasswordBox];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kDEFAULT_SECTION)
    {
        switch (indexPath.row)
        {
            case 0:
                [self performSegueWithIdentifier:@"toWebView" sender:self];
                break;
            case 1:
               [self performSegueWithIdentifier:@"toCredits" sender:self];
                break;
            case 2:
                [self setControllerOfflineAndNotSelected:YES];
                [self.tabBarController setSelectedIndex:kFILE_TAB];
                break;
            case 3:
                [self showEditPasswordBox];
                break;
            case 4:
                [self showEditDeviceName];
                break;
            default:
                break;
        }
    }
    else
    {
//        if ([self exceededMaximumControllersCountingUUID:foundUUIDs[indexPath.row]] == YES)
//        {
//            [self moveToInAppPurchase];
//        }
    // else
     if ([self loggedOntoController:(int)indexPath.row] == YES)
        {
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]initWithTitle:nil message: NSLocalizedString(@"DO_YOU_WANT_TO_DISCONNECT_OR_CONTINUE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"FIND_DISCONNECT", nil) otherButtonTitles: NSLocalizedString(@"CONTINUE", nil), nil];
          
            [alertDialog show];
         //   [self.tabBarController setSelectedIndex:kSTATUS_TAB];
            
        }
        else
        {
            UIAlertView *alertDialog;
            UUID* deviceDetails = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) getUUIDForDeviceWith:foundUUIDs[indexPath.row]];
            tableRowSelected = indexPath.row;
            [self setSelectedController:(int)indexPath.row];
            xmlFilename = deviceDetails.profileFilename;
            //[controller setDeviceNameWith:deviceDetails.controllerName];
            //[controller setProfileFilename:deviceDetails.profileFilename];
            [tableView reloadData];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_LOGIN", nil) message: NSLocalizedString(@"FIND_ENTER_PASSCODE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GEN_CANCEL", nil) otherButtonTitles: NSLocalizedString(@"FIND_LOGIN", nil), nil];
            alertDialog.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alertDialog show];
        }
    
    }
//}
}

- (NSString *)getLengthCheckedNewPassword:(NSString *)newPassword
{
    NSString * lengthCheckedPassword = newPassword;
    // Define the range you're interested in
    NSRange stringRange = {0, MIN([newPassword length], 5)};
    
    // adjust the range to include dependent chars
    stringRange = [newPassword rangeOfComposedCharacterSequencesForRange:stringRange];
    
    // Now you can create the short string
    NSString *shortString = [newPassword substringWithRange:stringRange];
    lengthCheckedPassword = shortString;
    return (lengthCheckedPassword);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"FIND_CHANGE", nil)])
    {
        if (editingDeviceName == YES)
        {
            [controller setDeviceNameWith:[[alertView textFieldAtIndex:0] text]];
            [parentVC writeDeviceInformation];
            parentVC.editingDeviceName = YES;
            [NSThread sleepForTimeInterval:0.5];
            [parentVC disconnectFromActivePeripheral];
            [self startScanning];
            editDeviceNmBtn.hidden=YES;
            editDevicePwdBtn.hidden=YES;
        }
        else if ([self confirmedPassword] == NO)
        {
            parentVC.password1 = [self getLengthCheckedNewPassword:[[alertView textFieldAtIndex:0] text]];
            
            if ([parentVC.password1 isEqualToString:DEFAULT_PASSWORD])
                [self showInvalidPasswordBox];
            else
                [self showReconfirmPasswordBox];
        }
        else
        {
            UIAlertView *alertDialog;
            parentVC.password2 = [self getLengthCheckedNewPassword:[[alertView textFieldAtIndex:0] text]];
            
            if (([parentVC.password1 isEqualToString:parentVC.password2]) && ([parentVC.password1 isEqualToString:@""] == NO))
            {
                [controller setPassword:parentVC.password1];
                [self writeNewPasswordToController];
                alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_LOGIN", nil) message: NSLocalizedString(@"FIND_PASSWORD_CHANGED", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            else
            {
                alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FIND_LOGIN", nil) message: NSLocalizedString(@"FIND_MISMATCH_PASSCODE", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            [alertDialog show];
        }
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"FIND_LOGIN", nil)])
    {
        
        parentVC.password2 = [self getLengthCheckedNewPassword:[[alertView textFieldAtIndex:0] text]];
        int controllerIndex = (int)[self parentVC].selectedController;
        NSString * foundDeviceID = foundUUIDs[controllerIndex];
        
        [self setNewControllerWithUUID:foundDeviceID];
       
        [controller initialiseControllerData];
        [parentVC connectToPeripheral: (int)tableRowSelected];
       
        //Allow select different DLC: was [self parentVC].selectedController];
        [self startLoginTimer];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"])
    {
        //nothing to do
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"FIND_QUIT", nil)])
    {
        //nothing to do
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"GEN_UPDATE", nil)])
    {
        exit(0);
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"CONTINUE", nil)])
    {
        [self.tabBarController setSelectedIndex:kSTATUS_TAB];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"FIND_DISCONNECT", nil)])
    {
        [parentVC disconnectFromActivePeripheral];
        [self startScanning];
    }
    else //cancel
    {
        [self setControllerOfflineAndNotSelected:YES];
        scanButton.enabled = YES;
    }

    editingDeviceName = NO;
    [controllerTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kDEFAULT_SECTION)
    {
        return (45);
    }
    else
    {
        return (75);
    }
}

//*----------Function For Find Code of DSTSeeting---------------*
-(void)FindDSTSettingCodeForFirmware
{
    
    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSLog(@"Country Code is:- %@",countryCode);
    
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    NSLog(@"countryArray:-%lu",(unsigned long)countryArray.count);
    NSLog(@"Country Code are:- %@",countryArray);
    
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity: [[NSLocale ISOCountryCodes] count]];
    
    for (NSString *countryCode in [NSLocale ISOCountryCodes])
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: country];
    }
    NSLog(@"country Name Array :-%@",countries);
    
    if ([countryCode isEqualToString:@"IN"]) {
        dstSetting=1;
    }
    else{
        dstSetting=2;
    }
    
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
    
    
    ASJOverflowItem *item = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"helpSearch"];
    ASJOverflowItem *item2 = [ASJOverflowItem itemWithName:NSLocalizedString(@"ABOUT_TITLE_SEARCH", nil) titlecheck:@"aboutSearch"];
    [temp addObject:item];
    [temp addObject:item2];
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
    _overflowButton.itemTextColor = [UIColor blueColor];
    _overflowButton.menuBackgroundColor = [UIColor whiteColor];
    _overflowButton.itemHighlightedColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    _overflowButton.menuMargins = MenuMarginsMake(7.0f, 7.0f, 7.0f);
    _overflowButton.separatorInsets = SeparatorInsetsMake(10.0f, 5.0f);
    _overflowButton.menuAnimationType = MenuAnimationTypeZoomIn;
    _overflowButton.itemFont = [UIFont fontWithName:@"Verdana" size:13.0f];
    
   
    UIBarButtonItem *rightBarBtn2=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(ClkOnScanBtn:)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_overflowButton,rightBarBtn2,nil];
   // self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks
{
    
   
    [_overflowButton setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx)
     {
         if([item.titlecheck  isEqual: @"helpSearch"]){
             
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
      webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"search";
             theTabBar.tempTitle = NSLocalizedString(@"HELP_TITLE_SEARCH", nil);
             [self.navigationController pushViewController:theTabBar animated:YES];
           // [self performSegueWithIdentifier:@"helpview" sender:self];
         
         } else if([item.titlecheck  isEqual: @"aboutSearch"]){
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"About_Us";
             theTabBar.tempTitle = NSLocalizedString(@"ABOUT_TITLE_SEARCH", nil);
             [self.navigationController pushViewController:theTabBar animated:YES];
             
         }
     }];
    
    [_overflowButton setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}

@end
