//
//  MBSound.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 23/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "MBSound.h"

@implementation MBSound

+ (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@",
                      [[NSBundle mainBundle] resourcePath], name];
    
    
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}


+(void)playSound:(SystemSoundID)sound {
    AudioServicesPlaySystemSound(sound);
}
@end
