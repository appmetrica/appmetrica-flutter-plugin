
#import "AMAFAppMetricaLibraryAdapterImplementation.h"

@import AppMetricaLibraryAdapter;

@implementation AMAFAppMetricaLibraryAdapterImplementation

- (void)subscribeForAutoCollectedDataApiKey:(NSString *)apiKey
                                      error:(FlutterError **)error {
    [[AMAAnalyticsLibraryAdapter sharedInstance] subscribeForAutocollectedDataForApiKey:apiKey];
}

@end
