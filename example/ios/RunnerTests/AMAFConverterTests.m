#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCrashes/AppMetricaCrashes.h>
@import AppMetricaLibraryAdapter;

#import "AMAFConverter.h"

@interface AMAFConverterTests : XCTestCase
@end

@implementation AMAFConverterTests

static NSString *const kTestAPIKey = @"12345678-1234-1234-1234-123456789012";

- (void)testConvertAdRevenueNilAndHappyPath
{
    XCTAssertNil([AMAFConverter convertAdRevenue:nil]);

    AMAFAdRevenuePigeon *pigeon = [AMAFAdRevenuePigeon makeWithAdRevenue:@"1.25"
                                                                currency:@"USD"
                                                                  adType:AMAFAdTypePigeonBANNER
                                                               adNetwork:@"network"
                                                                adUnitId:@"unit-id"
                                                              adUnitName:@"unit-name"
                                                           adPlacementId:@"placement-id"
                                                         adPlacementName:@"placement-name"
                                                               precision:@"exact"
                                                                 payload:@{@"k": @"v"}];
    AMAAdRevenueInfo *info = [AMAFConverter convertAdRevenue:pigeon];
    XCTAssertNotNil(info);
    XCTAssertEqualObjects(info.adRevenue, [NSDecimalNumber decimalNumberWithString:@"1.25"]);
    XCTAssertEqualObjects(info.currency, @"USD");
    XCTAssertEqual(info.adType, AMAAdTypeBanner);
    XCTAssertEqualObjects(info.adNetwork, @"network");
    XCTAssertEqualObjects(info.adUnitID, @"unit-id");
    XCTAssertEqualObjects(info.adUnitName, @"unit-name");
    XCTAssertEqualObjects(info.adPlacementID, @"placement-id");
    XCTAssertEqualObjects(info.adPlacementName, @"placement-name");
    XCTAssertEqualObjects(info.precision, @"exact");
    XCTAssertEqualObjects(info.payload[@"k"], @"v");
}

- (void)testConvertLibraryAdapterAndReporterConfiguration
{
    AMAFAppMetricaLibraryAdapterConfigPigeon *adapterPigeon =
        [AMAFAppMetricaLibraryAdapterConfigPigeon makeWithAdvIdentifiersTracking:@YES];
    AMAAnalyticsLibraryAdapterConfiguration *adapter =
        [AMAFConverter convertAppMetricaLibraryAdapterConfiguration:adapterPigeon];
    XCTAssertNotNil(adapter);
    XCTAssertTrue(adapter.advertisingIdentifiersTrackingEnabled);

    AMAFReporterConfigPigeon *reporterPigeon =
        [AMAFReporterConfigPigeon makeWithApiKey:kTestAPIKey
                                  appEnvironment:nil
                              dataSendingEnabled:@NO
                           dispatchPeriodSeconds:nil
                                            logs:@YES
                                 maxReportsCount:nil
                       maxReportsInDatabaseCount:@42
                                  sessionTimeout:@120
                                   userProfileID:@"user-1"];
    AMAReporterConfiguration *reporter = [AMAFConverter convertReporterConfiguration:reporterPigeon];
    XCTAssertEqualObjects(reporter.APIKey, kTestAPIKey);
    XCTAssertFalse(reporter.dataSendingEnabled);
    XCTAssertTrue(reporter.logsEnabled);
    XCTAssertEqual(reporter.maxReportsInDatabaseCount, 42u);
    XCTAssertEqual(reporter.sessionTimeout, 120u);
    XCTAssertEqualObjects(reporter.userProfileID, @"user-1");
}

