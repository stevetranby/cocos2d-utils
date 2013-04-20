//
//  STUtils.m
//
//  Created by Steve Tranby on 11/21/12.
//  Copyright (c) 2012 Steve Tranby. All rights reserved.
//

#import "STUtils.h"

#import "FixCategoryBug.h"
FIX_CATEGORY_BUG(NSArray)
FIX_CATEGORY_BUG(NSMutableArray)
FIX_CATEGORY_BUG(NSDictionary)
FIX_CATEGORY_BUG(NSMutableDictionary)
FIX_CATEGORY_BUG(NSString)

#pragma mark - NSArray Utils

@implementation NSArray (Utils)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

-(id)deepMutableCopy
{
    NSMutableArray *mutableCopy = (NSMutableArray *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFArrayRef)self, kCFPropertyListMutableContainers);
    return [mutableCopy autorelease];
}

-(NSArray*)shuffled
{
	NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:[self count]];
	for (id obj in self)
	{
		NSUInteger index = STRandom([tmpArr count]);
		[tmpArr insertObject:obj atIndex:index];
	}
	return [NSArray arrayWithArray:tmpArr];  // non-mutable autoreleased copy
}

@end

#pragma mark - NSMutableArray Utils

@implementation NSMutableArray (Utils)

-(void)reverse {
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];

        i++;
        j--;
    }
}

-(void)shuffle
{
    for(NSUInteger i = [self count]; i > 1; i--) {
        NSUInteger j = STRandom(i);
        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
}

@end

#pragma mark - NSDictionary Utils

@implementation NSDictionary (Utilities)

-(BOOL)hasKey:(id)key
{
    return ([self objectForKey:key] != nil);
}

- (id)objectForKey:(id)key Default:(id)nilDefault
{
    if([self objectForKey:key])
        return [self objectForKey:key];
    return nilDefault;
}

- (double)doubleForKey:(id)key Default:(double)nilDefault
{
    if([self objectForKey:key])
        return [[self objectForKey:key] doubleValue];
    return nilDefault;
}

- (float)floatForKey:(id)key Default:(float)nilDefault
{
    if([self objectForKey:key])
        return [[self objectForKey:key] floatValue];
    return nilDefault;
}

- (NSInteger)intForKey:(id)key Default:(NSInteger)nilDefault
{
    if([self objectForKey:key])
        return [[self objectForKey:key] integerValue];
    return nilDefault;
}

- (NSUInteger)uintForKey:(id)key Default:(NSUInteger)nilDefault
{
    if([self objectForKey:key])
        return [[self objectForKey:key] unsignedIntegerValue];
    return nilDefault;
}

- (BOOL)boolForKey:(id)key Default:(BOOL)nilDefault
{
    if([self objectForKey:key])
        return [[self objectForKey:key] boolValue];
    return nilDefault;
}

- (CGPoint)pointForKey:(id)key Default:(CGPoint)nilDefault
{
    if([self objectForKey:key])
        return CGPointFromString([self objectForKey:key]);
    return nilDefault;
}

- (double)doubleForKey:(id)key
{
    return [self doubleForKey:key Default:0.0];
}
- (float)floatForKey:(id)key
{
    return [self floatForKey:key Default:0.0f];
}

- (NSInteger)intForKey:(id)key
{
    return [self intForKey:key Default:0];
}

- (NSUInteger)uintForKey:(id)key
{
    return [self uintForKey:key Default:0];
}


- (BOOL)boolForKey:(id)key
{
    return [self boolForKey:key Default:NO];
}

- (CGPoint)pointForKey:(id)key
{
    return [self pointForKey:key Default:CGPointZero];
}

-(id)deepMutableCopy
{
    NSMutableDictionary *mutableCopy = (NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFDictionaryRef)self, kCFPropertyListMutableContainers);
    return [mutableCopy autorelease];
}

@end


#pragma mark - NSMutableDictionary Utils

@implementation NSMutableDictionary (Utilities)

- (void)setDouble:(double)val forKey:(id)aKey
{
    [self setObject:[NSNumber numberWithDouble:val] forKey:aKey];
}

- (void)setFloat:(float)val forKey:(id)aKey
{
    [self setObject:[NSNumber numberWithFloat:val] forKey:aKey];
}

- (void)setInt:(NSInteger)val forKey:(id)aKey
{
    [self setObject:[NSNumber numberWithInt:val] forKey:aKey];
}

- (void)setUInt:(NSUInteger)val forKey:(id)aKey
{
    [self setObject:[NSNumber numberWithUnsignedInt:val] forKey:aKey];
}

- (void)setBool:(BOOL)val forKey:(id)aKey
{
    [self setObject:[NSNumber numberWithBool:val] forKey:aKey];
}

- (void)setPoint:(CGPoint)val forKey:(id)key
{
    [self setObject:NSStringFromCGPoint(val) forKey:key];
}

@end

#pragma mark - NSString Utils

@implementation NSString (STUtils)

-(NSMutableString*)asMutableString
{
    return [[self mutableCopy] autorelease];
}

-(NSData*)dataWithUTF8
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*)stripWhitespace
{
    return [self stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

-(BOOL)isEmpty
{
    return self.length == 0;
}

-(BOOL)isNotEmpty
{
    return self.length > 0;
}

-(BOOL)isBlank
{
    // Shortcuts object creation by testing before trimming.
    return [self isEmpty] || [[self stripWhitespace] isEmpty];
}

-(BOOL)containsString:(NSString*)substring
{
    return [self rangeOfString:substring].location != NSNotFound;
}

@end