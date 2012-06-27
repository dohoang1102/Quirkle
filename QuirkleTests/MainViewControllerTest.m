#import <GameKit/GameKit.h>
#import "MainViewController.h"

@interface MainViewControllerTest : SenTestCase
@end

@implementation MainViewControllerTest {
}

- (void)testAuthenticatesLocalPlayer {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
	MainViewController *mainViewController = [storyboard instantiateInitialViewController];
	id playerMock = [OCMockObject mockForClass:[GKLocalPlayer class]];
	[[playerMock expect] authenticateWithCompletionHandler:OCMOCK_ANY];
	mainViewController.localPlayer = playerMock;
	[mainViewController viewDidLoad];
	[playerMock verify];
}

@end