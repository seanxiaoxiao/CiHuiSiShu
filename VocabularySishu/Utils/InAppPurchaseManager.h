//
//  InAppPurchaseManager.h
//  Kronus
//
//  Created by Lion on 12-11-19.
//
//

#import <StoreKit/StoreKit.h>

#define kProductDataReadyEvent @"kProductDataReadyEvent"
#define kProductDataMissedEvent @"kProductDataMissedEvent"
#define kProductPurchaseFailed @"kProductPurchaseFailed"
#define kProductPurchaseCancelled @"kProductPurchaseCancelled"
#define kProductPurchaseSucceeded @"kProductPurchaseSucceeded"

@protocol InAppPurchaseDelegate <NSObject>

@required
- (NSSet *)allIdentifiers;
- (void)recordTransaction:(SKPaymentTransaction *)transaction;
- (void)provideContent:(NSString *)productIdentifer;

@end

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    @private
    id<InAppPurchaseDelegate> _delegate;
    SKProductsRequest *_request;
}

@property (nonatomic, readonly) NSDictionary *products;

- (void)loadStoreWithDelegate:(id<InAppPurchaseDelegate>)delegate;

- (void)requestProductDataWithIdentifiers:(NSSet *)identifiers;
- (BOOL)canMakePurchases;
- (void)purchaseProductWithIdentifier:(NSString *)identifier;
- (void)restorePurchases;

+ (InAppPurchaseManager *)sharedInAppPurchaseManager;

@end

@interface SKProduct (LocalizedPrice)

- (NSString *)localizedPrice;

@end