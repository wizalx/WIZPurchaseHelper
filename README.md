# WIZPurchaseHelper

Simple and light helper for create In-App purchase

- Simplifies working with this
- Supports all types of purchases
- Supports Promoting In-App Purchase

HOW TO INSTALL

Import files from the folder "WIZPurchaseHelper Obj-C" to your project. 

HOW TO USE

1. Add to AppDelegate [[WIZPurchaseHelper sharedInstance] validateProductIdentifiers:@[yourIdentifier1, yourIdentefier2]];
2. Next, add a call to buy methods and restore purchases to the purchase screen
3. Add a delegate to manage purchases

**Use methods and properties**

*+(WIZPurchaseHelper\*)sharedInstance*

Call singleton


*- (void)validateProductIdentifiers:(NSArray \*)productIdentifiers*

Initiate the helper and return a list of products


*- (BOOL)canMakePayments*

Check available payment


*- (void)payWithIdentefier:(NSString\*)identifier*

Creates a purchase request


*- (void)refreshReceipt*

Restore old purchases


**Use delegate**

*-(void)WIZPurchaseHelperProducts:(NSArray<SKProduct \*>\*)products;*

Return list of products


*-(void)WIZPurchaseHelperPaymentComplete:(NSString\*)identifier*

Tells what purchase was made or a product restore


*-(void)WIZPurchaseHelperPaymentFailedProductIdentifier:(NSString\*)identifier error:(NSError\*)error*

Tells what purchase return error


*-(void)WIZPurchaseHelperCallPromotedPurchase:(NSString\*)identifier*

Called when a promoting purchase is made