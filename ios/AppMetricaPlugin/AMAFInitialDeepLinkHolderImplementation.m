
#import "AMAFInitialDeepLinkHolderImplementation.h"

@interface AMAFInitialDeepLinkHolderImplementation()
@property(nonatomic, copy) NSString *deeplink;
@end

@implementation AMAFInitialDeepLinkHolderImplementation

- (void)setInitialDeeplink:(NSString *)deeplink
{
    self.deeplink = [deeplink copy];
}

- (NSString *)getInitialDeeplinkWithError:(FlutterError **)flutterError
{
    return self.deeplink;
}

@end
