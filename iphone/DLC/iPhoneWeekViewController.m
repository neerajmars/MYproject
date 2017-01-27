//
//  iPhoneWeekViewController.m
//  DLC
//
//  Created by mr king on 19/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhoneWeekViewController.h"
#import "iPhoneSchedulerViewController.h"

@interface iPhoneWeekViewController ()

@end

@implementation iPhoneWeekViewController
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
	// Do any additional setup after loading the view.
    profiles = [[NSArray alloc] initWithObjects: NSLocalizedString(@"WEEK_PROFILE1", nil), NSLocalizedString(@"WEEK_PROFILE2", nil), nil];
    days = [[NSArray alloc] initWithObjects: NSLocalizedString(@"WEEK_MONDAY", nil), NSLocalizedString(@"WEEK_TUESDAY", nil),NSLocalizedString(@"WEEK_WEDNESDAY", nil),NSLocalizedString(@"WEEK_THURSDAY", nil),NSLocalizedString(@"WEEK_FRIDAY", nil),NSLocalizedString(@"WEEK_SATURDAY", nil),NSLocalizedString(@"WEEK_SUNDAY", nil), nil];
    hours = [[NSArray alloc] initWithObjects: @"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", nil];
    minutes = [[NSArray alloc] initWithObjects:@"00", @"05", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", nil];
    
    [self didRotateFromInterfaceOrientation:(UIInterfaceOrientation)NULL];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [self setDays:nil];
    [self setProfiles:nil];
    [self setHours:nil];
    [self setMinutes:nil];
    [self setTitle:nil];
    [self setPicker:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadValuesFromControllerImage];

    selectedProfile = PROFILE1;
    selectedDay = MONDAY;
    
    [picker selectRow:selectedProfile inComponent:kProfileComponent animated:YES];
    [picker selectRow:selectedDay inComponent:kDayComponent animated:YES];
    [picker selectRow:selectedTime.hours24Clock inComponent:kHoursComponent animated:YES]; 
    [picker selectRow:(selectedTime.minutes / 5) inComponent:kMinutesComponent animated:YES]; 
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
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,32)];
    label.backgroundColor= [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor whiteColor];
    
    switch (component) 
    {
        case kProfileComponent:
            label.text = [profiles objectAtIndex:row];
            break;
        case kDayComponent:
            label.text = [days objectAtIndex:row];
            break;
        case kHoursComponent:
            label.text = [hours objectAtIndex:row];
            break;
        case kMinutesComponent:
            label.text = [minutes objectAtIndex: row];
            break;
        default:
            label.text = @"";
            break;
    }
    
    return label;
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
    selectedTime.hours24Clock = [pickerView selectedRowInComponent:kHoursComponent];
    selectedTime.minutes = [pickerView selectedRowInComponent:kMinutesComponent] * 5; //in steps of 5 mins
}

- (IBAction)saveScheduleChanges:(UIButton *)sender 
{
    [self storeValuesToControllerImage];
}

- (IBAction)backToSchedulerView:(UIButton *)sender 
{
    ((iPhoneSchedulerViewController *)self.delegate).weekViewVisible = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showCurrentScheduleTime:(UIButton *)sender 
{
    [self loadValuesFromControllerImage];
    
    [picker selectRow:selectedProfile inComponent:kProfileComponent animated:YES];
    [picker selectRow:selectedDay inComponent:kDayComponent animated:YES];
    [picker selectRow:selectedTime.hours24Clock inComponent:kHoursComponent animated:YES]; 
    [picker selectRow:(selectedTime.minutes / 5) inComponent:kMinutesComponent animated:YES]; 
}

@end
