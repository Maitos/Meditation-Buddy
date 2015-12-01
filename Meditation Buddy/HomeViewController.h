//
//  ViewController.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 3/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBButtonGrid.h"
#import "MBDropDownMenu.h"

@interface HomeViewController : UIViewController <MBButtonGridDelegate, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet MBButtonGrid *bgSessionLength;

@property (weak, nonatomic) IBOutlet UITabBar *tbNavigation;
@property (weak, nonatomic) IBOutlet UILabel *lblMeditateFor;
@property (weak, nonatomic) IBOutlet UILabel *lblRunStreak;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalTimeMeditating;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalTimeMeditatingPeriod;
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;
@property (weak, nonatomic) IBOutlet UILabel *lblAverageMinutes;
@property (weak, nonatomic) IBOutlet UILabel *lblBestRunStreak;
@property (weak, nonatomic) IBOutlet MBView *vwMeditate;


@end

