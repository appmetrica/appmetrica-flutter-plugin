
#import "AMAFAppMetricaActivator.h"
#import <AppMetricaCore/AppMetricaCore.h>

@interface AMAFAppMetricaActivator ()

@property(nonatomic, assign) BOOL isActivated;

@end

@implementation AMAFAppMetricaActivator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isActivated = NO;
    }

    return self;
}


- (void)activateWithConfig:(AMAAppMetricaConfiguration *)config
{
    @synchronized (self) {
        [AMAAppMetrica activateWithConfiguration:config];
        self.isActivated = YES;
    }
}

- (BOOL)isAlreadyActivated
{
    @synchronized (self) {
        return self.isActivated;
    }
}


+ (instancetype)sharedInstance
{
    static AMAFAppMetricaActivator *activator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activator = [[AMAFAppMetricaActivator alloc] init];
    });
    return activator;
}

@end
