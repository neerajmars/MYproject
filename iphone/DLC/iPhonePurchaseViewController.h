//
//  iPhonePurchaseViewControllerViewController.h
//  DLC
//
//  Created by mr king on 24/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "BaseVC.h"

@interface iPhonePurchaseViewController : BaseVC  <UIAlertViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    SKProductsRequest   *request;
    SKProduct           *product;
}

@property (strong, nonatomic) IBOutlet UILabel *completedLabel;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIButton *makePurchaseButton;

- (IBAction)makeInAppPurchase:(id)sender;

@end
