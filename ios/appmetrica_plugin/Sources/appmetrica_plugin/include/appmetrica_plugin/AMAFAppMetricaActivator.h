
#import <Foundation/Foundation.h>

@class AMAFAppMetricaConfigPigeon;
@class AMAAppMetricaConfiguration;

@interface AMAFAppMetricaActivator : NSObject

// do not rename, used in push flutter plugin
- (void)activateWithConfig:(AMAAppMetricaConfiguration *)config;
// do not rename, used in push flutter plugin
- (BOOL)isAlreadyActivated;

+ (instancetype)sharedInstance;

@end
