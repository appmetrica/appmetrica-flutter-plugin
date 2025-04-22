
#import "AMAFConverter.h"
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCrashes/AppMetricaCrashes.h>
#import <CoreLocation/CoreLocation.h>

@implementation AMAFConverter

static NSString *const kAMAFShowScreenEvent = @"show_screen_event";
static NSString *const kAMAFShowProductCardEvent = @"show_product_card_event";
static NSString *const kAMAFShowProductDetailsEvent = @"show_product_details_event";
static NSString *const kAMAFAddCartItemEvent = @"add_cart_item_event";
static NSString *const kAMAFRemoveCartItemEvent = @"remove_cart_item_event";
static NSString *const kAMAFBeginCheckoutEvent = @"begin_checkout_event";
static NSString *const kAMAFPurchaceEvent = @"purchase_event";

static NSString *const kAMAFUUIDRealKey = @"appmetrica_uuid";
static NSString *const kAMAFDeviceIdRealKey = @"appmetrica_device_id";
static NSString *const kAMAFDeviceIdHashRealKey = @"appmetrica_device_id_hash";

+ (AMAAdRevenueInfo *)convertAdRevenue:(AMAFAdRevenuePigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    AMAMutableAdRevenueInfo *adRevenueInfo = [[AMAMutableAdRevenueInfo alloc] initWithAdRevenue:[NSDecimalNumber decimalNumberWithString:pigeon.adRevenue]
                                                                                       currency:pigeon.currency];
    adRevenueInfo.adType = [self convertAdType:pigeon.adType];
    if (pigeon.adNetwork != nil) {
        adRevenueInfo.adNetwork = pigeon.adNetwork;
    }
    if (pigeon.adUnitId != nil) {
        adRevenueInfo.adUnitID = pigeon.adUnitId;
    }
    if (pigeon.adUnitName != nil) {
        adRevenueInfo.adUnitName = pigeon.adUnitName;
    }
    if (pigeon.adPlacementId != nil) {
        adRevenueInfo.adPlacementID = pigeon.adPlacementId;
    }
    if (pigeon.adPlacementName != nil) {
        adRevenueInfo.adPlacementName = pigeon.adPlacementName;
    }
    if (pigeon.precision != nil) {
        adRevenueInfo.precision = pigeon.precision;
    }
    if (pigeon.payload != nil) {
        adRevenueInfo.payload = pigeon.payload;
    }
    
    return [adRevenueInfo copy];
}

+ (AMAAdType)convertAdType:(AMAFAdTypePigeon)adType
{
    switch (adType) {
        case AMAFAdTypePigeonUNKNOWN:
            return AMAAdTypeUnknown;
        case AMAFAdTypePigeonNATIVE:
            return AMAAdTypeNative;
        case AMAFAdTypePigeonBANNER:
            return AMAAdTypeBanner;
        case AMAFAdTypePigeonREWARDED:
            return AMAAdTypeRewarded;
        case AMAFAdTypePigeonINTERSTITIAL:
            return AMAAdTypeInterstitial;
        case AMAFAdTypePigeonMREC:
            return AMAAdTypeMrec;
        case AMAFAdTypePigeonAPP_OPEN:
            return AMAAdTypeAppOpen;
        case AMAFAdTypePigeonOTHER:
            return AMAAdTypeOther;
        default:
            return AMAAdTypeUnknown;
    }
}

+ (AMAReporterConfiguration *)convertReporterConfiguration:(AMAFReporterConfigPigeon *)pigeon;
{
    AMAMutableReporterConfiguration *configuration = [[AMAMutableReporterConfiguration alloc] initWithAPIKey:pigeon.apiKey];
    if (pigeon.sessionTimeout != nil) {
        configuration.sessionTimeout = pigeon.sessionTimeout.unsignedLongValue;
    }
    if (pigeon.dataSendingEnabled != nil) {
        configuration.dataSendingEnabled = pigeon.dataSendingEnabled.boolValue;
    }
    if (pigeon.maxReportsInDatabaseCount != nil) {
        configuration.maxReportsInDatabaseCount = pigeon.maxReportsInDatabaseCount.unsignedLongValue;
    }
    if (pigeon.userProfileID != nil) {
        configuration.userProfileID = pigeon.userProfileID;
    }
    if (pigeon.logs != nil) {
        configuration.logsEnabled = pigeon.logs.boolValue;
    }
    return configuration;
}

