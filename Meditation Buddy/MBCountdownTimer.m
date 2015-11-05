//
//  MBCountdownTimer.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 5/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "MBCountdownTimer.h"
#import "MBSound.h"
#include <math.h>

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees) / 180)

int PAUSE_WIDTH = 50;
int PAUSE_HEIGHT = 35;
int PAUSE_LINE_THICKNESS = 5;
int PAUSE_LINE_SPACING = 5;

int PLAY_WIDTH = 30;
int PLAY_HEIGHT = 35;

double COUNTDOWN_INTERVAL = 0.08;

int SPIKE_HEIGHT = 8;
int SPIKE_WIDTH = 50;

@interface MBCountdownTimer()

@property (nonatomic, strong) CAShapeLayer* progressLayer;
@property (nonatomic, strong) CAShapeLayer* spikeLayer;
@property (nonatomic, strong) CAShapeLayer* staticSpikeLayer;
@property (nonatomic, strong) NSMutableArray* staticSpikeAngles;

@property (nonatomic, strong) UIView* pauseButton;

@property (nonatomic, strong) NSNumber* countDownMaxDuration; //in seconds
@property (nonatomic, strong) NSNumber* countDownCurrent;
@property (nonatomic, strong) NSTimer*  countDownTimer;
@property (nonatomic, strong) NSNumber* countDownTimerSpikeLastValue;
@property (nonatomic, strong) NSNumber* countDownIsPaused;
@property (nonatomic, strong) NSNumber* countDownPlaySound;

@property (nonatomic, strong) NSDate* dateAppMinimized;
@property (nonatomic, strong) NSNumber* lastProgressAngle;

@end

@implementation MBCountdownTimer

#pragma mark PROPERTIES
-(double)radius {
    return self.bounds.size.width / 2;
    //get the diameter of the circle (width) and divide by 2 to get radius
}
-(double)secondsLeft {
    return self.countDownMaxDuration.doubleValue - self.countDownCurrent.doubleValue;
}
-(bool)isCountdownFinished {
    return [self secondsLeft] <= 0;
}

#pragma mark INITIALIZATION
-(void)_initCountdownTimer {
    self.countDownTimerSpikeLastValue = @0;
    self.staticSpikeAngles = [NSMutableArray new];
    self.countDownPlaySound = @(YES);
    
    self.countDownIsPaused = @(NO);
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        [self _initCountdownTimer];
    }
    
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self _initCountdownTimer];
    }
    
    return self;
}
-(void)prepareForInterfaceBuilder {
    [self setup];
}

