//
//  iPhoneWebViewController.m
//  iDimObit
//
//  Created by mr Ankit Singhal on 25/08/2016.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "iPhoneWebViewController.h"
#import "iPhoneFindViewController.h"
#include "constants.h"

@interface iPhoneWebViewController ()

@end

@implementation iPhoneWebViewController
@synthesize failedToLoadLabel;
@synthesize activityIndicator;
@synthesize webPageView;
@synthesize delegate;

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
    [self setWebPageView:nil];
    [self setActivityIndicator:nil];
    [self setFailedToLoadLabel:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    webPageView.delegate = self;
    webPageView.scalesPageToFit = YES;
    NSURL *url = [[NSURL alloc] initWithString:DLC_URL];
    [webPageView loadRequest:[NSURLRequest requestWithURL:url]];
    
    failedToLoadLabel.hidden = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    webPageView.hidden = YES;    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    
    // !!!! Force web page to scale to fit page (checkbox option & this don't work) - scales to iPad.
    //CGSize contentSize = webPageView.scrollView.contentSize;
    //CGSize viewSize = self.view.bounds.size;
    //float rw = viewSize.width / contentSize.width;
    //webPageView.scrollView.minimumZoomScale = rw;
    //webPageView.scrollView.maximumZoomScale = rw;
    //webPageView.scrollView.zoomScale = rw;
    
    webPageView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    activityIndicator.hidden = YES;
    failedToLoadLabel.hidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
