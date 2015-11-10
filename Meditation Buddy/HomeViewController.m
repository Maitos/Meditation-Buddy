//
//  ViewController.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 3/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "HomeViewController.h"
#import "MeditateViewController.h"
#import "MBDataAttendant.h"
#import "MBProgressHUD.h"

int AD_COUNT = 3;
NSString* DEFAULTS_DISABLE_ADS_KEY = @"adsDisabled";
NSString* DEFAULTS_LAST_SESSION_LENGTH_KEY = @"lastSessionLength";
NSString* meditateForTemplate = @"MEDITATE FOR %@ MINUTES";

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark INITIALIZATION
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupDropDownMenu];
}
-(void)viewDidAppear:(BOOL)animated {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:DEFAULTS_DISABLE_ADS_KEY]) return;
    
    int count = (int)[defaults integerForKey:@"adCounter"];
    
    if(count >= AD_COUNT) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.interstitial loadAd];
        [defaults setInteger:0 forKey:@"adCounter"];
        
    } else {
        [defaults setInteger:count+1 forKey:@"adCounter"];
    }
    
    [defaults synchronize];
    [self setupUserStats];
}

#pragma mark SETUP
-(void)setup {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bMeditateWasPressed)];
    [tap setNumberOfTapsRequired:1];
    [self.bMeditate addGestureRecognizer:tap];
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self.bSideMenu action:@selector(hideMenu)];
    [tap2 setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap2];
    
    self.svContent.delegate = self;
    
    if(!IS_IPHONE_6P) {
        //no scroll view on 6plus
        CGRect lowestFrame = self.bMeditate.frame;
        
        double contentOffset = IS_IPHONE_4_OR_LESS || IS_IPAD ? 210 : IS_IPHONE_5 ? 125 : 25;
        self.svContent.contentSize = CGSizeMake(self.view.frame.size.width, lowestFrame.origin.y + contentOffset);
        
        
    } else {
        self.vwMeditate.TailHeight = 10;
        self.bMeditate.TailHeight = 10;
    }
    
    
    [self setupButtonGrid];
    [self setupUserStats];
    [self setupAds];
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
    
    [self.bgSessionLength selectItem:[[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTS_LAST_SESSION_LENGTH_KEY] ?: @"10"];
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
-(void)setupAds {
    // TODO: Replace this test id with your personal ad unit id
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"2321e4fba74b4d1d9c93630bb3bf0237"];
    self.interstitial.delegate = self;
}
-(void)setupDropDownMenu {
    [self.bSideMenu.items removeAllObjects];
    
    self.bSideMenu.delegate = self;
    [self.bSideMenu addMenuItem:@"About Me" imageNamed:@"userIcon.gif"];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:DEFAULTS_DISABLE_ADS_KEY]) {
        [self.bSideMenu addMenuItem:@"Thank You" imageNamed:@"heart-b.png"];
    } else {
        [self.bSideMenu addMenuItem:@"Remove Ads" imageNamed:@"noAds.gif"];
        [self.bSideMenu addMenuItem:@"Restore Purchase" imageNamed:@"noAds.gif"];
    }
    
}

#pragma mark UI DELEGATES
-(void)itemWasSelected:(NSString *)item {
    self.lblMeditateFor.text = [NSString stringWithFormat:meditateForTemplate, item];
}
-(void)bMeditateWasPressed {
    [self performSegueWithIdentifier:@"meditate" sender:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGSize contentSize = scrollView.contentSize;
    double size = (double)scrollView.contentOffset.y - (contentSize.height - scrollView.frame.size.height) + 10;
    
    self.bMeditate.TailHeight = size;
    self.vwMeditate.TailHeight = size;
}
-(void)menuItemWasSelected:(NSString *)item {
    if([item isEqualToString:@"About Me"]) {
        [self performSegueWithIdentifier:@"about" sender:nil];
    } else if([item isEqualToString:@"Remove Ads"]) {
        [self disableAds];
    } else if([item isEqualToString:@"Restore Purchase"]) {
        [MBAppPurchase restorePreviousPurchaseWithDelegate:self];
    }
}

#pragma mark <MPInterstitialAdControllerDelegate>
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (interstitial.ready) {
        [self.bSideMenu hideMenu];
        [interstitial showFromViewController:self];
    }
}

#pragma mark DISABLE ADS
-(void)disableAds {
    [MBAppPurchase performAppPurchase:DisableAds withDelegate:self];
}
-(void)purchaseWasSuccessful:(SKPaymentTransaction *)transaction purchaseType:(MBAppPurchaseType)purchaseType {
    if(purchaseType == DisableAds) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DEFAULTS_DISABLE_ADS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self setupDropDownMenu];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.bSideMenu hideMenu];
    
    if([segue.identifier isEqualToString:@"meditate"]) {
        [[NSUserDefaults standardUserDefaults] setValue:[self.bgSessionLength getSelection] forKey:DEFAULTS_LAST_SESSION_LENGTH_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        MeditateViewController* meditate = segue.destinationViewController;
        meditate.meditateDuration = @([self.bgSessionLength getSelection].intValue);
    }
}



@end
