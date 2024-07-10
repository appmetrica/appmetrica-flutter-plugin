
#import "AMAFPigeon.h"

@class AMAAppMetricaConfiguration;

@interface AMAFAppMetricaConfigConverterImplementation : NSObject <AMAFAppMetricaConfigConverterPigeon>

+ (AMAAppMetricaConfiguration *)appMetricaConfigFromJson:(NSString *)json;

@end
