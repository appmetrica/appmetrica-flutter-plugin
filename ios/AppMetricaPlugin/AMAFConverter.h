
#import "AMAFPigeon.h"

@class AMAAdRevenueInfo;
@class AMAAppMetricaConfiguration;
@class AMAAppMetricaCrashesConfiguration;
@class AMAReporterConfiguration;
@class AMAECommerce;
@class CLLocation;
@class AMAPluginErrorDetails;
@class AMAStackTraceElement;
@class AMAUserProfile;
@class AMARevenueInfo;

@interface AMAFConverter : NSObject

// region to native
+ (AMAAdRevenueInfo *)convertAdRevenue:(AMAFAdRevenuePigeon *)pigeon;

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
