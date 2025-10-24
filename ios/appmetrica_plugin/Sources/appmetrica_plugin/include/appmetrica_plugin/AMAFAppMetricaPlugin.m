
#import "../../AMAFAppMetricaImplementation.h"
#import "../../AMAFAppMetricaLibraryAdapterImplementation.h"
#import "../../AMAFInitialDeepLinkHolderImplementation.h"
#import "../../AMAFReporterImplementation.h"
#import "AMAFAppMetricaConfigConverterImplementation.h"
#import "AMAFAppMetricaPlugin.h"
#import "AMAFPigeon.h"

@interface AMAFAppMetricaPlugin()
@property(nonatomic, strong) AMAFInitialDeepLinkHolderImplementation *deeplinkHolder;
@end

@implementation AMAFAppMetricaPlugin

+ (instancetype)sharedInstance
{
    static AMAFAppMetricaPlugin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AMAFAppMetricaPlugin alloc] init];
    });
    return instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    AMAFAppMetricaPlugin *instance = [AMAFAppMetricaPlugin sharedInstance];
    instance.deeplinkHolder = [[AMAFInitialDeepLinkHolderImplementation alloc] init];
    [registrar addApplicationDelegate:instance];

    AMAFAppMetricaPigeonSetup(registrar.messenger, [[AMAFAppMetricaImplementation alloc] init]);
    AMAFAppMetricaLibraryAdapterPigeonSetup(registrar.messenger, [[AMAFAppMetricaLibraryAdapterImplementation alloc] init]);
    AMAFReporterPigeonSetup(registrar.messenger, [[AMAFReporterImplementation alloc] init]);
    AMAFAppMetricaConfigConverterPigeonSetup(registrar.messenger, [[AMAFAppMetricaConfigConverterImplementation alloc] init]);
    AMAFInitialDeepLinkHolderPigeonSetup(registrar.messenger, instance.deeplinkHolder);
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *url = [self extractDeeplink:launchOptions];
    [self.deeplinkHolder setInitialDeeplink:[url absoluteString]];
    return YES;
}

- (NSURL *)extractDeeplink:(NSDictionary *)launchOptions
{
    NSURL *__block openUrl = nil;
    if ([launchOptions[UIApplicationLaunchOptionsURLKey] isKindOfClass:NSURL.class]) {
        openUrl = launchOptions[UIApplicationLaunchOptionsURLKey];
    }
    if (openUrl.absoluteString.length == 0) {
        if ([launchOptions[UIApplicationLaunchOptionsUserActivityDictionaryKey] isKindOfClass:NSDictionary.class]) {
            NSDictionary *userActivity = launchOptions[UIApplicationLaunchOptionsUserActivityDictionaryKey];
            [userActivity enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
                if ([value isKindOfClass:NSUserActivity.class]) {
                    NSUserActivity *activity = value;
                    openUrl = activity.webpageURL;
                    *stop = YES;
                }
            }];
        }
    }
    return openUrl;
}

@end
