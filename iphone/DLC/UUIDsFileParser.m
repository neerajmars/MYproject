//
//  UUIDsFileParser.m
//  DLC
//
//  Created by mr king on 26/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UUIDsFileParser.h"
#import "GDataXMLNode.h"
#import "UUID.h"

@implementation UUIDsFileParser

+ (NSString *)dataFilePath:(BOOL)forSave 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"UUIDs.xml"];
    
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) 
    {
        return documentsPath;
    }
    else 
    {
        return [[NSBundle mainBundle] pathForResource:@"UUIDs" ofType:@"xml"];
    }
}

+ (UUIDs *)loadSavedControllerIDs
{
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    
    if (doc == nil) 
    { 
        return nil; 
    }
    
    UUIDs *savedList = [[UUIDs alloc] init];
    savedList.knownUUIDs = [self loadListForType:@"//UUIDs/UUID" inDocument:doc];    
    xmlData = nil;
    return (savedList);
}

+ (NSMutableArray *)loadListForType:(NSString *)nodeType inDocument:(GDataXMLDocument *)document
{
    NSArray *listMembers = [document nodesForXPath:nodeType error:nil];
    NSMutableArray *loadedList = [[NSMutableArray alloc] init];
    
    for (GDataXMLElement *listMember in listMembers) 
    {
        NSString *controllerID;
        NSString *controllerName;
        NSString    *filename;
        
        // Filename
        NSArray *filenames = [listMember elementsForName:@"ControllerID"];
        if (filenames.count > 0) 
        {
            GDataXMLElement *firstFilename = (GDataXMLElement *) [filenames objectAtIndex:0];
            controllerID = firstFilename.stringValue;
        } 
        else 
            continue;
        
        // Name
        NSArray *names = [listMember elementsForName:@"ModelNo"];
        if (names.count > 0) 
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
            controllerName = firstName.stringValue;
        } 
        else 
            continue;
        
        // Description
        NSArray *descriptions = [listMember elementsForName:@"ProfileName"];
        if (descriptions.count > 0) 
        {
            GDataXMLElement *firstDescription = (GDataXMLElement *) [descriptions objectAtIndex:0];
            filename = firstDescription.stringValue; 
        } 
        else 
            continue;
        
        UUID *device = [[UUID alloc] initWithControllerID:controllerID andName:controllerName andProfile:filename];
        [loadedList addObject:device];
    }
    
    document = nil;
    return (loadedList);
}

+ (void)saveDevices:(UUIDs *)idsToSave
{    
    GDataXMLElement *listElement = [self createElementWithName:@"UUIDs" fromList:idsToSave.knownUUIDs];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:listElement];
    NSData *xmlData = document.XMLData;
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

+ (GDataXMLElement*)createElementWithName:(NSString *)elementName fromList:(NSMutableArray *)list
{
    GDataXMLElement *listElement = [GDataXMLNode elementWithName:elementName];
    
    for (UUID *device in list) 
    {
        GDataXMLElement * UUIDElement = [GDataXMLNode elementWithName:@"UUID"];
        GDataXMLElement * idElement = [GDataXMLNode elementWithName:@"ControllerID" stringValue:[NSString stringWithFormat:@"%@", device.controllerID]];
        GDataXMLElement * modelElement = [GDataXMLNode elementWithName:@"ModelNo" stringValue:[NSString stringWithFormat:@"%@", device.controllerName]];
        GDataXMLElement * filenameElement = [GDataXMLNode elementWithName:@"ProfileName" stringValue:device.profileFilename];
        
        [UUIDElement addChild:idElement];
        [UUIDElement addChild:modelElement];
        [UUIDElement addChild:filenameElement];
        [listElement addChild:UUIDElement];
    }
    
    return (listElement);
}

@end