+ (AMAAppMetricaConfiguration *)convertAppMetricaConfiguration:(AMAFAppMetricaConfigPigeon *)configPigeon
{
    AMAAppMetricaConfiguration *configuration = [[AMAAppMetricaConfiguration alloc] initWithAPIKey:configPigeon.apiKey];
    if (configPigeon.appVersion != nil) {
        configuration.appVersion = configPigeon.appVersion;
    }
    if (configPigeon.userProfileID != nil) {
        configuration.userProfileID = configPigeon.userProfileID;
    }
    if (configPigeon.firstActivationAsUpdate != nil) {
        configuration.handleFirstActivationAsUpdate = configPigeon.firstActivationAsUpdate.boolValue;
    }
    if (configPigeon.location != nil) {
        configuration.customLocation = [AMAFConverter convertLocation:configPigeon.location];
    }
    if (configPigeon.locationTracking != nil) {
        configuration.locationTracking = configPigeon.locationTracking.boolValue;
    }
    if (configPigeon.logs != nil) {
        configuration.logsEnabled = configPigeon.logs.boolValue;
    }
    if (configPigeon.sessionTimeout != nil) {
        configuration.sessionTimeout = configPigeon.sessionTimeout.unsignedIntegerValue;
    }
    if (configPigeon.dataSendingEnabled != nil) {
        configuration.dataSendingEnabled = configPigeon.dataSendingEnabled.boolValue;
    }
    if (configPigeon.preloadInfo != nil) {
        NSString *trackingId = configPigeon.preloadInfo.trackingId;
        if (trackingId.length != 0) {
            AMAAppMetricaPreloadInfo *info = [[AMAAppMetricaPreloadInfo alloc] initWithTrackingIdentifier:trackingId];
            for (NSString *key in configPigeon.preloadInfo.additionalInfo) {
                [info setAdditionalInfo:configPigeon.preloadInfo.additionalInfo[key] forKey:key];
            }
            configuration.preloadInfo = info;
        }
    }
    if (configPigeon.maxReportsInDatabaseCount != nil) {
        configuration.maxReportsInDatabaseCount = configPigeon.maxReportsInDatabaseCount.unsignedLongValue;
    }
    if (configPigeon.sessionsAutoTrackingEnabled != nil) {
        configuration.sessionsAutoTracking = configPigeon.sessionsAutoTrackingEnabled.boolValue;
    }
    if (configPigeon.errorEnvironment != nil) {
        for (NSString *key in configPigeon.errorEnvironment) {
            [[AMAAppMetricaCrashes crashes] setErrorEnvironmentValue:configPigeon.errorEnvironment[key] forKey:key];
        }
    }
    if (configPigeon.revenueAutoTrackingEnabled != nil) {
        configuration.revenueAutoTrackingEnabled = configPigeon.revenueAutoTrackingEnabled.boolValue;
    }
    if (configPigeon.appOpenTrackingEnabled != nil) {
        configuration.appOpenTrackingEnabled = configPigeon.appOpenTrackingEnabled.boolValue;
    }
    if (configPigeon.customHosts != nil) {
        configuration.customHosts = configPigeon.customHosts;
    }
    if (configPigeon.appBuildNumber != nil) {
        configuration.appBuildNumber = configPigeon.appBuildNumber.stringValue;
    }
    if (configPigeon.dispatchPeriodSeconds != nil) {
        configuration.dispatchPeriod = configPigeon.dispatchPeriodSeconds.unsignedIntValue;
    }
    if (configPigeon.maxReportsCount != nil) {
        configuration.maxReportsCount = configPigeon.maxReportsCount.unsignedIntValue;
    }
    return configuration;
}

