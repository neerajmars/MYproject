//
//  webViewController.m
//  DLC
//
//  Created by NEERAJ KUMAR on 19/12/16.
//  Copyright © 2016 A King. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()


@end

@implementation webViewController

@synthesize tempName,tempTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // NSString *localURL = [NSBundle pathForResource:@"index" ofType:@"html" inDirectory:NO];
    self.title = tempTitle  ;
   // NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *language = [[NSLocale currentLocale] localeIdentifier];
 
    NSString *myString = language;
    NSArray *myWords = [myString componentsSeparatedByString:@"_"];
       NSLog(@"Language: %@", myWords[0]);
    NSString *subStringURL = [NSString stringWithFormat:@"localed/%@",myWords[0]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:tempName ofType:@"html" inDirectory:subStringURL];
    
    NSString *pathdefault = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"html" inDirectory:@""];
    NSLog(@"path....newvvvvv...: %d", path.absolutePath);
       if(path.absolutePath == 0){
       NSURL *urldefault = [NSURL fileURLWithPath:pathdefault];
       [_mywebview loadRequest:[NSURLRequest requestWithURL:urldefault]];
       
       }
    
        else{
               NSURL *urlRequest = [NSURL fileURLWithPath:path];
               [_mywebview loadRequest:[NSURLRequest requestWithURL:urlRequest]];
            
        }
    NSLog(@"path.......: %@", tempName); 
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
