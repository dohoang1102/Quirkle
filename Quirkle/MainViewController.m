#import <GameKit/GameKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MainViewController.h"
#import "Game.h"
#import "Player.h"
#import "PlaceholderView.h"
#import "Board.h"
#import "TokenView.h"
#import "Token.h"

@implementation MainViewController {
	Token *_currentSelectedToken;
}


@synthesize statusLabel;
@synthesize createGameButton;
@synthesize takeTurnButton;
@synthesize playerTokensView;
@synthesize tokenCountLabel;
@synthesize currentGames = _currentGames;
@synthesize scrollView;
@synthesize currentSelectedToken = _currentSelectedToken;


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

- (void)playerTokenTouched:(UIGestureRecognizer *)gestureRecognizer {
	TokenView *tokenView = (TokenView *) gestureRecognizer.view;
	[self deselectTokensInPlayerArea:self.playerTokensView toggleSelectionForToken:tokenView];
	self.currentSelectedToken = tokenView.selected ? tokenView.token : nil;
}

- (void)placeholderTouched:(UIGestureRecognizer *)gestureRecognizer {
	GKTurnBasedMatch *currentMatch = [[GameCenterHelper sharedInstance] currentMatch];
	Game *currentGame = [self.currentGames objectForKey:currentMatch.matchID];

	if (self.currentSelectedToken) {
		Player *currentPlayer = [currentGame playerWithParticipantID:currentMatch.currentParticipant.playerID];
		[currentGame player:currentPlayer putToken:self.currentSelectedToken atToken:nil atSide:TokenSideLeft];
		self.currentSelectedToken = nil;
		[self updateUI];
	}
}

- (void)updateUI {
	GKTurnBasedMatch *currentMatch = [[GameCenterHelper sharedInstance] currentMatch];
	Game *currentGame = [self.currentGames objectForKey:currentMatch.matchID];

	[self layoutBoardWithTokens:currentGame.board.tokens];
	Player *localPlayer = [currentGame playerWithParticipantID:[GKLocalPlayer localPlayer].playerID];
	[self layoutAreaForPlayer:localPlayer];
	self.tokenCountLabel.text = [NSString stringWithFormat:@"%d Tokens left", [currentGame.tokens count]];
}

- (void)layoutBoardWithTokens:(NSArray *)tokens {
	[[self.scrollView subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop) {
		[view removeFromSuperview];
	}];
	CGRect scrollViewFrame = self.scrollView.frame;
	CGPoint centerOfBoard = CGPointMake(scrollViewFrame.origin.x + scrollViewFrame.size.width / 2,
	scrollViewFrame.origin.y + scrollViewFrame.size.height / 2);
	if (tokens.count == 0) {
		PlaceholderView *placeholderView = [[PlaceholderView alloc] initWithCenter:centerOfBoard];
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeholderTouched:)];
		[placeholderView addGestureRecognizer:tapGestureRecognizer];
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

- (void)layoutAreaForPlayer:(Player *)localPlayer {
	CGPoint center = CGPointMake(20, self.playerTokensView.frame.size.height / 2);
	[[self.playerTokensView subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL* stop) {
		[view removeFromSuperview];
	}];
	for (Token *token in localPlayer.tokens) {
		TokenView *tokenView = [[TokenView alloc] initWithCenter:center token:token];
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerTokenTouched:)];
		[tokenView addGestureRecognizer:tapGestureRecognizer];
		[self.playerTokensView addSubview:tokenView];
		center = CGPointMake(center.x + 48, center.y);
	}
}

- (void)deselectTokensInPlayerArea:(UIView *)playerAreaView toggleSelectionForToken:(TokenView *)tokenView {
	tokenView.selected = !tokenView.selected;
	for (UIView *view in playerAreaView.subviews) {
		if ([view isKindOfClass:[TokenView class]] && view != tokenView) {
			TokenView *tv = (TokenView *) view;
			tv.selected = NO;
		}
	}
}

#pragma mark GameCenterHelperDelegate methods
- (void)startNewGameForMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Yo man the match starts now";
	self.takeTurnButton.enabled = YES;

	Game *game = [[Game alloc] initWithParticipantIDs:[self playerIDsForPlayersInMatch:match]];
	[self.currentGames setObject:game forKey:match.matchID];
	[self updateUI];
}

- (NSMutableArray *)playerIDsForPlayersInMatch:(GKTurnBasedMatch *)match {
	NSMutableArray *playerIDs = [NSMutableArray array];
	[match.participants enumerateObjectsUsingBlock:^(GKTurnBasedParticipant *participant, NSUInteger index, BOOL *stop) {
		[playerIDs addObject:participant.playerID];
	}];
	return playerIDs;
}

- (void)takeTurnInMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Your turn";
	self.takeTurnButton.enabled = YES;
	Game *game = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
	[self.currentGames setObject:game forKey:match.matchID];
	[self updateUI];
}

- (void)updateMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Other players turn";
	self.takeTurnButton.enabled = NO;
	Game *game = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
	[self.currentGames setObject:game forKey:match.matchID];
	[self updateUI];
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
