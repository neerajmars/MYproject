//
//  iPhoneSchedulerViewController.m
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneSchedulerViewController.h"
#import "iPhoneProfileNameViewController.h"
#import "iPhoneWeekViewController.h"
#import "iPhoneTabBarController.h"

#import "ASJOverflowButton.h"
#import "webViewController.h"
@interface iPhoneSchedulerViewController ()<UIGestureRecognizerDelegate>
{
    NSString *selectedHr,*selectedMin;
    
    int lablTag,lablTag2;
     UILabel *titlelbl;
    
}

@property (strong, nonatomic) ASJOverflowButton *overflowButton;
@property (copy, nonatomic) NSArray *overflowItems;
- (void)setup;
- (void)setupDefaults;
- (void)setupOverflowItems;
- (void)setupOverflowButton;
- (void)handleOverflowBlocks;

@end

@implementation iPhoneSchedulerViewController
@synthesize syncButton;
@synthesize scheduleEnabledSwitch;
@synthesize timer;
@synthesize hideAllView;
@synthesize days;
@synthesize profiles;
@synthesize hours;
@synthesize minutes;
@synthesize title;
@synthesize picker;

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
    
    profiles = [[NSArray alloc] initWithObjects: NSLocalizedString(@"WEEK_PROFILE1", nil), NSLocalizedString(@"WEEK_PROFILE2", nil), nil];
    days = [[NSArray alloc] initWithObjects: NSLocalizedString(@"WEEK_MONDAY", nil), NSLocalizedString(@"WEEK_TUESDAY", nil),NSLocalizedString(@"WEEK_WEDNESDAY", nil),NSLocalizedString(@"WEEK_THURSDAY", nil),NSLocalizedString(@"WEEK_FRIDAY", nil),NSLocalizedString(@"WEEK_SATURDAY", nil),NSLocalizedString(@"WEEK_SUNDAY", nil), nil];
    hours = [[NSArray alloc] initWithObjects: @"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", nil];
    minutes = [[NSArray alloc] initWithObjects:@"00", @"05", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", nil];
    
   // titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
   // self.navigationItem.titleView = titlelbl;
   // titlelbl.textAlignment=NSTextAlignmentCenter;
   // titlelbl.text=@"Scheduler";
    UIBarButtonItem * leftBarBtnItm = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helvarLogo.png"]]];
    self.navigationItem.leftBarButtonItem = leftBarBtnItm;
    
    [self mehodForHidePickerVw];
}
-(void)mehodForHidePickerVw
{
    UITapGestureRecognizer * tapOnSchedulerImgVw=[[UITapGestureRecognizer alloc] initWithTarget:self    action:@selector(tapOnSchedulerImgVwGestureAction:)];
    _schedulerImgVw.userInteractionEnabled=YES;
    
   // [self.schedulerImgVw setNumberOfTapsRequired:1];
    [self.schedulerImgVw addGestureRecognizer:tapOnSchedulerImgVw];
    
}
-(void)tapOnSchedulerImgVwGestureAction:(UITapGestureRecognizer *)gesture
{
    picker.hidden=YES;
    _saveBtn.hidden=YES;
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [self setSyncButton:nil];
    [self setScheduleEnabledSwitch:nil];
    [self setHideAllView:nil];
    [timer invalidate];
    [self setTimer:nil];
    [self setSyncButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    [self setTimer:nil];
    [self storeValuesToControllerImage];
    syncButton.enabled = NO;
    
    picker.hidden=YES;
    _saveBtn.hidden=YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{ 
    [self setParentVC:(iPhoneTabBarController *)[[self parentViewController] parentViewController]];
    if ((parentVC.offline == NO) && (parentVC.readAllDLCSettings == NO))
    {
        [self.view bringSubviewToFront:hideAllView];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerExpired) userInfo:nil repeats:YES];
    }
    else
    {
        [self showScheduleInfo];
    }
}