#pragma mark LAYOUT
-(void)setup {
    [self setupBackgroundHandler];
    [self setupCircle];
    [self setupPauseButton];
    [self setupSpikeLayer];
}
-(void)setupPauseButton {
    UIView* pauseView = self.pauseButton ?: [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - PAUSE_WIDTH / 2, self.bounds.size.height / 2 - PAUSE_HEIGHT / 2, PAUSE_WIDTH, PAUSE_HEIGHT)];
    
    if(!self.pauseButton) {
        //initialize it as this is its first time
        [pauseView setBackgroundColor:self.tintColor];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pausePlayDidPress)];
        [tap setNumberOfTapsRequired:1];
        [pauseView addGestureRecognizer:tap];
        self.pauseButton = pauseView;
        
        [self addSubview:pauseView];
    }
    
    if(!self.countDownIsPaused.boolValue) {
        //draw two lines for a pause button
        CAShapeLayer* mask = [CAShapeLayer new];
        [mask setLineWidth:PAUSE_LINE_THICKNESS];
        mask.frame = pauseView.bounds;
        
        mask.strokeColor = [UIColor whiteColor].CGColor;
        
        UIBezierPath* path = [UIBezierPath new];
        [path moveToPoint:CGPointMake(PAUSE_WIDTH / 2 - (PAUSE_LINE_THICKNESS / 2 - PAUSE_LINE_SPACING / 2) - PAUSE_LINE_SPACING, 0)];
        [path addLineToPoint:CGPointMake(PAUSE_WIDTH / 2 - (PAUSE_LINE_THICKNESS / 2 - PAUSE_LINE_SPACING / 2) - PAUSE_LINE_SPACING, PAUSE_HEIGHT)];
        
        [path moveToPoint:CGPointMake(PAUSE_WIDTH / 2 - (PAUSE_LINE_THICKNESS / 2 - PAUSE_LINE_SPACING / 2) + PAUSE_LINE_SPACING, 0)];
        [path addLineToPoint:CGPointMake(PAUSE_WIDTH / 2 - (PAUSE_LINE_THICKNESS / 2 - PAUSE_LINE_SPACING / 2)  + PAUSE_LINE_SPACING, PAUSE_HEIGHT)];
        mask.path = path.CGPath;
        
        pauseView.layer.mask = mask;
    } else {
        CAShapeLayer* mask = [CAShapeLayer new];
        mask.fillColor = [UIColor whiteColor].CGColor;
        
        UIBezierPath* path = [UIBezierPath new];
        [path moveToPoint:CGPointMake((double)PAUSE_WIDTH / 2 - PLAY_WIDTH / 3 + 5, 0)];
        [path addLineToPoint:CGPointMake((double)PAUSE_WIDTH / 2 - PLAY_WIDTH / 3 + 5, PLAY_HEIGHT)];
        [path addLineToPoint:CGPointMake((double)PAUSE_WIDTH / 2 + PLAY_WIDTH / 2 + 5, (double)PLAY_HEIGHT/2)];
        [path closePath];
        
        mask.path = path.CGPath;
        
        pauseView.layer.mask = mask;
        
    }
}
-(void)setupCircle {
    //OUTER CIRCLE
    CAShapeLayer* circle = [CAShapeLayer layer];
    circle.fillColor = [UIColor whiteColor].CGColor;
    circle.lineWidth = self.BorderWidth ?: 5;
    
    if(self.BorderColor) {
        circle.strokeColor = self.BorderColor.CGColor;
    } else {
        circle.strokeColor = [UIColor blackColor].CGColor;
    }
    
    circle.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    [self.layer addSublayer:circle];
    
    CGPathRef fromPath = [self createProgressSliceWithEndAngle:0];
    
    //INNER PROGRESS CIRCLE
    CAShapeLayer* progressCircle = [CAShapeLayer new];
    progressCircle.fillColor = self.ProgressFillColor ? self.ProgressFillColor.CGColor : [UIColor blackColor].CGColor;
    progressCircle.path = fromPath;
    progressCircle.frame = self.bounds;
    
    self.progressLayer = progressCircle;
    [self.layer addSublayer:progressCircle];
}
-(void)setupSpikeLayer {
    //MOVABLE SPIKE
    CAShapeLayer* layer = [CAShapeLayer new];
    layer.fillColor = self.ProgressFillColor.CGColor;
    layer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    [self.layer addSublayer:layer];
    self.spikeLayer = layer;
    
    UIBezierPath* path = [UIBezierPath new];
    
    [path moveToPoint:CGPointMake(self.bounds.size.width / 2 - SPIKE_WIDTH / 2, 2.5)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2 + SPIKE_WIDTH / 2, 2.5)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2, -SPIKE_HEIGHT)];
    [path closePath];
    
    self.spikeLayer.path = path.CGPath;
    
    //STATIC SPIKES
    CAShapeLayer* staticLayer = [CAShapeLayer new];
    staticLayer.fillColor = self.ProgressFillColor.CGColor;
    staticLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    [self.layer addSublayer:staticLayer];
    self.staticSpikeLayer = staticLayer;
    
    [self addStaticSpikeAtAngle:0];
}
-(void)setupBackgroundHandler {
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(appDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [center addObserver:self selector:@selector(appDidBecomeActive) name:@"applicationDidBecomeActive" object:nil];
    [center addObserver:self selector:@selector(appDidReceiveLocalNotification) name:@"applicationDidReceiveLocalNotification" object:nil];
}
-(void)addStaticSpikeAtAngle:(double)angle {
    if([self.staticSpikeAngles containsObject:@(angle)]) return;
    
    UIBezierPath* path = [UIBezierPath new];
    
    [path moveToPoint:CGPointMake(self.bounds.size.width / 2 - SPIKE_WIDTH / 2, 2.5)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2 + SPIKE_WIDTH / 2, 2.5)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2, -SPIKE_HEIGHT)];
    [path closePath];
    
    CAShapeLayer* staticLayer = [CAShapeLayer new];
    staticLayer.fillColor = self.ProgressFillColor.CGColor;
    staticLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    [self.staticSpikeLayer addSublayer:staticLayer];
    
    staticLayer.path = path.CGPath;
    
    staticLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(angle), 0, 0, 1);
    
    [self.staticSpikeAngles addObject:@(angle)];
}
-(void)renderProgress {
    double progressPcnt = self.countDownCurrent.doubleValue / self.countDownMaxDuration.doubleValue;
    //NSLog(@"Countdown Timer Progress: %f", progressPcnt);

    double progressAngle = 360 * progressPcnt;
    
    if(progressPcnt == 0 || progressPcnt < 0.003) {
        self.progressLayer.path = [self createProgressSliceWithEndAngle:progressAngle];
        [self renderProgressSpike:progressAngle];
        //so it doesn't do that weird path fill transition
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation setFromValue:(__bridge id)self.progressLayer.path];
    [animation setToValue:(__bridge  id)[self createProgressSliceWithEndAngle:progressAngle]];
    [animation setDuration:COUNTDOWN_INTERVAL];
    
     self.progressLayer.path = [self createProgressSliceWithEndAngle:progressAngle];
    [self.progressLayer addAnimation:animation forKey:@"position"];
    
    [self renderProgressSpike:progressAngle];
    
}
-(void)renderProgressSpike: (double)progressAngle {
    if(progressAngle > 360.0 * (7.0/8.0)) return;
    
    //SPIKE ANIMATION
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.duration = COUNTDOWN_INTERVAL;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    
    NSNumber* fromValue = self.countDownTimerSpikeLastValue;
    NSNumber* toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(progressAngle)];
    
    animation2.fromValue = fromValue;
    animation2.toValue = toValue;
    
    self.countDownTimerSpikeLastValue = toValue;
    
    [self.spikeLayer addAnimation:animation2 forKey:@"90rotation"];
    
    //STATIC SPIKE APPEAR
    if((long)progressAngle % 45 == 0) {
        [self addStaticSpikeAtAngle:(int)progressAngle];
    }
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

