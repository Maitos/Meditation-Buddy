//
//  MBAppPurchase.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 24/10/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import "MBAppPurchase.h"
#import "MBProgressHUD.h";

static MBAppPurchase* _singleton;
@interface MBAppPurchase()

@property (nonatomic) MBAppPurchaseType purchaseType;

@end

@implementation MBAppPurchase

+(void)performAppPurchase: (MBAppPurchaseType) type withDelegate:(id<MBAppPurchaseDelegate>)delegate
 {
    NSLog(@"User requests app purchase %u", type);
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        _singleton = [MBAppPurchase new];
        
        if(type == DisableAds) {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
            
            SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:MBDisableAdsIdentifier]];
            productsRequest.delegate = _singleton;
            _singleton.purchaseType = type;
            _singleton.delegate = delegate;
            [productsRequest start];
        }
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
}

- (IBAction)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", (int)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            [self purchaseWasSuccessful:transaction];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self purchaseWasSuccessful:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                _singleton = nil;
                NSLog(@"Transaction state -> Purchased");
                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                break;
            case SKPaymentTransactionStateRestored:
                [self purchaseWasSuccessful:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                _singleton = nil;
                NSLog(@"Transaction state -> Restored");
                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                _singleton = nil;
                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                break;
        }
    }
}

#pragma mark DELEGATES
-(void)purchaseWasSuccessful:(SKPaymentTransaction*) transaction {
    if(self.delegate && [self.delegate respondsToSelector:@selector(purchaseWasSuccessful:purchaseType:)]) {
        [self.delegate purchaseWasSuccessful:transaction purchaseType:self.purchaseType];
    }
}


-(void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}



@end
