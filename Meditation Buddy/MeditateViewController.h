//
//  MeditateViewController.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 6/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBCountdownTimer.h"
#import "MBView.h"
#import "MBDataAttendant.h"

@interface MeditateViewController : UIViewController <MBCountdownTimerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblMeditatingFor;
@property (weak, nonatomic) IBOutlet MBCountdownTimer *mbCountdown;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeft;
@property (weak, nonatomic) IBOutlet MBView *vwTimeLeft;
@property (weak, nonatomic) IBOutlet MBView *bFinish;
@property (nonatomic, strong) Meditation* currentMeditation;

@property (strong, nonatomic) NSNumber* meditateDuration; //in minutes

-(void)startMeditationWithDuration: (NSNumber*)minutes;

@end