#pragma mark LAYOUT UTILITIES
-(CGPathRef)createProgressSliceWithEndAngle: (double)endAngle {
    CGFloat radius = [self radius];
    
    UIBezierPath* pPath = [UIBezierPath new];
    CGPoint center = CGPointMake(radius, radius);
    [pPath moveToPoint:center];
    
    [pPath addArcWithCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS((endAngle - 90)) clockwise:YES]; //add the arc
    [pPath closePath];
    
    return pPath.CGPath;
}

#pragma mark FUNCTIONALITY
-(void)startCountdownWithDuration:(double) seconds {
    if(self.countDownTimer) {
        [NSException raise:@"Countdown already started" format:@""];
    }
    
    self.countDownMaxDuration = @(seconds-1);
    self.countDownCurrent = @0;
    [self createCountdownTimer];
}
-(void)createCountdownTimer {
    NSMethodSignature* signature = [self methodSignatureForSelector:@selector(countDownDidRepeat)];
    NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:signature];
    [invoc setTarget:self];
    [invoc setSelector:@selector(countDownDidRepeat)];
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:COUNTDOWN_INTERVAL invocation:invoc repeats:YES];
}
-(void)pausePlayDidPress {
    [self togglePause:YES];
}
-(void)togglePause:(bool)updatePauseButton {
    self.countDownIsPaused = @(!self.countDownIsPaused.boolValue);
    if(self.countDownIsPaused.boolValue) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    } else {
        [self createCountdownTimer];
    }
    
    if(updatePauseButton) [self setupPauseButton];
}

