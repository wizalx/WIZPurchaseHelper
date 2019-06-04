//
//  WIZPurchaseHelper.m
//  Momentum
//
//  Created by a.vorozhishchev on 03/06/2019.
//  Copyright © 2019 WizAlx. All rights reserved.
//

#import "WIZPurchaseHelper.h"


@interface WIZPurchaseHelper() <SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate>

@property (nonatomic, strong) SKProductsRequest *request;
@property (nonatomic, strong) NSArray<SKProduct *> *products;

@end

@implementation WIZPurchaseHelper

+(WIZPurchaseHelper*)sharedInstance
{
    static WIZPurchaseHelper *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}

-(BOOL)canMakePayments
{
    return [SKPaymentQueue canMakePayments];
}

#pragma mark - validateProduct

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    
    self.request = productsRequest;
    productsRequest.delegate = self;
    [productsRequest start];
}

#pragma mark skProduct delegate

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    
    [_delegate WIZPurchaseHelperProducts:self.products];
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers)
        NSLog(@"WIZPurchaseHelper - Invalid identefier : %@", invalidIdentifier);
    
}

#pragma mark - pay and restore

- (void)payWithIdentefier:(NSString*)identifier
{
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:identifier])
        {
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
}


-(void)refreshReceipt
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - responding to transaction statuses

- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"WIZPurchaseHelper - SKPaymentTransactionStatePurchased:  %@",transaction.payment.productIdentifier);
                [self.delegate WIZPurchaseHelperPaymentComplete:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"WIZPurchaseHelper - SKPaymentTransactionStateFailed: %@",transaction.error.description);
                [self.delegate WIZPurchaseHelperPaymentFailedProductIdentifier:transaction.transactionIdentifier error:transaction.error];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"WIZPurchaseHelper - SKPaymentTransactionStateRestored: %@",transaction.payment.productIdentifier);
                [self.delegate WIZPurchaseHelperPaymentComplete:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

-(void)failedTransaction:(SKPaymentTransaction *)transaction inQueue:(SKPaymentQueue *)queue {
    NSLog(@"WIZPurchaseHelper - Transaction Failed with error: %@", transaction.error);
    [queue finishTransaction:transaction];
}

- (void)deferredTransaction:(SKPaymentTransaction *)transaction inQueue:(SKPaymentQueue *)queue {
    NSLog(@"WIZPurchaseHelper - Transaction Deferred: %@", transaction);
}

#pragma mark - Promoted Purchase

- (BOOL)paymentQueue:(SKPaymentQueue *)queue
shouldAddStorePayment:(SKPayment *)payment
          forProduct:(SKProduct *)product
{
    NSLog(@"WIZPurchaseHelper - shouldAddStorePayment: %@",product.productIdentifier);
    [self.delegate WIZPurchaseHelperCallPromotedPurchase:product.productIdentifier];
    return YES;
}

@end
