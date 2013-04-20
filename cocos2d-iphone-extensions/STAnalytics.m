//
//  STAnalytics.m
//
//  Created by Steve Tranby on 4/4/13.
//  Copyright (c) 2013 Steve Tranby. All rights reserved.
//

#import "STAnalytics.h"
#import "GameConfig.h"

@implementation STAnalytics

// perform any unhandled exception setup as well.
+(void)setup
{
    [Flurry startSession:kAnalyticsFlurryIOS];
    [TestFlight takeOff:kTestFlightKey12];

//#ifdef kTestFlightTest
//    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
//#endif
}

+(void)logEvent:(NSString*)eventName withParameters:(NSDictionary*)params
{
    if(params)
    {
        [Flurry logEvent:eventName withParameters:params];
        for(NSString* param in params)
            [TestFlight passCheckpoint:ccStrFormat(@"%@ [%@=%@]",eventName, param, params[param])];
    }
    else
    {
        [Flurry logEvent:eventName];
        [TestFlight passCheckpoint:eventName];
    }
}

+(void)logEvent:(NSString*)eventName
{
    [self logEvent:eventName withParameters:nil];
}

#pragma mark -

+(void)logError:(NSString*)error message:(NSString*)msg exception:(NSException*)exception
{
    [Flurry logError:error message:msg exception:exception];
}

@end
