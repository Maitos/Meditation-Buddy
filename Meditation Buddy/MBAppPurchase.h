//
//  MBAppPurchase.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 24/10/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#define MBDisableAdsIdentifier @"com.MMarshall.MeditationBuddy.DisableAds"

typedef enum {
    DisableAds
} MBAppPurchaseType;

@protocol MBAppPurchaseDelegate <NSObject>

-(void)purchaseWasSuccessful:(SKPaymentTransaction*) transaction purchaseType: (MBAppPurchaseType) purchaseType;

@end


@interface MBAppPurchase : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, weak) id<MBAppPurchaseDelegate> delegate;

+(void)performAppPurchase: (MBAppPurchaseType) type withDelegate:(id<MBAppPurchaseDelegate>)delegate;

@end
