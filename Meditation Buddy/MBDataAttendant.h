//
//  MBDataAttendant.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 15/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBData.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface MBDataAttendant : NSObject

+(void)saveChanges;
+(NSManagedObject*)createEntityWithType: (NSString*)modelType;
+(void)deleteEntity: (NSManagedObject*)entity;

+(NSNumber*)meditationTotalDuration;
+(NSNumber*)meditationCurrentRunStreak;
+(NSNumber*)meditationAverageMinutes;
+(NSNumber*)meditationBestRunStreak;

@end
