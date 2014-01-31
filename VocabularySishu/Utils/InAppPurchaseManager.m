//
//  InAppPurchaseManager.m
//  Kronus
//
//  Created by Lion on 12-11-19.
//
//

#import "InAppPurchaseManager.h"

static InAppPurchaseManager *_instance;

@interface InAppPurchaseManager (Private)

- (void)completeTransaction:(SKPaymentTransaction *)transaction;
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreTransaction:(SKPaymentTransaction *)transaction;

@end

@implementation InAppPurchaseManager

@synthesize products = _products;


- (void)loadStoreWithDelegate:(id<InAppPurchaseDelegate>)delegate
{
    _delegate = delegate;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self requestProductDataWithIdentifiers:[_delegate allIdentifiers]];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseProductWithIdentifier:(NSString *)identifier
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:identifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)requestProductDataWithIdentifiers:(NSSet *)identifiers
{
    if (_products) {
        NSMutableSet *ids = [NSMutableSet set];
        for (NSString *identifier in identifiers) {
            if (![_products objectForKey:identifier]) {
                [ids addObject:identifier];
            }
        }
        identifiers = ids;
    }
    if (!identifiers.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductDataReadyEvent object:self];
        return;
    }
    [_request cancel];
    
    _request = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];

    _request.delegate = self;
    [_request start];

    // Timeout
}

- (void)restorePurchases
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

+ (InAppPurchaseManager *)sharedInAppPurchaseManager
{
    if (!_instance) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

#pragma mark - SKProductRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    _request = nil;
    
    NSArray *products = response.products;
    if (!products.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductDataMissedEvent object:self];
        return;
    }
    NSMutableDictionary *productDict = [NSMutableDictionary dictionaryWithCapacity:products.count];
    for (SKProduct *product in products) {
        [productDict setObject:product forKey:product.productIdentifier];
    }
    if (_products) {
        [_products enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [productDict setObject:obj forKey:key];
        }];
    }
    _products = productDict;
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductDataReadyEvent object:self];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductDataMissedEvent object:self];
}

#pragma mark - SKPaymentTransactionObserver methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Private methods

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSString *productIdentifier = transaction.payment.productIdentifier;
    [_delegate recordTransaction:transaction];
    [_delegate provideContent:productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseSucceeded object:productIdentifier];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailed object:transaction.error];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseCancelled object:transaction.error];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSString *productIdentifier = transaction.originalTransaction.payment.productIdentifier;
    [_delegate recordTransaction:transaction];
    [_delegate provideContent:productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseSucceeded object:productIdentifier];
}

@end

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:self.priceLocale];
    return [formatter stringFromNumber:self.price];
}

@end