+ (AMAAppMetricaCrashesConfiguration *)convertCrashesConfiguration:(AMAFAppMetricaConfigPigeon *)pigeon
{
    AMAAppMetricaCrashesConfiguration *crashesConfiguration = [[AMAAppMetricaCrashesConfiguration alloc] init];
    if (pigeon.crashReporting != nil) {
        crashesConfiguration.autoCrashTracking = pigeon.crashReporting.boolValue;
    }
    if (pigeon.anrMonitoring != nil) {
        crashesConfiguration.applicationNotRespondingDetection = pigeon.anrMonitoring.boolValue;
    }
    if (pigeon.anrMonitoringTimeout != nil) {
        crashesConfiguration.applicationNotRespondingPingInterval = [pigeon.anrMonitoringTimeout unsignedIntegerValue];
    }
    return crashesConfiguration;
}

+ (AMAECommerce *)convertECommerce:(AMAFECommerceEventPigeon *)pigeon
{
    if ([kAMAFShowScreenEvent isEqualToString:pigeon.eventType]) {
        return [AMAECommerce showScreenEventWithScreen:[self convertScreen:pigeon.screen]];
    }
    if ([kAMAFShowProductCardEvent isEqualToString:pigeon.eventType]) {
        return [AMAECommerce showProductCardEventWithProduct:[self convertProduct:pigeon.product]
                                                      screen:[self convertScreen:pigeon.screen]];
    }
    if ([kAMAFShowProductDetailsEvent isEqualToString:pigeon.eventType]) {
        return [AMAECommerce showProductDetailsEventWithProduct:[self convertProduct:pigeon.product]
                                                       referrer:[self convertReferrer:pigeon.referrer]];
    }
    if ([kAMAFAddCartItemEvent isEqualToString:pigeon.eventType]) {
        return [AMAECommerce addCartItemEventWithItem:[self convertCartItem:pigeon.cartItem]];
    }
    if ([kAMAFRemoveCartItemEvent isEqualToString:pigeon.eventType]) {
        return [AMAECommerce removeCartItemEventWithItem:[self convertCartItem:pigeon.cartItem]];
    }
    if ([kAMAFBeginCheckoutEvent isEqualToString:pigeon.eventType]) {
        return [AMAECommerce beginCheckoutEventWithOrder:[self convertOrder:pigeon.order]];
    }
    if ([kAMAFPurchaceEvent isEqualToString:pigeon.eventType]) {
        return [AMAECommerce purchaseEventWithOrder:[self convertOrder:pigeon.order]];
    }
    return nil;
}

+ (AMAECommerceScreen *)convertScreen:(AMAFECommerceScreenPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[AMAECommerceScreen alloc] initWithName:pigeon.name
                                 categoryComponents:pigeon.categoriesPath
                                        searchQuery:pigeon.searchQuery
                                            payload:pigeon.payload];
}

+ (AMAECommerceProduct *)convertProduct:(AMAFECommerceProductPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[AMAECommerceProduct alloc] initWithSKU:pigeon.sku
                                               name:pigeon.name
                                 categoryComponents:pigeon.categoriesPath
                                            payload:pigeon.payload
                                        actualPrice:[self convertPrice:pigeon.actualPrice]
                                      originalPrice:[self convertPrice:pigeon.originalPrice]
                                         promoCodes:pigeon.promocodes];
}

+ (AMAECommercePrice *)convertPrice:(AMAFECommercePricePigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    NSMutableArray<AMAECommerceAmount *> *internalComponents = [NSMutableArray arrayWithCapacity:[pigeon.internalComponents count]];
    [pigeon.internalComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [internalComponents addObject:[self convertAmount:obj]];
    }];
    return [[AMAECommercePrice alloc] initWithFiat:[self convertAmount:pigeon.fiat]
                                internalComponents:internalComponents];
}

+ (AMAECommerceAmount *)convertAmount:(AMAFECommerceAmountPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[AMAECommerceAmount alloc] initWithUnit:pigeon.currency
                                              value:[NSDecimalNumber decimalNumberWithString:pigeon.amount]];
}

+ (AMAECommerceReferrer *)convertReferrer:(AMAFECommerceReferrerPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[AMAECommerceReferrer alloc] initWithType:pigeon.type
                                           identifier:pigeon.identifier
                                               screen:[self convertScreen:pigeon.screen]];
}

+ (AMAECommerceCartItem *)convertCartItem:(AMAFECommerceCartItemPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[AMAECommerceCartItem alloc] initWithProduct:[self convertProduct:pigeon.product]
                                                quantity:[NSDecimalNumber decimalNumberWithString:pigeon.quantity]
                                                 revenue:[self convertPrice:pigeon.revenue]
                                                referrer:[self convertReferrer:pigeon.referrer]];
}

