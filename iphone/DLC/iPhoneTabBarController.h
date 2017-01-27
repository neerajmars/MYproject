//
//  iPhoneTabBarController.h
//  DLC
//
//  Created by mr king on 18/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabVC.h"

@interface iPhoneTabBarController : TabVC 
{
}
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

- (void)scanForPeripherals:(id)sender;

@end
