
#import "AMAFAppMetricaLibraryAdapterImplementation.h"

@import AppMetricaLibraryAdapter;

@implementation AMAFAppMetricaLibraryAdapterImplementation

- (void)subscribeForAutoCollectedDataApiKey:(NSString *)apiKey
                                      error:(FlutterError **)error {
    [[AMAAppMetricaLibraryAdapter sharedInstance] subscribeForAutocollectedDataForApiKey:apiKey];
}

@end