- (void)testConvertAppMetricaAndCrashesConfiguration
{
    AMAFLocationPigeon *location =
        [AMAFLocationPigeon makeWithLatitude:@55.75
                                   longitude:@37.61
                                    provider:nil
                                    altitude:@100
                                    accuracy:@10
                                      course:@1
                                       speed:@2
                                   timestamp:@1700000000];
    AMAFPreloadInfoPigeon *preload =
        [AMAFPreloadInfoPigeon makeWithTrackingId:@"track-1"
                                   additionalInfo:@{@"a": @"b"}];
    AMAFAppMetricaConfigPigeon *config =
        [AMAFAppMetricaConfigPigeon makeWithApiKey:kTestAPIKey
                           advIdentifiersTracking:@YES
                                    anrMonitoring:@YES
                             anrMonitoringTimeout:@5
                                   appBuildNumber:@12
                                   appEnvironment:nil
                           appOpenTrackingEnabled:@YES
                                       appVersion:@"1.2.3"
                                   crashReporting:@NO
                                      customHosts:@[@"https://example.com"]
                              dataSendingEnabled:@YES
                                      deviceType:nil
                           dispatchPeriodSeconds:@30
                               errorEnvironment:nil
                         firstActivationAsUpdate:@YES
                                        location:location
                               locationTracking:@YES
                                            logs:@YES
                                maxReportsCount:@7
                      maxReportsInDatabaseCount:@9
                           nativeCrashReporting:nil
                                    preloadInfo:preload
                      revenueAutoTrackingEnabled:@YES
                                  sessionTimeout:@90
                   sessionsAutoTrackingEnabled:@YES
                                 userProfileID:@"profile"];

    AMAAppMetricaConfiguration *converted = [AMAFConverter convertAppMetricaConfiguration:config];
    XCTAssertEqualObjects(converted.APIKey, kTestAPIKey);
    XCTAssertTrue(converted.advertisingIdentifierTrackingEnabled);
    XCTAssertEqualObjects(converted.appVersion, @"1.2.3");
    XCTAssertEqualObjects(converted.userProfileID, @"profile");
    XCTAssertTrue(converted.handleFirstActivationAsUpdate);
    XCTAssertNotNil(converted.customLocation);
    XCTAssertTrue(converted.locationTracking);
    XCTAssertTrue(converted.logsEnabled);
    XCTAssertEqual(converted.sessionTimeout, 90u);
    XCTAssertTrue(converted.dataSendingEnabled);
    XCTAssertEqual(converted.maxReportsInDatabaseCount, 9u);
    XCTAssertTrue(converted.sessionsAutoTracking);
    XCTAssertTrue(converted.revenueAutoTrackingEnabled);
    XCTAssertTrue(converted.appOpenTrackingEnabled);
    XCTAssertEqualObjects(converted.customHosts, (@[@"https://example.com"]));
    XCTAssertEqualObjects(converted.appBuildNumber, @"12");
    XCTAssertEqual(converted.dispatchPeriod, 30u);
    XCTAssertEqual(converted.maxReportsCount, 7u);
    XCTAssertNotNil(converted.preloadInfo);

    AMAAppMetricaCrashesConfiguration *crashes = [AMAFConverter convertCrashesConfiguration:config];
    XCTAssertFalse(crashes.autoCrashTracking);
    XCTAssertTrue(crashes.applicationNotRespondingDetection);
    XCTAssertEqual(crashes.applicationNotRespondingPingInterval, 5u);
}

- (void)testConvertLocationNilAndValues
{
    XCTAssertNil([AMAFConverter convertLocation:nil]);

    AMAFLocationPigeon *pigeon =
        [AMAFLocationPigeon makeWithLatitude:@10
                                   longitude:@20
                                    provider:@"gps"
                                    altitude:@30
                                    accuracy:@4
                                      course:@5
                                       speed:@6
                                   timestamp:@100];
    CLLocation *location = [AMAFConverter convertLocation:pigeon];
    XCTAssertEqualWithAccuracy(location.coordinate.latitude, 10.0, 0.0001);
    XCTAssertEqualWithAccuracy(location.coordinate.longitude, 20.0, 0.0001);
    XCTAssertEqualWithAccuracy(location.altitude, 30.0, 0.0001);
    XCTAssertEqualWithAccuracy(location.horizontalAccuracy, 4.0, 0.0001);
    XCTAssertEqualWithAccuracy(location.course, 5.0, 0.0001);
    XCTAssertEqualWithAccuracy(location.speed, 6.0, 0.0001);
    XCTAssertEqualWithAccuracy(location.timestamp.timeIntervalSince1970, 100.0, 0.0001);
}

