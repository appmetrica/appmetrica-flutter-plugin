
#import "AMAFAppMetricaImplementation.h"
#import "AMAFConverter.h"
#import "include/appmetrica_plugin/AMAFAppMetricaActivator.h"
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCrashes/AppMetricaCrashes.h>

@implementation AMAFAppMetricaImplementation

- (void)activateConfig:(AMAFAppMetricaConfigPigeon *)config error:(FlutterError **)flutterError
{
    AMAAppMetricaCrashesConfiguration *crashesConfiguration = [AMAFConverter convertCrashesConfiguration:config];
    [[AMAAppMetricaCrashes crashes] setConfiguration:crashesConfiguration];
    [[AMAFAppMetricaActivator sharedInstance] activateWithConfig:[AMAFConverter convertAppMetricaConfiguration:config]];
}

- (void)activateReporterConfig:(AMAFReporterConfigPigeon *)config error:(FlutterError **)flutterError
{
    [AMAAppMetrica activateReporterWithConfiguration:[AMAFConverter convertReporterConfiguration:config]];
}

- (void)clearAppEnvironmentWithError:(FlutterError **)error
{
    [AMAAppMetrica clearAppEnvironment];
}

- (void)enableActivityAutoTrackingWithError:(FlutterError **)error
{
    // ?
}

- (NSString *)getDeviceIdWithError:(FlutterError **)error
{
    return [AMAAppMetrica deviceID];
}

- (NSNumber *)getLibraryApiLevelWithError:(FlutterError **)flutterError
{
    return nil;
}

- (NSString *)getLibraryVersionWithError:(FlutterError **)flutterError
{
    return [AMAAppMetrica libraryVersion];
}

- (NSString *)getUuidWithError:(FlutterError **)error
{
    return [AMAAppMetrica UUID];
}

- (void)pauseSessionWithError:(FlutterError **)flutterError
{
    [AMAAppMetrica pauseSession];
}

- (void)putAppEnvironmentValueKey:(NSString *)key
                            value:(NSString *)value
                            error:(FlutterError **)error
{
    [AMAAppMetrica setAppEnvironmentValue:value forKey:key];
}

- (void)putErrorEnvironmentValueKey:(NSString *)key value:(NSString *)value error:(FlutterError **)flutterError
{
    [[AMAAppMetricaCrashes crashes] setErrorEnvironmentValue:value
                                                      forKey:key];
}

- (void)reportAdRevenueAdRevenue:(AMAFAdRevenuePigeon *)adRevenue error:(FlutterError **)flutterError
{
    [AMAAppMetrica reportAdRevenue:[AMAFConverter convertAdRevenue:adRevenue]
                         onFailure:nil];
}

- (void)reportAppOpenDeeplink:(NSString *)deeplink error:(FlutterError **)flutterError
{
    [AMAAppMetrica trackOpeningURL:[NSURL URLWithString:deeplink]];
}

- (void)reportECommerceEvent:(AMAFECommerceEventPigeon *)event error:(FlutterError **)flutterError
{
    [AMAAppMetrica reportECommerce:[AMAFConverter convertECommerce:event]
                         onFailure:nil];
}

- (void)reportErrorError:(AMAFErrorDetailsPigeon *)error message:(NSString *)message error:(FlutterError **)flutterError
{
    [[[AMAAppMetricaCrashes crashes] pluginExtension] reportError:[AMAFConverter convertPluginErrorDetails:error]
                                                          message:message
                                                        onFailure:nil];
}

- (void)reportErrorWithGroupGroupId:(NSString *)groupId error:(AMAFErrorDetailsPigeon *)error message:(NSString *)message error:(FlutterError **)flutterError
{
    [[[AMAAppMetricaCrashes crashes] pluginExtension] reportErrorWithIdentifier:groupId
                                                                        message:message
                                                                        details:[AMAFConverter convertPluginErrorDetails:error]
                                                                      onFailure:nil];
}

- (void)reportEventEventName:(NSString *)eventName error:(FlutterError **)flutterError
{
    [AMAAppMetrica reportEvent:eventName
                     onFailure:nil];
}

