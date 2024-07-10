
#import "AMAFPigeon+Mapping.h"

@implementation AMAFAppMetricaConfigPigeon (Mapping)

+ (AMAFAppMetricaConfigPigeon *)fromMap:(NSDictionary *)dict
{
    if (dict == nil) {
        return nil;
    }
    AMAFAppMetricaConfigPigeon *pigeonResult = [[AMAFAppMetricaConfigPigeon alloc] init];
    pigeonResult.apiKey = [AMAPigeonUtils getNullableObject:dict key:@"apiKey"];
    NSAssert(pigeonResult.apiKey != nil, @"");
    
    pigeonResult.appVersion = [AMAPigeonUtils getNullableObject:dict key:@"appVersion"];
    pigeonResult.crashReporting = [AMAPigeonUtils getNullableObject:dict key:@"crashReporting"];
    pigeonResult.firstActivationAsUpdate = [AMAPigeonUtils getNullableObject:dict key:@"firstActivationAsUpdate"];
    pigeonResult.location = [AMAFLocationPigeon fromMap:[AMAPigeonUtils getNullableObject:dict key:@"location"]];
    pigeonResult.locationTracking = [AMAPigeonUtils getNullableObject:dict key:@"locationTracking"];
    pigeonResult.logs = [AMAPigeonUtils getNullableObject:dict key:@"logs"];
    pigeonResult.sessionTimeout = [AMAPigeonUtils getNullableObject:dict key:@"sessionTimeout"];
    pigeonResult.dataSendingEnabled = [AMAPigeonUtils getNullableObject:dict key:@"statisticsSending"];
    pigeonResult.preloadInfo = [AMAFPreloadInfoPigeon fromMap:[AMAPigeonUtils getNullableObject:dict key:@"preloadInfo"]];
    pigeonResult.maxReportsInDatabaseCount = [AMAPigeonUtils getNullableObject:dict key:@"maxReportsInDatabaseCount"];
    pigeonResult.nativeCrashReporting = [AMAPigeonUtils getNullableObject:dict key:@"nativeCrashReporting"];
    pigeonResult.sessionsAutoTrackingEnabled = [AMAPigeonUtils getNullableObject:dict key:@"sessionsAutoTracking"];
    pigeonResult.errorEnvironment = [AMAPigeonUtils getNullableObject:dict key:@"errorEnvironment"];
    pigeonResult.userProfileID = [AMAPigeonUtils getNullableObject:dict key:@"userProfileID"];
    pigeonResult.revenueAutoTrackingEnabled = [AMAPigeonUtils getNullableObject:dict key:@"revenueAutoTracking"];
    pigeonResult.appOpenTrackingEnabled = [AMAPigeonUtils getNullableObject:dict key:@"appOpenTrackingEnabled"];
    return pigeonResult;
}

- (NSDictionary *)toMap
{
    return @{
        @"apiKey" : (self.apiKey ?: [NSNull null]),
        @"appVersion" : (self.appVersion ?: [NSNull null]),
        @"crashReporting" : (self.crashReporting ?: [NSNull null]),
        @"firstActivationAsUpdate" : (self.firstActivationAsUpdate ?: [NSNull null]),
        @"location" : (self.location ? [self.location toMap] : [NSNull null]),
        @"locationTracking" : (self.locationTracking ?: [NSNull null]),
        @"logs" : (self.logs ?: [NSNull null]),
        @"sessionTimeout" : (self.sessionTimeout ?: [NSNull null]),
        @"statisticsSending" : (self.dataSendingEnabled ?: [NSNull null]),
        @"preloadInfo" : (self.preloadInfo ? [self.preloadInfo toMap] : [NSNull null]),
        @"maxReportsInDatabaseCount" : (self.maxReportsInDatabaseCount ?: [NSNull null]),
        @"nativeCrashReporting" : (self.nativeCrashReporting ?: [NSNull null]),
        @"sessionsAutoTracking" : (self.sessionsAutoTrackingEnabled ?: [NSNull null]),
        @"errorEnvironment" : (self.errorEnvironment ?: [NSNull null]),
        @"userProfileID" : (self.userProfileID ?: [NSNull null]),
        @"revenueAutoTracking" : (self.revenueAutoTrackingEnabled ?: [NSNull null]),
        @"appOpenTrackingEnabled" : (self.appOpenTrackingEnabled ?: [NSNull null]),
    };
}

@end

@implementation AMAFLocationPigeon (Mapping)

+ (AMAFLocationPigeon *)fromMap:(NSDictionary *)dict
{
    if (dict == nil) {
        return nil;
    }
    AMAFLocationPigeon *pigeonResult = [[AMAFLocationPigeon alloc] init];
    pigeonResult.latitude = [AMAPigeonUtils getNullableObject:dict key:@"latitude"];
    NSAssert(pigeonResult.latitude != nil, @"");
    pigeonResult.longitude = [AMAPigeonUtils getNullableObject:dict key:@"longitude"];
    NSAssert(pigeonResult.longitude != nil, @"");
    pigeonResult.provider = [AMAPigeonUtils getNullableObject:dict key:@"provider"];
    pigeonResult.altitude = [AMAPigeonUtils getNullableObject:dict key:@"altitude"];
    pigeonResult.accuracy = [AMAPigeonUtils getNullableObject:dict key:@"accuracy"];
    pigeonResult.course = [AMAPigeonUtils getNullableObject:dict key:@"course"];
    pigeonResult.speed = [AMAPigeonUtils getNullableObject:dict key:@"speed"];
    pigeonResult.timestamp = [AMAPigeonUtils getNullableObject:dict key:@"timestamp"];
    return pigeonResult;
}

- (NSDictionary *)toMap
{
    return @{
        @"latitude" : (self.latitude ?: [NSNull null]),
        @"longitude" : (self.longitude ?: [NSNull null]),
        @"provider" : (self.provider ?: [NSNull null]),
        @"altitude" : (self.altitude ?: [NSNull null]),
        @"accuracy" : (self.accuracy ?: [NSNull null]),
        @"course" : (self.course ?: [NSNull null]),
        @"speed" : (self.speed ?: [NSNull null]),
        @"timestamp" : (self.timestamp ?: [NSNull null]),
    };
}

@end

@implementation AMAFPreloadInfoPigeon (Mapping)

+ (AMAFPreloadInfoPigeon *)fromMap:(NSDictionary *)dict
{
    if (dict == nil) {
        return nil;
    }
    AMAFPreloadInfoPigeon *pigeonResult = [[AMAFPreloadInfoPigeon alloc] init];
    pigeonResult.trackingId = [AMAPigeonUtils getNullableObject:dict key:@"trackingId"];
    NSAssert(pigeonResult.trackingId != nil, @"");
    pigeonResult.additionalInfo = [AMAPigeonUtils getNullableObject:dict key:@"additionalInfo"];
    return pigeonResult;
}

- (NSDictionary *)toMap
{
    return @{
        @"trackingId" : (self.trackingId ?: [NSNull null]),
        @"additionalInfo" : (self.additionalInfo ?: [NSNull null]),
    };
}

@end

@implementation AMAPigeonUtils

+ (id)getNullableObject:(NSDictionary *)dict key:(id)key
{
    id result = dict[key];
    return (result == [NSNull null]) ? nil : result;
}

@end
