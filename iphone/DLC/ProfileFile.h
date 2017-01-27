//
//  Profile.h
//  DLC
//
//  Created by mr king on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileFile : NSObject
{
    NSString    *filename;
    NSString    *name;
    NSString    *description;
}

@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;

- (id)initWithFilename:(NSString *)aFilename controllerName:(NSString *)aName andDescription:(NSString *)aDescription;
@end
