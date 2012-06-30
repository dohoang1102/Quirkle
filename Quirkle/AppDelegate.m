#import "AppDelegate.h"
#import "GameCenterHelper.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[GameCenterHelper sharedInstance] authenticateLocalPlayer];
	return YES;
}

@end
