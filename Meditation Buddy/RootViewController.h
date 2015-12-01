//
//  RootViewController.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 30/11/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBDropDownMenu.h"

#import "MPInterstitialAdController.h"
#import "MBAppPurchase.h"

@interface RootViewController : UITabBarController <MBDropDownMenuDelegate,MPInterstitialAdControllerDelegate, MBAppPurchaseDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *bMeditate;
@property (weak, nonatomic) IBOutlet MBDropDownMenu *bSideMenu;

@property (nonatomic, retain) MPInterstitialAdController *interstitial;


@end
