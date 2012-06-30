#import "GameCenterHelper.h"

@interface GameCenterHelperTest : SenTestCase
@end

@implementation GameCenterHelperTest {
	GameCenterHelper *gameCenterHelper;
}

- (void)setUp {
	gameCenterHelper = [[GameCenterHelper alloc] init];
}

- (void)testPresentsGameCenterViewControllerForMatchMaking {
	id viewController = [OCMockObject mockForClass:[UIViewController class]];
	[[viewController expect] presentModalViewController:OCMOCK_ANY animated:YES];

	[gameCenterHelper findMatchWithMinPlayers:2 maxPlayers:4 viewController:viewController];
	[viewController verify];
}

- (void)testSavesPresentingViewController {
	UIViewController *viewController = [[UIViewController alloc] init];
	[gameCenterHelper findMatchWithMinPlayers:2 maxPlayers:4 viewController:viewController];
	expect(gameCenterHelper.presentingViewController).toEqual(viewController);
}

- (void)testDismissesViewControllerOnDidFindMatch {
	id viewController = [OCMockObject mockForClass:[UIViewController class]];
	[[viewController expect] dismissModalViewControllerAnimated:YES];
	gameCenterHelper.presentingViewController = viewController;
	[gameCenterHelper turnBasedMatchmakerViewController:nil didFindMatch:nil];
	[viewController verify];
}

- (void)testDismissesViewControllerOnWasCancelled {
	id viewController = [OCMockObject mockForClass:[UIViewController class]];
	[[viewController expect] dismissModalViewControllerAnimated:YES];
	gameCenterHelper.presentingViewController = viewController;
	[gameCenterHelper turnBasedMatchmakerViewControllerWasCancelled:nil];
	[viewController verify];
}

- (void)testDismissesViewControllerOnDidFailWithError {
	id viewController = [OCMockObject mockForClass:[UIViewController class]];
	[[viewController expect] dismissModalViewControllerAnimated:YES];
	gameCenterHelper.presentingViewController = viewController;
	[gameCenterHelper turnBasedMatchmakerViewController:nil didFailWithError:nil];
	[viewController verify];
}

@end