- (void)testConvertECommerceEventTypes
{
    AMAFECommerceScreenPigeon *screen =
        [AMAFECommerceScreenPigeon makeWithName:@"Home"
                                 categoriesPath:@[@"a", @"b"]
                                    searchQuery:@"q"
                                        payload:@{@"p": @"1"}];
    AMAFECommerceAmountPigeon *amount =
        [AMAFECommerceAmountPigeon makeWithAmount:@"9.99" currency:@"USD"];
    AMAFECommercePricePigeon *price =
        [AMAFECommercePricePigeon makeWithFiat:amount internalComponents:@[amount]];
    AMAFECommerceProductPigeon *product =
        [AMAFECommerceProductPigeon makeWithSku:@"SKU-1"
                                           name:@"Phone"
                                 categoriesPath:@[@"Electronics"]
                                        payload:@{@"brand": @"X"}
                                    actualPrice:price
                                  originalPrice:price
                                     promocodes:@[@"SALE"]];
    AMAFECommerceReferrerPigeon *referrer =
        [AMAFECommerceReferrerPigeon makeWithType:@"button"
                                       identifier:@"buy"
                                           screen:screen];
    AMAFECommerceCartItemPigeon *cartItem =
        [AMAFECommerceCartItemPigeon makeWithProduct:product
                                            quantity:@"2"
                                           revenue:price
                                        referrer:referrer];
    AMAFECommerceOrderPigeon *order =
        [AMAFECommerceOrderPigeon makeWithIdentifier:@"order-1"
                                               items:@[cartItem]
                                             payload:@{@"channel": @"app"}];

    // AMAECommerce nested fields are not in the public header; use KVC (same as Internal).
    typedef NS_ENUM(NSUInteger, AMAFTestECommerceEventType) {
        AMAFTestECommerceEventTypeScreen = 0,
        AMAFTestECommerceEventTypeProductCard,
        AMAFTestECommerceEventTypeProductDetails,
        AMAFTestECommerceEventTypeAddToCart,
        AMAFTestECommerceEventTypeRemoveFromCart,
        AMAFTestECommerceEventTypeBeginCheckout,
        AMAFTestECommerceEventTypePurchase,
    };

    AMAECommerce *showScreen =
        [AMAFConverter convertECommerce:[AMAFECommerceEventPigeon makeWithEventType:@"show_screen_event"
                                                                           cartItem:nil
                                                                              order:nil
                                                                            product:nil
                                                                           referrer:nil
                                                                             screen:screen]];
    XCTAssertNotNil(showScreen);
    XCTAssertEqual([[showScreen valueForKey:@"eventType"] unsignedIntegerValue], AMAFTestECommerceEventTypeScreen);
    AMAECommerceScreen *convertedScreen = [showScreen valueForKey:@"screen"];
    XCTAssertEqualObjects(convertedScreen.name, @"Home");
    XCTAssertEqualObjects(convertedScreen.categoryComponents, (@[@"a", @"b"]));
    XCTAssertEqualObjects(convertedScreen.searchQuery, @"q");
    XCTAssertEqualObjects(convertedScreen.payload[@"p"], @"1");

    AMAECommerce *showCard =
        [AMAFConverter convertECommerce:[AMAFECommerceEventPigeon makeWithEventType:@"show_product_card_event"
                                                                           cartItem:nil
                                                                              order:nil
                                                                            product:product
                                                                           referrer:nil
                                                                             screen:screen]];
    XCTAssertNotNil(showCard);
    XCTAssertEqual([[showCard valueForKey:@"eventType"] unsignedIntegerValue], AMAFTestECommerceEventTypeProductCard);
    AMAECommerceProduct *convertedProduct = [showCard valueForKey:@"product"];
    XCTAssertEqualObjects(convertedProduct.sku, @"SKU-1");
    XCTAssertEqualObjects(convertedProduct.name, @"Phone");
    XCTAssertEqualObjects(convertedProduct.categoryComponents, (@[@"Electronics"]));
    XCTAssertEqualObjects(convertedProduct.payload[@"brand"], @"X");
    XCTAssertEqualObjects(convertedProduct.promoCodes, (@[@"SALE"]));
    XCTAssertEqualObjects(convertedProduct.actualPrice.fiat.value, [NSDecimalNumber decimalNumberWithString:@"9.99"]);
    XCTAssertEqualObjects(convertedProduct.actualPrice.fiat.unit, @"USD");
    XCTAssertEqual(convertedProduct.actualPrice.internalComponents.count, 1u);
    AMAECommerceScreen *cardScreen = [showCard valueForKey:@"screen"];
    XCTAssertEqualObjects(cardScreen.name, @"Home");
    XCTAssertEqualObjects(cardScreen.searchQuery, @"q");

    AMAECommerce *showDetails =
        [AMAFConverter convertECommerce:[AMAFECommerceEventPigeon makeWithEventType:@"show_product_details_event"
                                                                           cartItem:nil
                                                                              order:nil
                                                                            product:product
                                                                           referrer:referrer
                                                                             screen:nil]];
    XCTAssertNotNil(showDetails);
    XCTAssertEqual([[showDetails valueForKey:@"eventType"] unsignedIntegerValue], AMAFTestECommerceEventTypeProductDetails);
    AMAECommerceReferrer *convertedReferrer = [showDetails valueForKey:@"referrer"];
    XCTAssertEqualObjects(convertedReferrer.type, @"button");
    XCTAssertEqualObjects(convertedReferrer.identifier, @"buy");
    XCTAssertEqualObjects(convertedReferrer.screen.name, @"Home");

    AMAECommerce *addCart =
        [AMAFConverter convertECommerce:[AMAFECommerceEventPigeon makeWithEventType:@"add_cart_item_event"
                                                                           cartItem:cartItem
                                                                              order:nil
                                                                            product:nil
                                                                           referrer:nil
                                                                             screen:nil]];
    XCTAssertNotNil(addCart);
    XCTAssertEqual([[addCart valueForKey:@"eventType"] unsignedIntegerValue], AMAFTestECommerceEventTypeAddToCart);
    AMAECommerceCartItem *convertedCartItem = [addCart valueForKey:@"cartItem"];
    XCTAssertEqualObjects(convertedCartItem.product.sku, @"SKU-1");
    XCTAssertEqualObjects(convertedCartItem.quantity, [NSDecimalNumber decimalNumberWithString:@"2"]);
    XCTAssertEqualObjects(convertedCartItem.revenue.fiat.value, [NSDecimalNumber decimalNumberWithString:@"9.99"]);
    XCTAssertEqualObjects(convertedCartItem.referrer.type, @"button");

    AMAECommerce *removeCart =
        [AMAFConverter convertECommerce:[AMAFECommerceEventPigeon makeWithEventType:@"remove_cart_item_event"
                                                                           cartItem:cartItem
                                                                              order:nil
                                                                            product:nil
                                                                           referrer:nil
                                                                             screen:nil]];
    XCTAssertNotNil(removeCart);
    XCTAssertEqual([[removeCart valueForKey:@"eventType"] unsignedIntegerValue], AMAFTestECommerceEventTypeRemoveFromCart);

    AMAECommerce *beginCheckout =
        [AMAFConverter convertECommerce:[AMAFECommerceEventPigeon makeWithEventType:@"begin_checkout_event"
                                                                           cartItem:nil
                                                                              order:order
                                                                            product:nil
                                                                           referrer:nil
                                                                             screen:nil]];
    XCTAssertNotNil(beginCheckout);
    XCTAssertEqual([[beginCheckout valueForKey:@"eventType"] unsignedIntegerValue], AMAFTestECommerceEventTypeBeginCheckout);
    AMAECommerceOrder *convertedOrder = [beginCheckout valueForKey:@"order"];
    XCTAssertEqualObjects(convertedOrder.identifier, @"order-1");
    XCTAssertEqual(convertedOrder.cartItems.count, 1u);
    XCTAssertEqualObjects(convertedOrder.cartItems.firstObject.product.sku, @"SKU-1");
    XCTAssertEqualObjects(convertedOrder.payload[@"channel"], @"app");

    AMAECommerce *purchase =
        [AMAFConverter convertECommerce:[AMAFECommerceEventPigeon makeWithEventType:@"purchase_event"
                                                                           cartItem:nil
                                                                              order:order
                                                                            product:nil
                                                                           referrer:nil
                                                                             screen:nil]];
    XCTAssertNotNil(purchase);
    XCTAssertEqual([[purchase valueForKey:@"eventType"] unsignedIntegerValue], AMAFTestECommerceEventTypePurchase);
    XCTAssertEqualObjects([[purchase valueForKey:@"order"] identifier], @"order-1");

    AMAFECommerceEventPigeon *unknown =
        [AMAFECommerceEventPigeon makeWithEventType:@"unknown_event"
                                           cartItem:nil
                                              order:nil
                                            product:nil
                                           referrer:nil
                                             screen:nil];
    XCTAssertNil([AMAFConverter convertECommerce:unknown]);
}

