
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCrashes/AppMetricaCrashes.h>
#import "AMAFReporterImplementation.h"
#import "AMAFConverter.h"

@implementation AMAFReporterImplementation

- (void)clearAppEnvironmentApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] clearAppEnvironment];
}

- (void)pauseSessionApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] pauseSession];
}

- (void)putAppEnvironmentValueApiKey:(NSString *)apiKey key:(NSString *)key value:(NSString *)value error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] setAppEnvironmentValue:value
                                                              forKey:key];
}

- (void)reportAdRevenueApiKey:(NSString *)apiKey adRevenue:(AMAFAdRevenuePigeon *)adRevenue error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] reportAdRevenue:[AMAFConverter convertAdRevenue:adRevenue] onFailure:nil];
}

- (void)reportECommerceApiKey:(NSString *)apiKey event:(AMAFECommerceEventPigeon *)event error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] reportECommerce:[AMAFConverter convertECommerce:event] onFailure:nil];
}

- (void)reportErrorApiKey:(NSString *)apiKey
                    error:(AMAFErrorDetailsPigeon *)error
                  message:(nullable NSString *)message
                    error:(FlutterError **)flutterError
{
    [[[[AMAAppMetricaCrashes crashes] reporterForAPIKey:apiKey] pluginExtension] reportError:[AMAFConverter convertPluginErrorDetails:error]
                                                                                     message:message
                                                                                   onFailure:nil];
}

- (void)reportErrorWithGroupApiKey:(NSString *)apiKey
                           groupId:(NSString *)groupId
                             error:(nullable AMAFErrorDetailsPigeon *)error
                           message:(nullable NSString *)message
                             error:(FlutterError **)flutterError
{
    [[[[AMAAppMetricaCrashes crashes] reporterForAPIKey:apiKey] pluginExtension] reportErrorWithIdentifier:groupId
                                                                                                   message:message
                                                                                                   details:[AMAFConverter convertPluginErrorDetails:error]
                                                                                                 onFailure:nil];
}

- (void)reportEventApiKey:(NSString *)apiKey eventName:(NSString *)eventName error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] reportEvent:eventName onFailure:nil];
}

- (void)reportEventWithJsonApiKey:(NSString *)apiKey
                        eventName:(NSString *)eventName
                   attributesJson:(nullable NSString *)attributesJson
                            error:(FlutterError **)flutterError
{
    NSDictionary *attributes = nil;
    NSError *jsonValidationError = nil;
    if (attributesJson != nil) {
        attributes = [NSJSONSerialization JSONObjectWithData:[attributesJson dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:kNilOptions
                                                       error:&jsonValidationError];
    }
    if (jsonValidationError == nil && (attributes == nil || [attributes isKindOfClass:[NSDictionary class]])) {
        [[AMAAppMetrica reporterForAPIKey:apiKey] reportEvent:eventName
                                                   parameters:attributes
                                                    onFailure:nil];
    }
    else {
        NSLog(@"Invalid attributesJson to report to AppMetrica %@", attributesJson);
    }
}

- (void)reportRevenueApiKey:(NSString *)apiKey revenue:(AMAFRevenuePigeon *)revenue error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] reportRevenue:[AMAFConverter convertRevenueInfo:revenue] onFailure:nil];
}

- (void)reportUnhandledExceptionApiKey:(NSString *)apiKey
                                 error:(AMAFErrorDetailsPigeon *)error
                                 error:(FlutterError **)flutterError
{
    [[[[AMAAppMetricaCrashes crashes] reporterForAPIKey:apiKey] pluginExtension] reportUnhandledException:[AMAFConverter convertPluginErrorDetails:error]
                                                                                                onFailure:nil];
}

- (void)reportUserProfileApiKey:(NSString *)apiKey
                    userProfile:(AMAFUserProfilePigeon *)userProfile
                          error:(FlutterError **)flutterError {
    [[AMAAppMetrica reporterForAPIKey:apiKey] reportUserProfile:[AMAFConverter convertUserProfile:userProfile] onFailure:nil];
}

- (void)resumeSessionApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] resumeSession];
}

- (void)sendEventsBufferApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] sendEventsBuffer];
}

- (void)setDataSendingEnabledApiKey:(NSString *)apiKey enabled:(NSNumber *)enabled error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] setDataSendingEnabled:enabled.boolValue];
}

- (void)setUserProfileIDApiKey:(NSString *)apiKey
                 userProfileID:(nullable NSString *)userProfileID
                         error:(FlutterError **)flutterError
{
    [[AMAAppMetrica reporterForAPIKey:apiKey] setUserProfileID:userProfileID];
}

@end
