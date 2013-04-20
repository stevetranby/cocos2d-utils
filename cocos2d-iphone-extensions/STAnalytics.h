//
//  STAnalytics.h
//
//  Created by Steve Tranby on 4/4/13.
//  Copyright (c) 2013 Steve Tranby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestFlight.h"
#import "Flurry.h"

#define ANALYTICS_USE_FLURRY (1)
#define ANALYTICS_USE_TESTFLIGHT (1)

@interface STAnalytics : NSObject

+(void)setup;
+(void)logEvent:(NSString*)eventName withParameters:(NSDictionary*)parameters;
+(void)logEvent:(NSString*)eventName;
+(void)logError:(NSString*)error message:(NSString*)msg exception:(NSException*)exception;

@end