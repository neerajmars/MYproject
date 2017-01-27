//
//  iPhonePurchaseViewControllerViewController.m
//  DLC
//
//  Created by mr king on 24/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iPhonePurchaseViewController.h"
#import "iPhoneFindViewController.h"
#include "constants.h"

@interface iPhonePurchaseViewController ()

@end

@implementation iPhonePurchaseViewController
@synthesize completedLabel;
@synthesize delegate;
@synthesize makePurchaseButton;

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
    completedLabel.hidden = YES;
    
    //setup in-app purchase stuff
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    NSSet *products = [NSSet setWithObjects:kPURCHASE, nil];
    request = [[SKProductsRequest alloc] initWithProductIdentifiers:products];
    [request setDelegate:self];
    [request start];
}

- (void)viewDidUnload
{
    [self setCompletedLabel:nil];
    [self setDelegate:nil];
    [self setMakePurchaseButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    request = nil;
    product = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)makeInAppPurchase:(id)sender 
{
    UIAlertView *alertDialog;
    
    if ([SKPaymentQueue canMakePayments]) 
    {
        // Display a store to the user.
        NSString *myMessage = [[NSString alloc] initWithString: NSLocalizedString(@"PURCHASE_WANT_QU", nil)];
        alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"PURCHASE_TITLE", nil) message: myMessage delegate:self cancelButtonTitle:NSLocalizedString(@"GEN_NO", nil) otherButtonTitles:NSLocalizedString(@"GEN_YES", nil), nil];
    } 
    else 
    {
        // Warn the user that purchases are disabled.
        NSString *myMessage = [[NSString alloc] initWithFormat:NSLocalizedString(@"PURCHASE_DISABLED_WARNING", nil), nil];
        alertDialog = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"PURCHASE_TITLE", nil) message: myMessage delegate:self  cancelButtonTitle: @"OK" otherButtonTitles:nil];
        makePurchaseButton.hidden = YES;
    }
    
    alertDialog.alertViewStyle = UIAlertViewStyleDefault;
    [alertDialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"GEN_YES", nil)])
    {
        makePurchaseButton.hidden = YES;
        
        if (product != nil)
        {
            SKPayment *payRequest = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payRequest];  
        }
        else 
        {
            UIAlertView *alertDialog;
            NSString *myMessage = [[NSString alloc] initWithFormat:NSLocalizedString(@"PURCHASE_SORRY", nil)];
            alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"PURCHASE_TITLE", nil) message: myMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alertDialog.alertViewStyle = UIAlertViewStyleDefault;
            [alertDialog show];
        }
    }
}

#pragma mark -
#pragma mark in-app purchase
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSInteger count = [response.products count];
    NSLog(@"number of products present:%ld",(long)count);
    
    for (SKProduct *aProduct in response.products)
    {
        if ([aProduct.productIdentifier isEqualToString:kPURCHASE])
        {
            product = aProduct;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored:
            {
                //if ([transaction.payment.productIdentifier isEqualToString:kPurchaseInGameHints])
                [queue finishTransaction:transaction];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setInteger:(NSInteger)1 forKey:kPURCHASE];
                [userDefaults synchronize];
                completedLabel.hidden = NO;
                UIAlertView *alertDialog;
                NSString *myMessage = [[NSString alloc] initWithFormat:NSLocalizedString(@"PURCHASE_SUCCESS", nil)];
                alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"PURCHASE_TITLE", nil) message: myMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertDialog.alertViewStyle = UIAlertViewStyleDefault;
                [alertDialog show];
                break;
            }
                
            case SKPaymentTransactionStateFailed:
            {
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                makePurchaseButton.hidden = NO;
                
                if (transaction.error.code != SKErrorPaymentCancelled) 
                {
                    UIAlertView *alertDialog;
                    NSString *myMessage = [[NSString alloc] initWithFormat:NSLocalizedString(@"PURCHASE_CANCELLED", nil)];
                    alertDialog = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"PURCHASE_TITLE", nil) message: myMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    alertDialog.alertViewStyle = UIAlertViewStyleDefault;
                    [alertDialog show];
                }
                break;
            }
                
            default:
                break;
        }
    }
}

@end
