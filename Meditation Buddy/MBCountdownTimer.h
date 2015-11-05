//
//  MBCountdownTimer.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 5/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBCountdownTimerDelegate <NSObject>

@optional
-(void)countDownDidRepeat: (NSString*)timeLeft;
-(void)countDownDidEnd;

@end

@interface MBCountdownTimer : UIView

@property (nonatomic, strong) IBInspectable UIColor* BorderColor;
@property (nonatomic) IBInspectable NSUInteger BorderWidth;
@property (nonatomic, strong) IBInspectable UIColor* ProgressFillColor;
-(double)secondsLeft;

@property (nonatomic, weak) id<MBCountdownTimerDelegate> delegate;

-(void)startCountdownWithDuration:(double) seconds;
-(void)togglePause:(bool)updatePauseButton;
-(bool)isCountdownFinished;

@end
