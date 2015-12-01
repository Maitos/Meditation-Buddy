//
//  RootViewController.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 30/11/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import "RootViewController.h"
#import "MeditateViewController.h"

#import "Constants.h"
#import "MBSessionData.h"
#import "MBProgressHUD.h"

#import <Crashlytics/Answers.h>

@implementation RootViewController

#pragma mark INITIALIZATION
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupDropDownMenu];
    [self setupAds];
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
}
-(void)setupDropDownMenu {
    [self.bSideMenu.items removeAllObjects];
    
    self.bSideMenu.delegate = self;
    [self.bSideMenu addMenuItem:@"About Me" imageNamed:@"userIcon.gif"];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:DEFAULTS_DISABLE_ADS_KEY]) {
        [self.bSideMenu addMenuItem:@"Thank You" imageNamed:@"heart-b.png"];
    } else {
        [self.bSideMenu addMenuItem:@"Remove Ads" imageNamed:@"noAds.gif"];
        [self.bSideMenu addMenuItem:@"Restore Purchase" imageNamed:@"restore@2x.png"];
    }
}
-(void)setupAds {
    // TODO: Replace this test id with your personal ad unit id
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"2321e4fba74b4d1d9c93630bb3bf0237"];
    self.interstitial.delegate = self;
}

#pragma mark UI EVENTS
- (IBAction)bMeditateWasPressed:(id)sender {
    [self performSegueWithIdentifier:@"meditate" sender:nil];
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

#pragma mark SEGUES
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"meditate"]) {
        [Answers logCustomEventWithName:FABRIC_EVENT_MEDITATING
                       customAttributes:@{@"Duration" : [MBSessionData sessionData].meditationCurrentSessionLength}];
        
        MeditateViewController* meditate = segue.destinationViewController;
        meditate.meditateDuration = [MBSessionData sessionData].meditationCurrentSessionLength;
    }
}


@end
