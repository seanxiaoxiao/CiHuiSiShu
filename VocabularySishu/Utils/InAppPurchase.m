//
//  InAppPurchase.m
//  Kronus
//
//  Created by Lion on 12-11-21.
//
//

#import "InAppPurchase.h"

@implementation InAppPurchase

+ (BOOL)canMakePurchase
{
    return [[InAppPurchaseManager sharedInAppPurchaseManager] canMakePurchases];
}

+ (void)loadStore
{
    InAppPurchase *iap = [[self alloc] init];
    [[InAppPurchaseManager sharedInAppPurchaseManager] loadStoreWithDelegate:iap];
}

+ (void)requestProductsData
{
    [[InAppPurchaseManager sharedInAppPurchaseManager] requestProductDataWithIdentifiers:AllIdentifiers];
}

+ (void)purchaseProductWithIdentifier:(NSString *)identifier
{
    [[InAppPurchaseManager sharedInAppPurchaseManager] purchaseProductWithIdentifier:identifier];
}

+ (void)restorePurchases
{
    [[InAppPurchaseManager sharedInAppPurchaseManager] restorePurchases];
}

#pragma mark - InAppPurchaseDelegate methods

- (NSSet *)allIdentifiers
{
    return AllIdentifiers;
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:[NSString stringWithFormat:@"%@_Receipt", transaction.payment.productIdentifier]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)provideContent:(NSString *)identifier
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldHideAd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