#pragma mark BACKGROUND FUNCTIONALITY
-(void)appDidEnterBackground {
    [self togglePause:NO];
    self.dateAppMinimized = [NSDate date];
    
    UILocalNotification* sessionEndNotification = [UILocalNotification new];
    sessionEndNotification.soundName = @"endMeditationBell.aif";
    sessionEndNotification.hasAction = YES;
    sessionEndNotification.fireDate = [self.dateAppMinimized dateByAddingTimeInterval:[self secondsLeft]];
    sessionEndNotification.alertTitle = @"Session finished";
    sessionEndNotification.alertBody = @"Your session has finished. Remember to remain mindful through the rest of your day!";
    [[UIApplication sharedApplication] scheduleLocalNotification:sessionEndNotification];
    
    double progressPcnt = self.countDownCurrent.doubleValue / self.countDownMaxDuration.doubleValue;
    double progressAngle = 360 * progressPcnt;
    self.lastProgressAngle = @(progressAngle);
    
}
-(void)appDidBecomeActive {
    if(!self.dateAppMinimized) return;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDate* now = [NSDate date];
    NSTimeInterval secondsBetween = [now timeIntervalSinceDate:self.dateAppMinimized];
    
    self.countDownCurrent = @(self.countDownCurrent.intValue + secondsBetween);
    
    if(self.lastProgressAngle) {
        double progressPcnt = self.countDownCurrent.doubleValue / self.countDownMaxDuration.doubleValue;
        double progressAngle = 360 * progressPcnt;
        int lastProgressAngle = self.lastProgressAngle.intValue;
        
        if(progressPcnt*100.0 >= 100) {
            self.countDownPlaySound = @(NO);
        }
        
        while(lastProgressAngle <= progressAngle) {
            if((long)lastProgressAngle % 45 == 0) {
                [self addStaticSpikeAtAngle:(int)lastProgressAngle];
            }
            lastProgressAngle++;
        }
        
    }
    
    [self togglePause:NO];
}
-(void)appDidReceiveLocalNotification {
    [self playFinishedSound];
}

#pragma mark DELEGATES
-(void)countDownDidRepeat {
    self.countDownCurrent = @(self.countDownCurrent.doubleValue + 1.0f * COUNTDOWN_INTERVAL);
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(countDownDidRepeat:)]) {
            double totalLeft = [self secondsLeft];
            int totalLeftSeconds = (long)totalLeft % 60 + 1;
            int totalLeftMinutes = (long)(totalLeft / 60) % 60;
            
            [self.delegate countDownDidRepeat:[NSString stringWithFormat:@"%02d:%02d", totalLeftMinutes, totalLeftSeconds]];
        }
    }
    
    [self renderProgress];
    
    if(self.countDownCurrent.intValue >= self.countDownMaxDuration.intValue) {
        [self.delegate countDownDidRepeat:[NSString stringWithFormat:@"00:00"]];
        [self countDownDidEnd];
    }
}
-(void)countDownDidEnd {
    [self.countDownTimer invalidate];
    
    self.countDownTimer = nil;
    self.countDownMaxDuration = nil;
    self.countDownCurrent = nil;
    
    [self playFinishedSound];
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(countDownDidEnd)]) {
            [self.delegate countDownDidEnd];
        }
    }
}

#pragma mark SOUND
-(void)playFinishedSound {
    if(self.countDownPlaySound.boolValue) {
        [MBSound playSound:[MBSound createSoundID:@"endMeditationBell.aif"]];
    }
}

-(void)dealloc {
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

@end
