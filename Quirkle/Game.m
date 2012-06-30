#import "Game.h"
#import "Token.h"
#import "Player.h"
#import "Board.h"

@implementation Game {
}

@synthesize tokens = _tokens;
@synthesize players = _players;
@synthesize board = _board;


- (id)init {
	self = [super init];
	if (self) {
		[self initializeTokens];
		_players = [[NSMutableArray alloc] init];
		_board = [[Board alloc] init];
		srandom((unsigned int) time(NULL));
		startTokens = 6;
	}
	return self;
}

- (void)initializeTokens {
	_tokens = [[NSMutableArray alloc] init];
	for (TokenColor color = TokenColorYellow; color <= TokenColorPurple; color++) {
		for (TokenShape shape = TokenShapeCircle; shape <= TokenShapeCross; shape++) {
			for (int tokenCount = 0; tokenCount < TokenPerTokenType; tokenCount++) {
				Token *token = [[Token alloc] initWithColor:color shape:shape];
				[_tokens addObject:token];
			}
		}
	}
}

- (void)addPlayer:(Player *)player {
	[_players addObject:player];
}

- (void)startGame {
	[self distributeStartTokens];
	[_board clean];
	[self playTurns];
}

- (void)distributeStartTokens {
	[_players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
		int startTokenAmount = startTokens;
		for (int i = 0; i < startTokenAmount; i++) {
			[self pullTokenForPlayer:player];
		}
	}];
}

- (void)playTurns {
	while (_tokens.count > 0) {
		for (Player *player in _players) {
			[self playTurnWithPlayer:player];
		}
	}
}

- (void)playTurnWithPlayer:(Player *)player {
	NSInteger tokensPut = [player putTokensToBoard:_board];
	for (int i = 0; i < tokensPut; i++) {
		[self pullTokenForPlayer:player];
	}
}

- (void)pullTokenForPlayer:(Player *)player {
	if (_tokens.count > 0) {
		Token *token = [self randomToken];
		[player pullToken:token];
	}
}

- (Token *)randomToken {
	NSUInteger randomIndex = [self randomizedTokenIndex];
	Token *token = [_tokens objectAtIndex:randomIndex];
	[_tokens removeObjectAtIndex:randomIndex];
	return token;
}

- (NSUInteger)randomizedTokenIndex {
	return (NSUInteger) (random() % _tokens.count);
}

@end