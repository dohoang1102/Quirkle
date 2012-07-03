#import <GameKit/GameKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MainViewController.h"
#import "Game.h"
#import "Player.h"
#import "PlaceholderView.h"
#import "Board.h"
#import "TokenView.h"

@implementation MainViewController {
}


@synthesize statusLabel;
@synthesize createGameButton;
@synthesize takeTurnButton;
@synthesize playerTokensView;
@synthesize tokenCountLabel;
@synthesize currentGames = _currentGames;
@synthesize scrollView;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_currentGames = [[NSMutableDictionary alloc] init];
	[GameCenterHelper sharedInstance].delegate = self;
	self.scrollView.contentSize = self.scrollView.frame.size;
}

- (void)viewDidUnload {
	[self setStatusLabel:nil];
	[self setCreateGameButton:nil];
	[self setTakeTurnButton:nil];
	[self setTokenCountLabel:nil];
	[self setScrollView:nil];
	[self setPlayerTokensView:nil];
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

- (void)updateUIForMatch:(GKTurnBasedMatch *)match {
	Game *currentGame = [self.currentGames objectForKey:match.matchID];
	Player *currentPlayer = [currentGame playerWithParticipantID:match.currentParticipant.playerID];
	CGPoint center = CGPointMake(20, self.playerTokensView.frame.size.height / 2);
	for (Token *token in currentPlayer.tokens) {
		TokenView *tokenView = [[TokenView alloc] initWithCenter:center token:token];
		[self.playerTokensView addSubview:tokenView];
		center = CGPointMake(center.x + 48, center.y);
	}
	self.tokenCountLabel.text = [NSString stringWithFormat:@"%d Tokens left", [currentGame.tokens count]];
	[self layoutBoardWithTokens:currentGame.board.tokens];
}

- (NSMutableArray *)playerIDsForPlayersInMatch:(GKTurnBasedMatch *)match {
	NSMutableArray *playerIDs = [NSMutableArray array];
	[match.participants enumerateObjectsUsingBlock:^(GKTurnBasedParticipant *participant, NSUInteger index, BOOL *stop) {
		[playerIDs addObject:participant.playerID];
	}];
	return playerIDs;
}

- (void)layoutBoardWithTokens:(NSArray *)tokens {
	CGRect scrollViewFrame = self.scrollView.frame;
	CGPoint centerOfBoard = CGPointMake(scrollViewFrame.origin.x + scrollViewFrame.size.width / 2,
			scrollViewFrame.origin.y + scrollViewFrame.size.height / 2);
	if (tokens.count == 0) {
		PlaceholderView *placeholderView = [[PlaceholderView alloc] initWithCenter:centerOfBoard];
		[self.scrollView addSubview:placeholderView];
	} else {
		__weak MainViewController *weakSelf = self;
		[tokens enumerateObjectsUsingBlock:^(Token *token, NSUInteger index, BOOL *stop) {
			TokenCoordinate coordinate = token.coordinate;
			CGPoint center = CGPointMake(centerOfBoard.x + (coordinate.x * 44), centerOfBoard.y + (coordinate.y * 44));
			TokenView *tokenView = [[TokenView alloc] initWithCenter:center token:token];
			[weakSelf.scrollView addSubview:tokenView];
		}];
	}
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
