//
//  WIZPurchaseHelper.h
//  Momentum
//
//  Created by a.vorozhishchev on 03/06/2019.
//  Copyright © 2019 WizAlx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol WIZPurchaseHelperDelegate <NSObject>

//list of products
-(void)WIZPurchaseHelperProducts:(NSArray<SKProduct *>*)products;

//payment complete
-(void)WIZPurchaseHelperPaymentComplete:(NSString*)identifier;

//payment failed
-(void)WIZPurchaseHelperPaymentFailedProductIdentifier:(NSString*)identifier error:(NSError*)error;

//promoted In-App purchase
-(void)WIZPurchaseHelperCallPromotedPurchase:(NSString*)identifier;

@end

@interface WIZPurchaseHelper : NSObject

+(WIZPurchaseHelper*)sharedInstance;

@property (nonatomic) id <WIZPurchaseHelperDelegate> delegate;

//firstly!!
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers;

//check available payment
- (BOOL)canMakePayments;

//buy purchase
- (void)payWithIdentefier:(NSString*)identifier;

//restore purchase
- (void)refreshReceipt;

@end
