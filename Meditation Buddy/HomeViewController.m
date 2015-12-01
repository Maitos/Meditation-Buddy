//
//  ViewController.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 3/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "HomeViewController.h"
#import "MBDataAttendant.h"
#import "Constants.h"
#import "MBSessionData.h"

NSString* meditateForTemplate = @"MEDITATE FOR %@ MINUTES";

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark INITIALIZATION
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
-(void)viewDidAppear:(BOOL)animated {
    [self setupUserStats];
}

#pragma mark SETUP
-(void)setup {
    if(!IS_IPHONE_6P) {
        //no scroll view on 6plus
        self.svContent.delegate = self;
        self.svContent.contentSize = CGSizeMake(self.view.frame.size.width, self.vwMeditate.frame.origin.y + self.vwMeditate.frame.size.height + 20);
    } else {
        self.vwMeditate.TailHeight = 10;
    }
    
    [self setupButtonGrid];
    [self setupUserStats];
  }
-(void)setupButtonGrid {
    self.bgSessionLength.delegate = self;
    
    [self.bgSessionLength addGridItem:@"5"];
    [self.bgSessionLength addGridItem:@"10"];
    [self.bgSessionLength addGridItem:@"15"];
    [self.bgSessionLength addGridItem:@"20"];
    [self.bgSessionLength addGridItem:@"25"];
    [self.bgSessionLength addGridItem:@"30"];
    [self.bgSessionLength addGridItem:@"35"];
    [self.bgSessionLength addGridItem:@"40"];
    [self.bgSessionLength addGridItem:@"45"];
    [self.bgSessionLength addGridItem:@"50"];
    [self.bgSessionLength addGridItem:@"55"];
    [self.bgSessionLength addGridItem:@"60"];
    
    [self.bgSessionLength selectItem: [MBSessionData sessionData].meditationCurrentSessionLength.stringValue];
}
-(void)setupUserStats {
    NSNumber* timeMeditating = @([MBDataAttendant meditationTotalDuration].doubleValue);
    if(timeMeditating.doubleValue < 60) {
        self.lblTotalTimeMeditatingPeriod.text = @"(minutes)";
        self.lblTotalTimeMeditating.text = timeMeditating.stringValue;
    } else {
        self.lblTotalTimeMeditatingPeriod.text = @"(hours)";
        self.lblTotalTimeMeditating.text = @((long)timeMeditating.intValue / 60 % 60).stringValue;
    }
    
    
    NSNumber* runStreak = [MBDataAttendant meditationCurrentRunStreak];
    self.lblRunStreak.text = runStreak.stringValue;
    
    NSNumber* bestRunStreak = [MBDataAttendant meditationBestRunStreak];
    self.lblBestRunStreak.text = bestRunStreak.stringValue;
    
    NSNumber* average = [MBDataAttendant meditationAverageMinutes];
    self.lblAverageMinutes.text = average.stringValue;
}


#pragma mark UI DELEGATES
-(void)itemWasSelected:(NSString *)item {
    [MBSessionData sessionData].meditationCurrentSessionLength = @(item.integerValue);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGSize contentSize = scrollView.contentSize;
    double size = (double)scrollView.contentOffset.y - (contentSize.height - scrollView.frame.size.height) + 10;
    
    self.vwMeditate.TailHeight = size;
}





@end
