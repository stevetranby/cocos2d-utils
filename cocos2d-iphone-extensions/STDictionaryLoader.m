//
//  STDictionaryLoader.m
//
//  Created by Steve Tranby on 1/26/13.
//  Copyright (c) 2013 Steve Tranby. All rights reserved.
//

#import "STDictionaryLoader.h"
#import "CCFileUtils.h"

@implementation STDictionaryLoader

#pragma mark - Loading Config Files

+(NSArray*)loadArrayFromPlist:(NSString*)plist
{
    NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:plist];
	NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

+(NSMutableArray*)loadMutableArrayFromPlist:(NSString*)plist
{
    NSMutableArray* mutableArray = nil;
    NSString* path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:plist];
    mutableArray = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
    return mutableArray;
}

+(NSDictionary*)loadDictionaryFromPlist:(NSString*)plist
{
    NSString* path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:plist];
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:path];
    return dict;
}

+(NSMutableDictionary*)loadMutableDictionaryFromPlist:(NSString*)plist
{
    NSMutableDictionary* mutableDict = nil;
    NSString* path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:plist];
    mutableDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
    return mutableDict;
}

#pragma mark - iOS Specific Documents Directory

// TODO: maybe rename this class to something like STFileHelper
//       also need to utilize CCFileUtils where possible more
//       and make platform versions (or ifdef) for each where to store "saves"
+(NSDictionary*)loadDictFromDocumentsWithFilename:(NSString*)filename
{
    NSMutableDictionary* mutableDict = nil;
    
    // Get documents directory
	NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *docDir = [arrayPaths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, filename];
    mutableDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
    return mutableDict;
}

+(BOOL)writeToDocumentsWithDict:(NSDictionary*)dict
                       Filename:(NSString*)plistFilename
{
    // Get documents directory
	NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *docDir = [arrayPaths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, plistFilename];
	return [dict writeToFile:path atomically:YES];
}

@end
