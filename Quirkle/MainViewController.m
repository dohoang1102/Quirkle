#import <GameKit/GameKit.h>
#import "MainViewController.h"
#import "Game.h"
#import "Player.h"

@implementation MainViewController {
}


@synthesize statusLabel;
@synthesize createGameButton;
@synthesize takeTurnButton;
@synthesize tokenButtons;
@synthesize tokenCountLabel;
@synthesize currentGames = _currentGames;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_currentGames = [[NSMutableDictionary alloc] init];
	[GameCenterHelper sharedInstance].delegate = self;
}

- (void)viewDidUnload {
	[self setStatusLabel:nil];
	[self setCreateGameButton:nil];
	[self setTakeTurnButton:nil];
    [self setTokenButtons:nil];
    [self setTokenCountLabel:nil];
	[super viewDidUnload];
}

- (IBAction)createGameButtonTouched:(id)sender {
	[[GameCenterHelper sharedInstance] findMatchWithMinPlayers:MinPlayers maxPlayers:MaxPlayers viewController:self];
}

- (IBAction)takeTurnButtonTouched:(id)sender {
	GKTurnBasedMatch *currentMatch = [[GameCenterHelper sharedInstance] currentMatch];
	Game *currentGame = [self.currentGames objectForKey:currentMatch.matchID];

	GKTurnBasedParticipant *nextParticipant = [[GameCenterHelper sharedInstance] nextActiveParticipantInMatch:currentMatch];
	[currentMatch endTurnWithNextParticipant:nextParticipant
	                               matchData:[NSKeyedArchiver archivedDataWithRootObject:currentGame]
						   completionHandler:^(NSError *error) {
				if (error) {
					NSLog(@"%@", error);
				} else {
					self.takeTurnButton.enabled = NO;
				}
			}];
	self.statusLabel.text = @"Turn taken, waitung for response";
}

- (IBAction)tokenButtonTouched:(id)sender {
}

- (void)updateUIForMatch:(GKTurnBasedMatch *)match {
	Game *currentGame = [self.currentGames objectForKey:match.matchID];
	Player *currentPlayer = [currentGame playerWithParticipantID:match.currentParticipant.playerID];
	for (NSUInteger i=0; i<currentPlayer.tokens.count; i++) {
		NSString *title = [[currentPlayer.tokens objectAtIndex:i] description];
		[[self.tokenButtons objectAtIndex:i] setTitle:title forState:UIControlStateNormal];
	}
	self.tokenCountLabel.text = [NSString stringWithFormat:@"%d Tokens left", [currentGame.tokens count]];
}

- (NSMutableArray *)playerIDsForPlayersInMatch:(GKTurnBasedMatch *)match {
	NSMutableArray *playerIDs = [NSMutableArray array];
	[match.participants enumerateObjectsUsingBlock:^(GKTurnBasedParticipant *participant, NSUInteger index, BOOL *stop) {
		[playerIDs addObject:participant.playerID];
	}];
	return playerIDs;
}

#pragma mark GameCenterHelperDelegate methods
- (void)startNewGameForMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Yo man the match starts now";
	self.takeTurnButton.enabled = YES;

	Game *game = [[Game alloc] initWithParticipantIDs:[self playerIDsForPlayersInMatch:match]];
	[self.currentGames setObject:game forKey:match.matchID];
	[self updateUIForMatch:match];
}

- (void)takeTurnInMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Your turn";
	self.takeTurnButton.enabled = YES;
	Game *game = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
	[self.currentGames setObject:game forKey:match.matchID];
	[self updateUIForMatch:match];
}

- (void)updateMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Other players turn";
	self.takeTurnButton.enabled = NO;
	Game *game = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
	[self.currentGames setObject:game forKey:match.matchID];
	[self updateUIForMatch:match];
}

- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match {
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Another game needs your attention!"
	                                             message:notice
		                                        delegate:self cancelButtonTitle:@"Sweet!"
				                       otherButtonTitles:nil];
	[av show];
}

- (void)receiveEndOfMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Game over";
}

@end