- (void)testConvertErrorDetailsAndStackTrace
{
    XCTAssertNil([AMAFConverter convertPluginErrorDetails:nil]);
    XCTAssertNil([AMAFConverter convertStackTraceElements:nil]);

    AMAFStackTraceElementPigeon *frame =
        [AMAFStackTraceElementPigeon makeWithClassName:@"MyClass"
                                              fileName:@"file.dart"
                                                  line:@10
                                                column:@2
                                            methodName:@"method"];
    NSArray<AMAStackTraceElement *> *elements =
        [AMAFConverter convertStackTraceElements:@[frame]];
    XCTAssertEqual(elements.count, 1u);
    XCTAssertEqualObjects(elements[0].className, @"MyClass");
    XCTAssertEqualObjects(elements[0].fileName, @"file.dart");
    XCTAssertEqualObjects(elements[0].line, @10);
    XCTAssertEqualObjects(elements[0].column, @2);
    XCTAssertEqualObjects(elements[0].methodName, @"method");

    AMAFErrorDetailsPigeon *error =
        [AMAFErrorDetailsPigeon makeWithExceptionClass:@"StateError"
                                               message:@"boom"
                                           dartVersion:@"3.0.0"
                                             backtrace:@[frame]];
    AMAPluginErrorDetails *details = [AMAFConverter convertPluginErrorDetails:error];
    XCTAssertEqualObjects(details.exceptionClass, @"StateError");
    XCTAssertEqualObjects(details.message, @"boom");
    XCTAssertEqualObjects(details.virtualMachineVersion, @"3.0.0");
    XCTAssertEqual(details.backtrace.count, 1u);
}

