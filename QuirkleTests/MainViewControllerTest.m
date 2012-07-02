#import "MainViewController.h"
#import "GameCenterHelper+TestSetter.h"

@interface MainViewControllerTest : SenTestCase
@end

@implementation MainViewControllerTest {
	id gameCenterHelper;
	MainViewController *mainViewController;
}

- (void)setUp {
	gameCenterHelper = [OCMockObject mockForClass:[GameCenterHelper class]];
	[GameCenterHelper setSharedInstance:gameCenterHelper];
	mainViewController = [[MainViewController alloc] init];
}

- (void)tearDown {
	[GameCenterHelper setSharedInstance:nil];
}

- (void)testSetsSelfAsDelegateOfGameCenterHelper {
	[[gameCenterHelper expect] setDelegate:mainViewController];
	[mainViewController viewDidLoad];
	[gameCenterHelper verify];
}

- (void)testCreatesGameIfButtonTouched {
	[[gameCenterHelper expect] findMatchWithMinPlayers:2 maxPlayers:4 viewController:mainViewController];
	[mainViewController createGameButtonTouched:nil];
	[gameCenterHelper verify];
}

- (void)testSendsTurnToMatchOnTakeTurn {
	id match = [OCMockObject mockForClass:[GKTurnBasedMatch class]];
	[[[gameCenterHelper stub] andReturn:match] currentMatch];
	[[gameCenterHelper expect] nextActiveParticipantInMatch:match];
	[[match expect] endTurnWithNextParticipant:OCMOCK_ANY matchData:OCMOCK_ANY completionHandler:OCMOCK_ANY];

	[mainViewController takeTurnButtonTouched:nil];
	[match verify];
	[gameCenterHelper verify];
}

@end