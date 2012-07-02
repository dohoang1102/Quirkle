#import "MainViewController.h"
#import "GameCenterHelper+TestSetter.h"
#import "Game.h"

@interface MainViewControllerTest : SenTestCase
@end

@implementation MainViewControllerTest {
	id gameCenterHelper;
	MainViewController *mainViewController;
}

- (void)setUp {
	gameCenterHelper = [OCMockObject niceMockForClass:[GameCenterHelper class]];
	[GameCenterHelper setSharedInstance:gameCenterHelper];
	mainViewController = [[MainViewController alloc] init];
	[mainViewController viewDidLoad];
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

- (void)testInitializesNewGame {
	id match = [OCMockObject niceMockForClass:[GKTurnBasedMatch class]];
	[[[match stub] andReturn:@"foo"] matchID];
	[mainViewController startNewGameForMatch:match];
	expect([[mainViewController currentGames] objectForKey:@"foo"]).Not.toBeNil();
}

@end