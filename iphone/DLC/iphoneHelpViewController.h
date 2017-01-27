//
//  iphoneHelpViewController.h
//  DLC
//
//  Created by NEERAJ KUMAR on 18/12/16.
//  Copyright © 2016 A King. All rights reserved.
//

#ifndef iphoneHelpViewController_h
#define iphoneHelpViewController_h


#endif /* iphoneHelpViewController_h */

#import <UIKit/UIKit.h>




@interface iphoneHelpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
 IBOutlet UITableView *myTableView;  
int selectedIndex;
    
  NSMutableArray *myData;
}




@end