- (void)timerExpired
{
    if ((parentVC.offline == YES) || (parentVC.readAllDLCSettings == YES))
    {
        [timer invalidate];
        [self setTimer:nil];
        
        if ((parentVC.readAllDLCSettings == YES) && ([parentVC passwordOK] == NO))
        {
            parentVC.offline = YES;
            [controller initialiseControllerData];
        }
        
        [self showScheduleInfo];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return kComponentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case kProfileComponent:
            return 2;
        case kDayComponent:
            return 7;
        case kHoursComponent:
            return 24;
        case kMinutesComponent:
            return 12;
        default:
            return 0;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case kProfileComponent:
            return (NSLocalizedString(@"WEEK_PROFILES", nil));
        case kDayComponent:
            return (NSLocalizedString(@"WEEK_DAYS", nil));
        case kHoursComponent:
            return (NSLocalizedString(@"WEEK_HOURS", nil));
        case kMinutesComponent:
            return (NSLocalizedString(@"WEEK_MINUTES", nil));
        default:
            return (NSLocalizedString(@"GEN_UNKNOWN", nil));
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labels;
    labels = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,32)];
    labels.backgroundColor= [UIColor clearColor];
    labels.font = [UIFont fontWithName:@"Helvetica" size:17];
    labels.textAlignment = NSTextAlignmentCenter;
    switch (component)
    {
        case kProfileComponent:
            labels.text = [profiles objectAtIndex:row];
            break;
        case kDayComponent:
            labels.text = [days objectAtIndex:row];
            break;
        case kHoursComponent:
            labels.text = [hours objectAtIndex:row];
            break;
        case kMinutesComponent:
            labels.text = [minutes objectAtIndex: row];
            break;
        default:
            labels.text = @"";
            break;
    }
    
    return labels;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component)
    {
        case kProfileComponent:
            return 80.0f;
        case kDayComponent:
            return 120.0f;
        case kHoursComponent:
            return 55.0f;
        case kMinutesComponent:
            return 55.0f;
        default:
            return 55.0f;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedDay = [pickerView selectedRowInComponent:kDayComponent];
    selectedProfile = [pickerView selectedRowInComponent:kProfileComponent];
    
    selectedTime.hours24Clock    =[hours[[picker selectedRowInComponent:2]] longLongValue];
    selectedTime.minutes    =[minutes[[picker selectedRowInComponent:3]] longLongValue];
}

- (void)showScheduleInfo
{
    [self.view sendSubviewToBack:hideAllView];
    [self loadValuesFromControllerImage];
    [self updateGUI:scheduleEnabled];
    [self updateSyncButton];
}

-(void)updateGUI:(BOOL)enabled
{
    scheduleEnabledSwitch.on = scheduleEnabled;
    
    UIColor *color = [UIColor grayColor];
    BOOL flag=NO;
    if (enabled == YES){
        color = [UIColor colorWithRed:4.0/255.0 green:125.0/255.0 blue:192.0/255.0 alpha:1.0];
    flag=YES;
}
    for (int tag = 10; tag < 17; tag++)
    {
        UITapGestureRecognizer * tap;
        UILabel *label;
        label = (UILabel *)[self.view viewWithTag:tag];
        if (flag==YES) {
           tap=[[UITapGestureRecognizer alloc] initWithTarget:self    action:@selector(tapGestureOnLabelAction:)];
            [label setUserInteractionEnabled:YES];
            [tap setNumberOfTapsRequired:1];
            [label addGestureRecognizer:tap];
        }else
        {
          flag=NO;
       [label setUserInteractionEnabled:NO];
                                                                                                        
        }
         label.text = [[NSString alloc] initWithFormat:@"%02ld:%02ld", (long)profile1Time[tag - 10].hours24Clock, (long)profile1Time[tag - 10].minutes];
        label.textColor = color;
        
    }
    
    for (int tag = 20; tag < 27; tag++)
    {
        UILabel *label1;
        UITapGestureRecognizer * tap11;
        label1 = (UILabel *)[self.view viewWithTag:tag];
        if (flag==YES) {
            tap11=[[UITapGestureRecognizer alloc] initWithTarget:self    action:@selector(tapGestureOnLabelAction:)];
            [label1 setUserInteractionEnabled:YES];
            [tap11 setNumberOfTapsRequired:1];
            [label1 addGestureRecognizer:tap11];
        }
        else{
            flag=NO;
        [label1 setUserInteractionEnabled:NO];
        }
         label1.text = [[NSString alloc] initWithFormat:@"%02ld:%02ld", (long)profile2Time[tag - 20].hours24Clock, (long)profile2Time[tag - 20].minutes];
            label1.textColor = color;
        
    }}
