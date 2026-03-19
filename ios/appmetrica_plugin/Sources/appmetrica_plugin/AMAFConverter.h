
#import "include/appmetrica_plugin/AMAFPigeon.h"

@class AMAAdRevenueInfo;
@class AMAAnalyticsLibraryAdapterConfiguration;
@class AMAAppMetricaConfiguration;
@class AMAAppMetricaCrashesConfiguration;
@class AMAECommerce;
@class AMAPluginErrorDetails;
@class AMAReporterConfiguration;
@class AMARevenueInfo;
@class AMAStackTraceElement;
@class AMAUserProfile;
@class CLLocation;

@interface AMAFConverter : NSObject

// region to native
+ (AMAAdRevenueInfo *)convertAdRevenue:(AMAFAdRevenuePigeon *)pigeon;

+ (AMAAnalyticsLibraryAdapterConfiguration *)convertAppMetricaLibraryAdapterConfiguration:(AMAFAppMetricaLibraryAdapterConfigPigeon *)pigeon;

+ (AMAReporterConfiguration *)convertReporterConfiguration:(AMAFReporterConfigPigeon *)pigeon;

+ (AMAAppMetricaConfiguration *)convertAppMetricaConfiguration:(AMAFAppMetricaConfigPigeon *)pigeon;

+ (AMAAppMetricaCrashesConfiguration *)convertCrashesConfiguration:(AMAFAppMetricaConfigPigeon *)pigeon;

+ (AMAECommerce *)convertECommerce:(AMAFECommerceEventPigeon *)pigeon;

+ (CLLocation *)convertLocation:(AMAFLocationPigeon *)pigeon;

+ (AMAPluginErrorDetails *)convertPluginErrorDetails:(AMAFErrorDetailsPigeon *)errorPigeon;

+ (NSArray<AMAStackTraceElement *> *)convertStackTraceElements:(NSArray<AMAFStackTraceElementPigeon *> *)backtracePigeon;

+ (AMAUserProfile *)convertUserProfile:(AMAFUserProfilePigeon *)userProfile;

+ (AMARevenueInfo *)convertRevenueInfo:(AMAFRevenuePigeon *)pigeon;

+ (NSArray<NSString *> *)convertStartupIdentifiersKeys:(NSArray<NSString *> *)pigeon;
// endregion

// region to pigeon
+ (AMAFStartupParamsPigeon *) convertToPigeonIdentifiers:(NSDictionary *)identifiers
                                               withError:(NSError *)error;
// endregion

@end
