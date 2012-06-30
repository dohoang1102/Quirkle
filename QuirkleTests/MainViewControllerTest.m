#import "MainViewController.h"
#import "GameCenterHelper+TestSetter.h"

@interface MainViewControllerTest : SenTestCase
@end

@implementation MainViewControllerTest {
	id gameCenterHelper;
}

- (void)setUp {
	gameCenterHelper = [OCMockObject mockForClass:[GameCenterHelper class]];
	[GameCenterHelper setSharedInstance:gameCenterHelper];
}

- (void)tearDown {
	[GameCenterHelper setSharedInstance:nil];
}

- (void)testCreatesGameIfButtonTouched {
	MainViewController *mainViewController = [[MainViewController alloc] init];
	[[gameCenterHelper expect] findMatchWithMinPlayers:2 maxPlayers:4 viewController:mainViewController];

	[mainViewController createGameButtonTouched:nil];
	[gameCenterHelper verify];
}
@end