//
//  MBSessionData.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 1/12/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBSessionData : NSObject

#pragma mark STATIC PROPERTIES
+(void)initialize;
+(MBSessionData*)sessionData;

#pragma mark INSTANCE PROPERTIES
@property(nonatomic, getter=getMeditationCurrentSessionLength, setter=setMeditationCurrentSessionLength:) NSNumber* meditationCurrentSessionLength;

@end