+ (AMAECommerceOrder *)convertOrder:(AMAFECommerceOrderPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    NSMutableArray<AMAECommerceCartItem *> *cartItems = [NSMutableArray arrayWithCapacity:[pigeon.items count]];
    [pigeon.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [cartItems addObject:[self convertCartItem:obj]];
    }];
    return [[AMAECommerceOrder alloc] initWithIdentifier:pigeon.identifier
                                               cartItems:cartItems
                                                 payload:pigeon.payload];
}

+ (CLLocation *)convertLocation:(AMAFLocationPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(pigeon.latitude.doubleValue, pigeon.longitude.doubleValue)
                                         altitude:pigeon.altitude.doubleValue
                               horizontalAccuracy:pigeon.accuracy.doubleValue
                                 verticalAccuracy:pigeon.accuracy.doubleValue
                                           course:pigeon.course.doubleValue
                                            speed:pigeon.speed.doubleValue
                                        timestamp:[NSDate dateWithTimeIntervalSince1970: pigeon.timestamp.doubleValue]];
}

+ (AMAPluginErrorDetails *)convertPluginErrorDetails:(AMAFErrorDetailsPigeon *)error
{
    if (error == nil) {
        return nil;
    }
    return [[AMAPluginErrorDetails alloc] initWithExceptionClass:error.exceptionClass
                                                         message:error.message
                                                       backtrace:[self convertStackTraceElements:error.backtrace]
                                                        platform:kAMAPlatformFlutter
                                           virtualMachineVersion:error.dartVersion
                                               pluginEnvironment:@{}];
}

+ (NSArray<AMAStackTraceElement *> *)convertStackTraceElements:(NSArray<AMAFStackTraceElementPigeon *> *)backtracePigeon
{
    if (backtracePigeon == nil) {
        return nil;
    }
    NSMutableArray<AMAStackTraceElement *> *elements = [NSMutableArray arrayWithCapacity:backtracePigeon.count];
    for (AMAFStackTraceElementPigeon *backtrace in backtracePigeon) {
        if (backtrace != nil) {
            [elements addObject:[self convertStackTraceElement:backtrace]];
        }
    }
    return [elements copy];
}

+ (AMAStackTraceElement *)convertStackTraceElement:(AMAFStackTraceElementPigeon *)backtrace
{
    return [[AMAStackTraceElement alloc] initWithClassName:backtrace.className
                                                  fileName:backtrace.fileName
                                                      line:backtrace.line
                                                    column:backtrace.column
                                                methodName:backtrace.methodName];
}