- (void)testConvertUserProfileAndRevenue
{
    AMAFUserProfileAttributePigeon *nameAttr =
        [AMAFUserProfileAttributePigeon makeWithKey:@"name"
                                        doubleValue:nil
                                        stringValue:@"Alice"
                                          boolValue:nil
                                               year:nil
                                              month:nil
                                                day:nil
                                                age:nil
                                        genderValue:AMAFGenderPigeonUNDEFINED
                                       stringValues:nil
                                        ifUndefined:nil
                                              reset:@NO
                                               type:AMAFUserProfileAttributeTypeNAME];
    AMAFUserProfileAttributePigeon *boolAttr =
        [AMAFUserProfileAttributePigeon makeWithKey:@"premium"
                                        doubleValue:nil
                                        stringValue:nil
                                          boolValue:@YES
                                               year:nil
                                              month:nil
                                                day:nil
                                                age:nil
                                        genderValue:AMAFGenderPigeonUNDEFINED
                                       stringValues:nil
                                        ifUndefined:@NO
                                              reset:@NO
                                               type:AMAFUserProfileAttributeTypeBOOLEAN];
    AMAFUserProfileAttributePigeon *numberAttr =
        [AMAFUserProfileAttributePigeon makeWithKey:@"score"
                                        doubleValue:@42.5
                                        stringValue:nil
                                          boolValue:nil
                                               year:nil
                                              month:nil
                                                day:nil
                                                age:nil
                                        genderValue:AMAFGenderPigeonUNDEFINED
                                       stringValues:nil
                                        ifUndefined:@NO
                                              reset:@NO
                                               type:AMAFUserProfileAttributeTypeNUMBER];
    AMAFUserProfileAttributePigeon *genderAttr =
        [AMAFUserProfileAttributePigeon makeWithKey:@"gender"
                                        doubleValue:nil
                                        stringValue:nil
                                          boolValue:nil
                                               year:nil
                                              month:nil
                                                day:nil
                                                age:nil
                                        genderValue:AMAFGenderPigeonFEMALE
                                       stringValues:nil
                                        ifUndefined:nil
                                              reset:@NO
                                               type:AMAFUserProfileAttributeTypeGENDER];
    AMAFUserProfileAttributePigeon *birthAttr =
        [AMAFUserProfileAttributePigeon makeWithKey:@"birth"
                                        doubleValue:nil
                                        stringValue:nil
                                          boolValue:nil
                                               year:@1990
                                              month:@5
                                                day:@15
                                                age:nil
                                        genderValue:AMAFGenderPigeonUNDEFINED
                                       stringValues:nil
                                        ifUndefined:nil
                                              reset:@NO
                                               type:AMAFUserProfileAttributeTypeBIRTH_DATE];
    AMAFUserProfileAttributePigeon *resetName =
        [AMAFUserProfileAttributePigeon makeWithKey:@"name"
                                        doubleValue:nil
                                        stringValue:nil
                                          boolValue:nil
                                               year:nil
                                              month:nil
                                                day:nil
                                                age:nil
                                        genderValue:AMAFGenderPigeonUNDEFINED
                                       stringValues:nil
                                        ifUndefined:nil
                                              reset:@YES
                                               type:AMAFUserProfileAttributeTypeNAME];
    AMAFUserProfilePigeon *profile =
        [AMAFUserProfilePigeon makeWithAttributes:@[
            nameAttr, boolAttr, numberAttr, genderAttr, birthAttr, resetName
        ]];
    AMAUserProfile *convertedProfile = [AMAFConverter convertUserProfile:profile];
    XCTAssertNotNil(convertedProfile);
    XCTAssertEqual(convertedProfile.updates.count, 6u);

    AMAFRevenuePigeon *revenue =
        [AMAFRevenuePigeon makeWithPrice:@"9.99"
                                currency:@"EUR"
                                quantity:@2
                               productId:@"sku-1"
                                 payload:@"{\"x\":1}"
                                 receipt:[AMAFReceiptPigeon makeWithData:@"receipt" signature:nil]
                           transactionId:@"tx-1"];
    AMARevenueInfo *convertedRevenue = [AMAFConverter convertRevenueInfo:revenue];
    XCTAssertEqualObjects(convertedRevenue.priceDecimal, [NSDecimalNumber decimalNumberWithString:@"9.99"]);
    XCTAssertEqualObjects(convertedRevenue.currency, @"EUR");
    XCTAssertEqual(convertedRevenue.quantity, 2u);
    XCTAssertEqualObjects(convertedRevenue.productID, @"sku-1");
    XCTAssertEqualObjects(convertedRevenue.transactionID, @"tx-1");
    XCTAssertNotNil(convertedRevenue.receiptData);
    XCTAssertEqualObjects(convertedRevenue.payload[@"x"], @1);
}

