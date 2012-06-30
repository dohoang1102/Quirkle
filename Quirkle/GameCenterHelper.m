#import <GameKit/GameKit.h>
#import "GameCenterHelper.h"
#import "Game.h"

static GameCenterHelper *_sharedInstance;

@implementation GameCenterHelper {
	BOOL _userAuthenticated;
	UIViewController *_presentingViewController;
	GKTurnBasedMatch *_currentMatch;
	__weak id _delegate;
}
@synthesize currentMatch = _currentMatch;
@synthesize presentingViewController = _presentingViewController;
@synthesize delegate = _delegate;


+ (GameCenterHelper *)sharedInstance {
	if (_sharedInstance == nil) {
		_sharedInstance = [[GameCenterHelper alloc] init];
	}
	return _sharedInstance;
}

+ (void)setSharedInstance:(GameCenterHelper *)instance {
	_sharedInstance = instance;
}

- (id)init {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(authenticationChanged)
				                                     name:GKPlayerAuthenticationDidChangeNotificationName
					                               object:nil];
	}
	return self;
}

- (void)authenticationChanged {
	if ([[GKLocalPlayer localPlayer] isAuthenticated] && !_userAuthenticated) {
		NSLog(@"Authentication changed: player authenticated");
		_userAuthenticated = YES;
	} else if (![[GKLocalPlayer localPlayer] isAuthenticated] && _userAuthenticated) {
		NSLog(@"Authentication changed: player not authenticated");
		_userAuthenticated = NO;
	}
}

- (void)authenticateLocalPlayer {
	if ([[GKLocalPlayer localPlayer] isAuthenticated] == NO) {
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
			[GKTurnBasedEventHandler sharedTurnBasedEventHandler].delegate = self;
		}];
	}
}

- (void)findMatchWithMinPlayers:(NSUInteger)minPlayers maxPlayers:(NSUInteger)maxPlayers viewController:(UIViewController *)viewController {
	_presentingViewController = viewController;
	GKTurnBasedMatchmakerViewController *matchmakerViewController = [self matchMakerViewControllerForMinPlayers:minPlayers
	                                                                                                 maxPlayers:maxPlayers
			                                                                                    playersToInvite:nil
						                                                                    showExistingMatches:YES];
	[_presentingViewController presentModalViewController:matchmakerViewController animated:YES];
}

- (GKTurnBasedMatchmakerViewController *)matchMakerViewControllerForMinPlayers:(NSUInteger)minPlayers maxPlayers:(NSUInteger)maxPlayers playersToInvite:(NSArray *)playersToInvite showExistingMatches:(BOOL)showExistingMatches {
	GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init];
	matchRequest.minPlayers = minPlayers;
	matchRequest.maxPlayers = maxPlayers;
	matchRequest.playersToInvite = playersToInvite;
	GKTurnBasedMatchmakerViewController *matchmakerViewController = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:matchRequest];
	matchmakerViewController.turnBasedMatchmakerDelegate = self;
	matchmakerViewController.showExistingMatches = showExistingMatches;
	return matchmakerViewController;
}

- (BOOL)isFirstTurn:(GKTurnBasedMatch *)match {
	GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
	if (firstParticipant.lastTurnDate == nil) {
		return YES;
	}
	return NO;
}

#pragma mark GKTurnBasedMatchmakerViewControllerDelegate methods
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
	[_presentingViewController dismissModalViewControllerAnimated:YES];
	NSLog(@"Did find match, %@", match);
	self.currentMatch = match;

	if ([self isFirstTurn:match]) {
		[_delegate startNewGameForMatch:nil];
	} else {
		if ([self isLocalPlayersTurnInMatch:match]) {
			[_delegate takeTurnInMatch:match];
		} else {
			[_delegate updateMatch:match];
		}
	}
}

- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController {
	[_presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
	[_presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
	GKTurnBasedParticipant *nextActiveParticipant = [self nextActiveParticipantInMatch:match];
	[match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit
	                        nextParticipant:nextActiveParticipant
				                  matchData:match.matchData
						  completionHandler:^(NSError *error) {
							  NSLog(@"error.localizedDescription = %@", error.localizedDescription);
						  }];
}

- (GKTurnBasedParticipant *)nextActiveParticipantInMatch:(GKTurnBasedMatch *)match {
	GKTurnBasedParticipant *nextParticipant;
	NSUInteger currentIndex = [match.participants indexOfObject:match.currentParticipant];

	for (int i = 0; i < [match.participants count]; i++) {
		nextParticipant = [match.participants objectAtIndex:(currentIndex + 1 + i) % match.participants.count];
		if (nextParticipant.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
			break;
		}
	}
	return nextParticipant;
}

#pragma mark GKTurnBasedEventHandlerDelegate methods
- (void)handleInviteFromGameCenter:(NSArray *)playersToInvite {
	[_presentingViewController dismissModalViewControllerAnimated:YES];
	GKTurnBasedMatchmakerViewController *matchmakerViewController = [self matchMakerViewControllerForMinPlayers:MinPlayers maxPlayers:MaxPlayers playersToInvite:playersToInvite
	                                                                                        showExistingMatches:NO];
	[_presentingViewController presentModalViewController:matchmakerViewController animated:YES];
}

- (void)handleTurnEventForMatch:(GKTurnBasedMatch *)match {
	if ([match.matchID isEqualToString:_currentMatch.matchID]) {
		self.currentMatch = match;
		if ([self isLocalPlayersTurnInMatch:match]) {
			[_delegate takeTurnInMatch:match];
		} else {
			[_delegate updateMatch:match];
		}
	} else {
		if ([self isLocalPlayersTurnInMatch:match]) {
			[_delegate sendNotice:@"Its your turn for another match" forMatch:match];
		}
	}
}

- (BOOL)isLocalPlayersTurnInMatch:(GKTurnBasedMatch *)match {
	return [match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID];
}

- (void)handleMatchEnded:(GKTurnBasedMatch *)match {
	if ([match.matchID isEqualToString:_currentMatch.matchID]) {
		[_delegate receiveEndOfMatch:match];
	} else {
		[_delegate sendNotice:@"Another Game Ended!" forMatch:match];
	}
}


@end