+ (AMAUserProfile *)convertUserProfile:(AMAFUserProfilePigeon *)userProfile
{

    AMAMutableUserProfile *convertedUserProfile = [[AMAMutableUserProfile alloc] init];

    for (AMAFUserProfileAttributePigeon* attribute in userProfile.attributes) {
        AMAUserProfileUpdate *profileUpdate = nil;
        switch (attribute.type) {
            case AMAFUserProfileAttributeTypeNAME: {
                if (attribute.reset.boolValue) {
                    profileUpdate = [[AMAProfileAttribute name] withValueReset];
                } else {
                    profileUpdate = [[AMAProfileAttribute name] withValue:attribute.stringValue];
                }
                break;
            }
            case AMAFUserProfileAttributeTypeBIRTH_DATE: {
                id<AMABirthDateAttribute> birthdateAttribute = [AMAProfileAttribute birthDate];
                if (attribute.reset.boolValue) {
                    profileUpdate = [birthdateAttribute withValueReset];
                } else {
                    NSNumber *year = attribute.year;
                    NSNumber *month = attribute.month;
                    NSNumber *day = attribute.day;
                    NSNumber *age = attribute.age;
                    if (year == nil) {
                        if (age != nil) {
                            profileUpdate = [birthdateAttribute withAge:age.unsignedIntegerValue];
                        } else {
                            profileUpdate = nil;
                        }
                    } else {
                        if (month == nil) {
                            profileUpdate = [birthdateAttribute withYear:year.unsignedIntegerValue];
                        } else {
                            if (day == nil) {
                                profileUpdate = [birthdateAttribute withYear:year.unsignedIntegerValue
                                                                       month:month.unsignedIntegerValue];
                            } else {
                                profileUpdate = [birthdateAttribute withYear:year.unsignedIntegerValue
                                                                       month:month.unsignedIntegerValue
                                                                         day:day.unsignedIntegerValue];
                            }
                        }
                    }
                }
                break;
            }
            case AMAFUserProfileAttributeTypeBOOLEAN: {
                id<AMACustomBoolAttribute> booleanAttribute = [AMAProfileAttribute customBool:attribute.key];
                if (attribute.reset.boolValue) {
                    profileUpdate = [booleanAttribute withValueReset];
                } else {
                    if (attribute.ifUndefined.boolValue) {
                        profileUpdate = [booleanAttribute withValueIfUndefined:attribute.boolValue.boolValue];
                    } else {
                        profileUpdate = [booleanAttribute withValue:attribute.boolValue.boolValue];
                    }
                }
                break;
            }
            case AMAFUserProfileAttributeTypeCOUNTER: {
                profileUpdate = [[AMAProfileAttribute customCounter:attribute.key] withDelta:attribute.doubleValue.doubleValue];
                break;
            }
            case AMAFUserProfileAttributeTypeGENDER: {
                if (attribute.reset.boolValue) {
                    profileUpdate = [[AMAProfileAttribute gender] withValueReset];
                } else {
                    profileUpdate = [[AMAProfileAttribute gender] withValue:[self convertGender:attribute.genderValue]];
                }
                break;
            }
            case AMAFUserProfileAttributeTypeNOTIFICATION_ENABLED: {
                if (attribute.reset.boolValue) {
                    profileUpdate = [[AMAProfileAttribute notificationsEnabled] withValueReset];
                } else {
                    profileUpdate = [[AMAProfileAttribute notificationsEnabled] withValue:attribute.boolValue.boolValue];
                }
                break;
            }
            case AMAFUserProfileAttributeTypeNUMBER: {
                id<AMACustomNumberAttribute> numberAttribute = [AMAProfileAttribute customNumber:attribute.key];
                if (attribute.reset.boolValue) {
                    profileUpdate = [numberAttribute withValueReset];
                } else {
                    if (attribute.ifUndefined.boolValue) {
                        profileUpdate = [numberAttribute withValueIfUndefined:attribute.doubleValue.doubleValue];
                    } else {
                        profileUpdate = [numberAttribute withValue:attribute.doubleValue.doubleValue];
                    }
                }
                break;
            }
            case AMAFUserProfileAttributeTypeSTRING: {
                id<AMACustomStringAttribute> stringAttribute = [AMAProfileAttribute customString:attribute.key];
                if (attribute.reset.boolValue) {
                    profileUpdate = [stringAttribute withValueReset];
                } else {
                    if (attribute.ifUndefined.boolValue) {
                        profileUpdate = [stringAttribute withValueIfUndefined:attribute.stringValue];
                    } else {
                        profileUpdate = [stringAttribute withValue:attribute.stringValue];
                    }
                }
                break;
            }
        }

        if (profileUpdate != nil) {
            [convertedUserProfile apply:profileUpdate];
        }
    }
    return [convertedUserProfile copy];
}

+ (AMAGenderType)convertGender:(AMAFGenderPigeon)gender
{
    switch (gender) {
        case AMAFGenderPigeonMALE:
            return AMAGenderTypeMale;
        case AMAFGenderPigeonOTHER:
            return AMAGenderTypeOther;
        case AMAFGenderPigeonFEMALE:
            return AMAGenderTypeFemale;
        case AMAFGenderPigeonUNDEFINED:
        default:
            return AMAGenderTypeOther;
    }
}


