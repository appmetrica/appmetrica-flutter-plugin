
#import "AMAFAppMetricaLibraryAdapterImplementation.h"
#import "AMAFConverter.h"

@import AppMetricaLibraryAdapter;

@implementation AMAFAppMetricaLibraryAdapterImplementation

- (void)activateConfig:(AMAFAppMetricaLibraryAdapterConfigPigeon *)config
                 error:(FlutterError **)error {
    [[AMAAnalyticsLibraryAdapter sharedInstance] activateWithConfiguration:[AMAFConverter convertAppMetricaLibraryAdapterConfiguration:config]];
}

- (void)setAdvIdentifiersTrackingEnabled:(NSNumber *)enabled
                                   error:(FlutterError **)error {
    [[AMAAnalyticsLibraryAdapter sharedInstance] setAdvertisingTracking:enabled.boolValue];
}

- (void)subscribeForAutoCollectedDataApiKey:(NSString *)apiKey
                                      error:(FlutterError **)error {
    [[AMAAnalyticsLibraryAdapter sharedInstance] subscribeForAutocollectedDataForApiKey:apiKey];
}

@end
