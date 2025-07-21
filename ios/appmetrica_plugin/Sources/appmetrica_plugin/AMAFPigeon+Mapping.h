
#import <Foundation/Foundation.h>
#import "include/appmetrica_plugin/AMAFPigeon.h"

@interface AMAFAppMetricaConfigPigeon (Mapping)

+ (AMAFAppMetricaConfigPigeon *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;

@end

@interface AMAFLocationPigeon (Mapping)

+ (AMAFLocationPigeon *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;

@end

@interface AMAFPreloadInfoPigeon (Mapping)

+ (AMAFPreloadInfoPigeon *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;

@end

@interface AMAPigeonUtils : NSObject

+ (id)getNullableObject:(NSDictionary *)dict key:(id)key;

@end
