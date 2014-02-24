//
//  InAppPurchase.h
//  Kronus
//
//  Created by Lion on 12-11-21.
//
//

#import <Foundation/Foundation.h>
#import "InAppPurchaseManager.h"

#ifdef GRE
#define IAPProductIdentifierNoAd @"vss_gre_no_ad"
#endif

#ifdef TOEFL
#define IAPProductIdentifierNoAd @"no_ad"
#endif

#ifdef SAT
#define IAPProductIdentifierNoAd @"vss_sat_no_ad"
#endif

#ifdef IELTS
#define IAPProductIdentifierNoAd @"vss_ielts_no_ad"
#endif

#ifdef GMAT
#define IAPProductIdentifierNoAd @"vss_gmat_no_ad"
#endif


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
