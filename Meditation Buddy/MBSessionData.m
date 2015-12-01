//
//  MBSessionData.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 1/12/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import "MBSessionData.h"
#import "Constants.h"

static MBSessionData* singleton;
@implementation MBSessionData

#pragma mark INITIALIZATION
+(void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        singleton = [MBSessionData new];
    }
}
+(MBSessionData*)sessionData {
    return singleton;
}

#pragma mark PROPERTIES
-(void)setMeditationCurrentSessionLength:(NSNumber *)meditationCurrentSessionLength {
    [[NSUserDefaults standardUserDefaults] setValue:meditationCurrentSessionLength forKey:DEFAULTS_LAST_SESSION_LENGTH_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSNumber *)getMeditationCurrentSessionLength {
    NSNumber* sessionLength = [[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTS_LAST_SESSION_LENGTH_KEY];
    if(!sessionLength) sessionLength = @(10);
    
    return sessionLength;
}

@end