- (void)reportEventWithJsonEventName:(NSString *)eventName attributesJson:(NSString *)attributesJson error:(FlutterError **)flutterError
{
    NSDictionary *attributes = nil;
    NSError *error = nil;
    if (attributesJson != nil) {
        attributes = [NSJSONSerialization JSONObjectWithData:[attributesJson dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:kNilOptions
                                                       error:&error];
    }
    if (error == nil && (attributes == nil || [attributes isKindOfClass:[NSDictionary class]])) {
        [AMAAppMetrica reportEvent:eventName
                        parameters:attributes
                         onFailure:nil];
    }
    else {
        NSLog(@"Invalid attributesJson to report to AppMetrica %@", attributesJson);
    }
}

- (void)reportReferralUrlReferralUrl:(NSString *)referralUrl error:(FlutterError **)flutterError
{
    // METRIKALIB-9368: Removed
}

- (void)reportRevenueRevenue:(AMAFRevenuePigeon *)revenue error:(FlutterError **)flutterError
{
    [AMAAppMetrica reportRevenue:[AMAFConverter convertRevenueInfo:revenue]
                       onFailure:nil];
}

- (void)reportUnhandledExceptionError:(AMAFErrorDetailsPigeon *)error error:(FlutterError **)flutterError
{
    [[[AMAAppMetricaCrashes crashes] pluginExtension] reportUnhandledException:[AMAFConverter convertPluginErrorDetails:error]
                                                                     onFailure:nil];
}

- (void)reportUserProfileUserProfile:(AMAFUserProfilePigeon *)userProfile error:(FlutterError **)error
{
    [AMAAppMetrica reportUserProfile:[AMAFConverter convertUserProfile:userProfile] onFailure:nil];
}

- (void)requestDeferredDeeplinkWithCompletion:(void(^)(AMAFAppMetricaDeferredDeeplinkPigeon *, FlutterError *))flutterCompletion
{
    AMAFAppMetricaDeferredDeeplinkErrorPigeon *error = [AMAFAppMetricaDeferredDeeplinkErrorPigeon makeWithReason:AMAFAppMetricaDeferredDeeplinkReasonPigeonUNKNOWN
                                                                                                errorDescription:@""
                                                                                                         message:nil];
    flutterCompletion([AMAFAppMetricaDeferredDeeplinkPigeon makeWithDeeplink:nil
                                                                       error:error], nil);
}

- (void)requestDeferredDeeplinkParametersWithCompletion:(void(^)(AMAFAppMetricaDeferredDeeplinkParametersPigeon *, FlutterError *))flutterCompletion
{
    AMAFAppMetricaDeferredDeeplinkErrorPigeon *error = [AMAFAppMetricaDeferredDeeplinkErrorPigeon makeWithReason:AMAFAppMetricaDeferredDeeplinkReasonPigeonUNKNOWN
                                                                                                errorDescription:@""
                                                                                                         message:nil];
    flutterCompletion([AMAFAppMetricaDeferredDeeplinkParametersPigeon makeWithParameters:nil
                                                                                   error:error], nil);
}

- (void)requestStartupParamsParams:(NSArray<NSString *> *)params
                        completion:(void (^)(AMAFStartupParamsPigeon *, FlutterError *))flutterCompletion
{
    [AMAAppMetrica requestStartupIdentifiersWithKeys:[AMAFConverter convertStartupIdentifiersKeys:params]
                                     completionQueue:nil
                                     completionBlock:^(NSDictionary<AMAStartupKey,id> * identifiers, NSError * error) {
        flutterCompletion([AMAFConverter convertToPigeonIdentifiers:identifiers
                                                          withError:error], nil);
    }];
}

- (void)resumeSessionWithError:(FlutterError **)flutterError
{
    [AMAAppMetrica resumeSession];
}

- (void)sendEventsBufferWithError:(FlutterError **)flutterError
{
    [AMAAppMetrica sendEventsBuffer];
}

- (void)setAdvIdentifiersTrackingEnabled:(NSNumber *)enabled error:(FlutterError **)flutterError
{
    [AMAAppMetrica setAdvertisingIdentifierTrackingEnabled:enabled.boolValue];
}

- (void)setDataSendingEnabledEnabled:(NSNumber *)enabled error:(FlutterError **)error
{
    [AMAAppMetrica setDataSendingEnabled:enabled.boolValue];
}

- (void)setLocationLocation:(AMAFLocationPigeon *)location error:(FlutterError **)flutterError
{
    [AMAAppMetrica setCustomLocation:[AMAFConverter convertLocation:location]];
}

- (void)setLocationTrackingEnabled:(NSNumber *)enabled error:(FlutterError **)flutterError
{
    [AMAAppMetrica setLocationTrackingEnabled:enabled.boolValue];
}

- (void)setUserProfileIDUserProfileID:(NSString *)userProfileID error:(FlutterError **)flutterError
{
    [AMAAppMetrica setUserProfileID:userProfileID];
}

- (void)handlePluginInitFinishedWithError:(FlutterError **)flutterError
{
    [[[AMAAppMetricaCrashes crashes] pluginExtension] handlePluginInitFinished];
}

- (void)touchReporterApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [AMAAppMetrica reporterForAPIKey:apiKey];
}

- (void)reportExternalAttributionExternalAttributionPigeon:(AMAFExternalAttributionPigeon *)externalAttributionPigeon error:(FlutterError **)error {
    [AMAAppMetrica reportExternalAttribution:externalAttributionPigeon.data
                                      source:externalAttributionPigeon.source
                                   onFailure:nil];
}

@end
