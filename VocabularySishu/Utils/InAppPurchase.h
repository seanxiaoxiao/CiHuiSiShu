//
//  InAppPurchase.h
//  Kronus
//
//  Created by Lion on 12-11-21.
//
//

#import <Foundation/Foundation.h>
#import "InAppPurchaseManager.h"

#define IAPProductIdentifierNoAd @"no_ad"
#define AllIdentifiers [NSSet setWithObjects: \
                        IAPProductIdentifierNoAd, \
                        nil]


@interface InAppPurchase : NSObject <InAppPurchaseDelegate>

+ (void)loadStore;
+ (BOOL)canMakePurchase;
+ (void)requestProductsData;
+ (void)purchaseProductWithIdentifier:(NSString *)identifier;
+ (void)restorePurchases;

@end
