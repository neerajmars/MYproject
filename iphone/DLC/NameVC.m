//
//  NameVC.m
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NameVC.h"
#import "iPhoneTabBarController.h"
#import "DLCOne.h"
#import "AppDelegate.h"
#import "ProfileFile.h"
#import "ProfileFilesParser.h"

@interface NameVC ()

@end

@implementation NameVC

@synthesize delegate;
@synthesize callingScreen;
@synthesize originalXmlFilename;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setDelegate:nil];
    [self setController:nil];
    [self setOriginalXmlFilename:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadValuesFromControllerImage
{
    description = [controller getdeviceDescription];
    location = [controller getdeviceLocation];
    filename = [controller getProfileName];
    originalXmlFilename = [[NSString alloc] initWithString:filename];
}

- (void)storeValuesToControllerImage
{
}

- (BOOL)invalidFilename:(NSString *)newFilename
{
    if ([self validTextString:newFilename] == YES)
    {
        return (NO);
    }
    else 
    {
        return (YES);
    }
}

- (BOOL)validTextString:(NSString *)text
{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NO_BLANK_SPACE", nil) message: nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    BOOL valid = NO;
    if(([text isEqualToString:@""] == NO) && ([text isEqualToString:nil] == NO))
    {
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789._-"] invertedSet];
        NSLog(@"%lu",(unsigned long)[text rangeOfCharacterFromSet:set].location);
        if ([text rangeOfCharacterFromSet:set].location == NSNotFound) 
        {
            valid = YES;
        }
        else{
            [alertDialog show];
        }
    }
    else{
        [alertDialog show];
    }
    
    return (valid);
}

- (BOOL)savedXMLFileWithName:(NSString *)newFilename andDescription:(NSString *)newDescription andLocation:(NSString*)newLocation
{
    BOOL savedOK = NO;
        
    if ([self validTextString:newFilename] == YES)
    {
        NSString *xmlFilename = [self ensureXMLExtension:newFilename];
        [controller setProfileName:xmlFilename andDescription:newDescription andLocation:newLocation];
        [controller setDeviceNameWith: newLocation];
        [controller saveDLCOneConfigurationToFilename:xmlFilename];
        savedOK = YES;
        
        if ([xmlFilename isEqualToString:originalXmlFilename] == NO)
        {
            filename = xmlFilename;
        }

        description = newDescription;
        location = newLocation;
        [self updateProfileListAndKnownControllers];
    }

    return (savedOK);
}

- (NSString *)ensureXMLExtension:(NSString *)text
{
    NSString *substring = @".dtl";
    NSRange textRange = [[text lowercaseString] rangeOfString:[substring lowercaseString]];
    NSString *xmlFilename = text;
    
    if (textRange.location == NSNotFound)
    {
        textRange = [[text lowercaseString] rangeOfString:[@"." lowercaseString]];
        if (textRange.location == NSNotFound)
        {
            xmlFilename = [NSString stringWithFormat:@"%@.dtl", text];
        }
        else 
        {
            NSArray* split = [text componentsSeparatedByString: @"."];
            NSString* rootFilename = [split objectAtIndex: 0];  
            xmlFilename = [NSString stringWithFormat:@"%@.dtl", rootFilename];
        }
    }
    
    return (xmlFilename);
}

- (void)updateProfileListAndKnownControllers
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate updateSavedProfilesWithNewProfileOfName:filename andDescription:description andLocation:location];
    [appDelegate updateKnownControllersWithDevice:[controller getDeviceID] andName:[controller getDeviceName] andProfile:filename];
}

@end
