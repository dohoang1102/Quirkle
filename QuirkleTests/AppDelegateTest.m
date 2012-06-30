#import "AppDelegate.h"
#import "GameCenterHelper.h"
#import "GameCenterHelper+TestSetter.h"

@interface AppDelegateTest : SenTestCase
@end

@implementation AppDelegateTest {
	AppDelegate *appDelegate;
	id gameCenterHelper;
}

- (void)setUp {
	gameCenterHelper = [OCMockObject mockForClass:[GameCenterHelper class]];
	[GameCenterHelper setSharedInstance:gameCenterHelper];
	appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)tearDown {
	[GameCenterHelper setSharedInstance:nil];
}

- (void)testAuthenticatesLocalPlayerAtStart {
	[[gameCenterHelper expect] authenticateLocalPlayer];
	[appDelegate application:nil didFinishLaunchingWithOptions:nil];
	[gameCenterHelper verify];
}

@end