-(void)tapGestureOnLabelAction:(UITapGestureRecognizer *)gesture{
    NSLog(@"%ld", gesture.view.tag);
    if (gesture.view.tag>=10 && gesture.view.tag<17) {
        selectedProfile=PROFILE1;
        selectedTime=profile1Time[gesture.view.tag-10];
        switch (gesture.view.tag) {
            case 10:
                selectedDay=MONDAY;
                break;
            case 11:
                selectedDay=TUESDAY;
                break;
            case 12:
                selectedDay=WEDNESDAY;
                break;
            case 13:
                selectedDay=THURSDAY;
                break;
            case 14:
                selectedDay=FRIDAY;
                break;
            case 15:
                selectedDay=SATURDAY;
                break;
            case 16:
                selectedDay=SUNDAY;
                break;
                
            default:
                break;
        }
    }
    else{
        selectedProfile=PROFILE2;
        selectedTime=profile2Time[gesture.view.tag-20];
        switch (gesture.view.tag) {
            case 20:
                selectedDay=MONDAY;
                break;
            case 21:
                selectedDay=TUESDAY;
                break;
            case 22:
                selectedDay=WEDNESDAY;
                break;
            case 23:
                selectedDay=THURSDAY;
                break;
            case 24:
                selectedDay=FRIDAY;
                break;
            case 25:
                selectedDay=SATURDAY;
                break;
            case 26:
                selectedDay=SUNDAY;
                break;
                
            default:
                break;
        }
    }
    lablTag=gesture.view.tag;
    lablTag2=gesture.view.tag;
    [picker selectRow:selectedProfile inComponent:kProfileComponent animated:YES];
    [picker selectRow:selectedDay inComponent:kDayComponent animated:YES];
    [picker selectRow:selectedTime.hours24Clock inComponent:kHoursComponent animated:YES];
    [picker selectRow:(selectedTime.minutes / 5) inComponent:kMinutesComponent animated:YES];
    self.picker.hidden=NO;
    self.saveBtn.hidden=NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)toWeekView:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toWeekView" sender:self];
}

- (IBAction)writeScheduleToController:(UIButton *)sender
{
    syncButton.enabled = NO;
    [self storeValuesToControllerImage];
    [parentVC writeScheduleSettings];
}

- (IBAction)updateScheduleEnable:(UISwitch *)sender
{
        scheduleEnabled = sender.on;
        [self updateGUI:sender.on];
        [self storeValuesToControllerImage];
        [self updateSyncButton];
    }
- (IBAction)ClkOnSaveBtn:(id)sender
{
    [self updateScheduleForDay:selectedDay forProfile:selectedProfile andWithStartTime:selectedTime];
    [self updateGUI:YES];
  //  self.picker.hidden=YES;
  //  self.saveBtn.hidden=YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toWeekView"])
    {
        ((iPhoneWeekViewController *)segue.destinationViewController).delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"toProfileNameViewFromSchedule"])
    {
        ((iPhoneProfileNameViewController *)segue.destinationViewController).delegate = self;
    }
}

//delegate (called from iPhoneWeekViewController)
- (void)updateScheduleForDay:(DayOfWeek)chosenDay forProfile:(Profile)chosenProfile andWithStartTime:(TimeOfDay)time
{
    if (chosenProfile == PROFILE1)
    {
        profile1Time[chosenDay].hours24Clock = time.hours24Clock;
        profile1Time[chosenDay].minutes = time.minutes;
        [self storeValuesToControllerImage];
    }
    else if (chosenProfile == PROFILE2)
    {
        profile2Time[chosenDay].hours24Clock = time.hours24Clock;
        profile2Time[chosenDay].minutes = time.minutes;
        [self storeValuesToControllerImage];
    }
    [self updateSyncButton];
}

-(void)updateSyncButton
{
    if ([controller userChangedSettings])
        syncButton.enabled = YES;
    else
        syncButton.enabled = NO;
    
    if (parentVC.offline == YES)
        syncButton.enabled = NO;
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
    
    
    ASJOverflowItem *item = [ASJOverflowItem itemWithName:NSLocalizedString(@"STATUS_HELP", nil) titlecheck:@"helpScheduler"];
    
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
    
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sync.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_overflowButton,rightBarBtn,nil];
    self.navigationItem.rightBarButtonItems[1].enabled=NO;
     self.navigationItem.rightBarButtonItem = _overflowButton;
}

- (void)handleOverflowBlocks
{
    
    
    [_overflowButton setItemTapBlock:^(ASJOverflowItem *item, NSInteger idx)
     {
         if([item.titlecheck  isEqual: @"helpScheduler"]){
             UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
             webViewController *theTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"helpViewSection"];
             theTabBar.tempName = @"Scheduler_Help";
             theTabBar.tempTitle = NSLocalizedString(@"SCHEDULER_PAGE_HELP", nil);
             [self.navigationController pushViewController:theTabBar animated:YES];
         }else{
             
         }
     }];
    
    [_overflowButton setHideMenuBlock:^{
        NSLog(@"hidden");
    }];
}
@end
