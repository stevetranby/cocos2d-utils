//
//  STUtils.h
//
//  Created by Steve Tranby on 11/21/12.
//  Copyright (c) 2012 Steve Tranby. All rights reserved.
//
//  License: MIT
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)
-(NSArray*)reversedArray;
-(id)deepMutableCopy;
-(NSArray*)shuffled;
@end


@interface NSMutableArray (Utils)
-(void)reverse;
-(void)shuffle;
@end


@interface NSDictionary (Utilities)

-(BOOL)hasKey:(id)key;

- (double)doubleForKey:(id)key;
- (float)floatForKey:(id)key;
- (NSInteger)intForKey:(id)key;
- (NSUInteger)uintForKey:(id)key;
- (BOOL)boolForKey:(id)key;
- (CGPoint)pointForKey:(id)key;

- (id)objectForKey:(id)key Default:(id)nilDefault;
- (double)doubleForKey:(id)key Default:(double)nilDefault;
- (float)floatForKey:(id)key Default:(float)nilDefault;
- (NSInteger)intForKey:(id)key Default:(NSInteger)nilDefault;
- (NSUInteger)uintForKey:(id)key Default:(NSUInteger)nilDefault;
- (BOOL)boolForKey:(id)key Default:(BOOL)nilDefault;
- (CGPoint)pointForKey:(id)key Default:(CGPoint)nilDefault;

-(id)deepMutableCopy;

@end


@interface NSMutableDictionary (Utilities)

- (void)setDouble:(double)val forKey:(id)aKey;
- (void)setFloat:(float)val forKey:(id)aKey;
- (void)setInt:(NSInteger)val forKey:(id)aKey;
- (void)setUInt:(NSUInteger)val forKey:(id)aKey;
- (void)setBool:(BOOL)val forKey:(id)aKey;
- (void)setPoint:(CGPoint)val forKey:(id)key;

@end


@interface NSString (STUtils)

-(NSMutableString*)asMutableString;

-(NSData*)dataWithUTF8;
-(NSString*)stripWhitespace;

-(BOOL)isEmpty;
-(BOOL)isNotEmpty;
-(BOOL)isBlank;

-(BOOL)containsString:(NSString*)substring;

@end