//
//  MBSound.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 23/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioToolbox/AudioServices.h"


@interface MBSound : NSObject
+ (SystemSoundID) createSoundID: (NSString*)name;
+(void) playSound: (SystemSoundID)sound;

@end
