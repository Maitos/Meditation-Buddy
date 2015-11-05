//
//  MeditateViewController.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 6/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "MeditateViewController.h"


@interface MeditateViewController ()
@end

@implementation MeditateViewController

#pragma mark INITIALIZATION
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self setupAppTerminateHandler];
}

-(void)setup {
    self.mbCountdown.delegate = self;
    
    if(self.meditateDuration) {
        self.lblMeditatingFor.text = [NSString stringWithFormat:@"MEDITATING FOR %@ MINUTES", self.meditateDuration];
        [self startMeditationWithDuration:self.meditateDuration];
    }
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bFinishWasPressed)];
    [tap setNumberOfTapsRequired:1];
    [self.bFinish addGestureRecognizer:tap];
}
-(void)setupAppTerminateHandler {
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(applicationWillTerminate:) name:@"applicationWillTerminate" object:nil];
    
}
-(void)startMeditationWithDuration: (NSNumber*)minutes {
    self.currentMeditation = (Meditation*)[MBDataAttendant createEntityWithType:@"Meditation"];
    self.currentMeditation.date = [NSDate date];
    self.currentMeditation.duration = minutes;
    [MBDataAttendant saveChanges];
    
    [self.mbCountdown startCountdownWithDuration:minutes.doubleValue * 60];
}

#pragma mark COUNT DOWN TIMER
-(void)countDownDidRepeat:(NSString *)timeLeft {
    [self.lblTimeLeft setText:timeLeft];
}
-(void)countDownDidEnd {
    NSLog(@"ended");
    
    [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mbCountdown.transform=CGAffineTransformMakeScale(1.3, 1.3);
        self.vwTimeLeft.transform = CGAffineTransformMakeTranslation(0, -80);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.mbCountdown.transform=CGAffineTransformMakeScale(0.01, 0.01);
            self.vwTimeLeft.transform = CGAffineTransformMakeTranslation(0, 600);
        } completion:^(BOOL finished) {
            [self.vwTimeLeft setHidden:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    
}

#pragma mark BUTTON PRESS
-(void)bFinishWasPressed {
    [self.mbCountdown togglePause:YES];
    
    if([self.mbCountdown secondsLeft] >= 60) {
        [MBDataAttendant deleteEntity:self.currentMeditation];
        [MBDataAttendant saveChanges];
        self.currentMeditation = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark APP TERMINATED
-(void)applicationWillTerminate:(NSNotification*)notif {
    if([self.mbCountdown secondsLeft] > 10) {
        [MBDataAttendant deleteEntity:self.currentMeditation];
        [MBDataAttendant saveChanges];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
