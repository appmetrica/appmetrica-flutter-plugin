
#import "../../AMAFConverter.h"
#import "../../AMAFPigeon+Mapping.h"
#import "AMAFAppMetricaConfigConverterImplementation.h"

@implementation AMAFAppMetricaConfigConverterImplementation

- (NSString *)toJsonConfig:(AMAFAppMetricaConfigPigeon *)config error:(FlutterError **)flutterError
{
    return [AMAFAppMetricaConfigConverterImplementation appMetricaConfigToJson:config];
}

+ (NSString *)appMetricaConfigToJson:(AMAFAppMetricaConfigPigeon *)pigeon
{
    NSDictionary *configMap = [pigeon toMap];
    NSError *jsonError = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:configMap options:0 error:&jsonError];
    if (jsonError == nil && json != nil) {
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+ (AMAAppMetricaConfiguration *)appMetricaConfigFromJson:(NSString *)json
{
    if (json != nil) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:0
                                                               error:&error];
        if (error == nil && dict != nil && [dict isKindOfClass:[NSDictionary class]]) {
            AMAFAppMetricaConfigPigeon *pigeon = [AMAFAppMetricaConfigPigeon fromMap:dict];
            return [AMAFConverter convertAppMetricaConfiguration:pigeon];
        }
    }
    return nil;
}

@end
