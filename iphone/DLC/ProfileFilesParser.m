//
//  FileParser.m
//  DLC
//
//  Created by mr king on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileFilesParser.h"
#import "GDataXMLNode.h"
#import "ProfileList.h"
#import "ProfileFile.h"

@implementation ProfileFilesParser

+ (NSString *)dataFilePath:(BOOL)forSave 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"ProfileList.xml"];
    
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) 
    {
        return documentsPath;
    }
    else 
    {
        return [[NSBundle mainBundle] pathForResource:@"ProfileList" ofType:@"xml"];
    }
}

+ (SavedProfiles *)loadSavedProfiles
{
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    
    if (doc == nil) 
    { 
        return nil; 
    }
    
    SavedProfiles *savedList = [[SavedProfiles alloc] init];
    savedList.profileList.defaultProfileList = [self loadProfileListForType:@"//ProfileList//DefaultProfileList/ProfileFile" inDocument:doc];
    savedList.profileList.customProfileList = [self loadProfileListForType:@"//ProfileList//CustomProfileList/ProfileFile" inDocument:doc];
    
    xmlData = nil;
    return (savedList);
}

+ (NSMutableArray *)loadProfileListForType:(NSString *)nodeType inDocument:(GDataXMLDocument *)document
{
    NSArray *listMembers = [document nodesForXPath:nodeType error:nil];
    NSMutableArray *loadedList = [[NSMutableArray alloc] init];

    for (GDataXMLElement *listMember in listMembers) 
    {
        NSString    *filename;
        NSString    *name;
        NSString    *description;
        
        // Filename
        NSArray *filenames = [listMember elementsForName:@"Filename"];
        if (filenames.count > 0) 
        {
            GDataXMLElement *firstFilename = (GDataXMLElement *) [filenames objectAtIndex:0];
            filename = firstFilename.stringValue;
        } 
        else 
            continue;
        
        // Name
        NSArray *names = [listMember elementsForName:@"Name"];
        if (names.count > 0) 
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
            name = firstName.stringValue;
        } 
        else 
            continue;
        
        // Description
        NSArray *descriptions = [listMember elementsForName:@"Description"];
        if (descriptions.count > 0) 
        {
            GDataXMLElement *firstDescription = (GDataXMLElement *) [descriptions objectAtIndex:0];
            description = firstDescription.stringValue; 
        } 
        else 
            continue;
        
        ProfileFile *file = [[ProfileFile alloc] initWithFilename:filename controllerName:name andDescription:description];
        [loadedList addObject:file];
    }
    
    document = nil;
    return (loadedList);
}

+ (void)saveProfiles:(SavedProfiles *)profilesToSave
{    
    GDataXMLElement *listElement = [GDataXMLNode elementWithName:@"ProfileList"];

    GDataXMLElement *defaultListElement = [self createElementWithName:@"DefaultProfileList" fromProfileList:profilesToSave.profileList.defaultProfileList];
    [listElement addChild:defaultListElement];
    
    GDataXMLElement *customListElement = [self createElementWithName:@"CustomProfileList" fromProfileList:profilesToSave.profileList.customProfileList ];
    [listElement addChild:customListElement];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:listElement];
    NSData *xmlData = document.XMLData;
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

+ (GDataXMLElement*)createElementWithName:(NSString *)elementName fromProfileList:(NSMutableArray *)list
{
    GDataXMLElement *listElement = [GDataXMLNode elementWithName:elementName];
    
    for (ProfileFile *file in list) 
    {
        GDataXMLElement * profileElement = [GDataXMLNode elementWithName:@"ProfileFile"];
        GDataXMLElement * filenameElement = [GDataXMLNode elementWithName:@"Filename" stringValue:file.filename];
        GDataXMLElement * nameElement = [GDataXMLNode elementWithName:@"Name" stringValue:file.name];
        GDataXMLElement * descriptionElement = [GDataXMLNode elementWithName:@"Description" stringValue:file.description];
        
        [profileElement addChild:filenameElement];
        [profileElement addChild:nameElement];
        [profileElement addChild:descriptionElement];
        [listElement addChild:profileElement];
    }
    
    return (listElement);
}

@end