+ (AMARevenueInfo *)convertRevenueInfo:(AMAFRevenuePigeon *)pigeon
{
    AMAMutableRevenueInfo *revenueInfo = [[AMAMutableRevenueInfo alloc] initWithPriceDecimal:[NSDecimalNumber decimalNumberWithString:pigeon.price]
                                                                                    currency:pigeon.currency];
    if (pigeon.quantity != nil) {
        revenueInfo.quantity = pigeon.quantity.unsignedLongValue;
    }
    if (pigeon.productId != nil) {
        revenueInfo.productID = pigeon.productId;
    }
    if (pigeon.transactionId != nil) {
        revenueInfo.transactionID = pigeon.transactionId;
    }
    if (pigeon.receipt != nil && pigeon.receipt.data != nil) {
        revenueInfo.receiptData = [pigeon.receipt.data dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (pigeon.payload != nil) {
        revenueInfo.payload = [self convertRevenueInfoPayload:pigeon.payload];
    }

    return [revenueInfo copy];
}

+ (NSDictionary *)convertRevenueInfoPayload:(NSString *)payload
{
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:kNilOptions
                                                           error:&error];
    if (error == nil && (dict == nil || [dict isKindOfClass:[NSDictionary class]])) {
        return dict;
    }
    else {
        NSLog(@"Invalid revenue payload to report to AppMetrica %@", payload);
        return nil;
    }
}

+ (NSArray<NSString *> *)convertStartupIdentifiersKeys:(NSArray<NSString *> *)pigeon
{
    NSDictionary *startupKeysMapping = @{
        kAMAFUUIDRealKey: kAMAUUIDKey,
        kAMAFDeviceIdRealKey: kAMADeviceIDKey,
        kAMAFDeviceIdHashRealKey: kAMADeviceIDHashKey,
    };

    NSMutableArray *identifierKeys = [NSMutableArray arrayWithCapacity:pigeon.count];
    for (NSString *sourceKey in pigeon) {
        NSString *key = startupKeysMapping[sourceKey] ?: sourceKey;
        [identifierKeys addObject:key];
    }
    return identifierKeys;
}

+ (AMAFStartupParamsPigeon *) convertToPigeonIdentifiers:(NSDictionary *)identifiers
                                               withError:(NSError *)error
{
    if (error == nil && identifiers != nil) {
        NSDictionary *startupKeysMapping = @{
            kAMAUUIDKey: kAMAFUUIDRealKey,
            kAMADeviceIDKey: kAMAFDeviceIdRealKey,
            kAMADeviceIDHashKey: kAMAFDeviceIdHashRealKey,
        };

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        for (NSString *key in [identifiers allKeys]) {
            NSString *realKey = startupKeysMapping[key] ?: key;
            if([identifiers[key] isKindOfClass:[NSArray class]] || [identifiers[key] isKindOfClass:[NSDictionary class]]) {
                NSError *error = nil;
                NSData *idJson = [NSJSONSerialization dataWithJSONObject:identifiers[key]
                                                                 options:0
                                                                   error:&error];
                if (error != nil) {
                    NSLog(@"Error while parsing identifier %@: %@", key, error.description);
                } else {
                    NSString *paramId = [NSString stringWithUTF8String:[idJson bytes]];
                    parameters[realKey] = [AMAFStartupParamsItemPigeon makeWithId:paramId
                                                                           status:AMAFStartupParamsItemStatusPigeonOK
                                                                     errorDetails:nil];
                }
            }
            else {
                parameters[realKey] = [AMAFStartupParamsItemPigeon makeWithId:identifiers[key]
                                                                       status:AMAFStartupParamsItemStatusPigeonOK
                                                                 errorDetails:nil];
            }
        }

        NSString *deviceId = identifiers[kAMADeviceIDKey];
        NSString *deviceIdHash = identifiers[kAMADeviceIDHashKey];
        NSString *uuid = identifiers[kAMAUUIDKey];

        AMAFStartupParamsResultPigeon *startupParamsResult = [AMAFStartupParamsResultPigeon makeWithDeviceId:deviceId
                                                                                                deviceIdHash:deviceIdHash
                                                                                                  parameters:parameters
                                                                                                        uuid:uuid];
        return [AMAFStartupParamsPigeon makeWithResult:startupParamsResult
                                                reason:nil];
    }
    else {
        AMAFStartupParamsReasonPigeon *startupParamsReason = [AMAFStartupParamsReasonPigeon makeWithValue:error.description];
        return [AMAFStartupParamsPigeon makeWithResult:nil
                                                reason:startupParamsReason];
    }
}

@end