- (void)testConvertStartupIdentifiersKeysAndToPigeon
{
    NSArray<NSString *> *keys =
        [AMAFConverter convertStartupIdentifiersKeys:@[
            @"appmetrica_uuid",
            @"appmetrica_device_id",
            @"appmetrica_device_id_hash",
            @"custom_key"
        ]];
    XCTAssertEqualObjects(keys, (@[kAMAUUIDKey, kAMADeviceIDKey, kAMADeviceIDHashKey, @"custom_key"]));

    NSDictionary *identifiers = @{
        kAMAUUIDKey: @"uuid-1",
        kAMADeviceIDKey: @"device-1",
        kAMADeviceIDHashKey: @"hash-1"
    };
    AMAFStartupParamsPigeon *ok =
        [AMAFConverter convertToPigeonIdentifiers:identifiers withError:nil];
    XCTAssertNotNil(ok.result);
    XCTAssertNil(ok.reason);
    XCTAssertEqualObjects(ok.result.uuid, @"uuid-1");
    XCTAssertEqualObjects(ok.result.deviceId, @"device-1");
    XCTAssertEqualObjects(ok.result.deviceIdHash, @"hash-1");
    XCTAssertEqualObjects(ok.result.parameters[@"appmetrica_uuid"].id, @"uuid-1");

    NSError *error = [NSError errorWithDomain:@"test" code:1 userInfo:@{NSLocalizedDescriptionKey: @"fail"}];
    AMAFStartupParamsPigeon *fail =
        [AMAFConverter convertToPigeonIdentifiers:nil withError:error];
    XCTAssertNil(fail.result);
    XCTAssertEqualObjects(fail.reason.value, error.description);
}

@end
