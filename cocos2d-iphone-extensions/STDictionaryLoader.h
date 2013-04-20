//
//  STDictionaryLoader.h
//
//  Created by Steve Tranby on 1/26/13.
//  Copyright (c) 2013 Steve Tranby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STDictionaryLoader : NSObject

+(NSArray*)loadArrayFromPlist:(NSString*)plist;
+(NSMutableArray*)loadMutableArrayFromPlist:(NSString*)plist;
+(NSDictionary*)loadDictionaryFromPlist:(NSString*)plist;
+(NSMutableDictionary*)loadMutableDictionaryFromPlist:(NSString*)plist;

+(NSDictionary*)loadDictFromDocumentsWithFilename:(NSString*)filename;
+(BOOL)writeToDocumentsWithDict:(NSDictionary*)dict
                       Filename:(NSString*)filename;

@end
