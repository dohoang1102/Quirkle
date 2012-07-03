#import "Game.h"
#import "Token.h"
#import "Player.h"
#import "Board.h"

@implementation Game {
}

@synthesize tokens = _tokens;
@synthesize players = _players;
@synthesize board = _board;


- (Game *)initWithParticipantIDs:(NSArray *)participants {
	self = [super init];
	if (self) {
		[self initializeTokens];
		_players = [[NSMutableArray alloc] init];
		_board = [[Board alloc] init];
		srandom((unsigned int) time(NULL));
		startTokens = 6;
		for (NSString *playerID in participants) {
			[self addPlayerWithParticipantID:playerID];
		}
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self) {
		_board = [coder decodeObjectForKey:@"board"];
		_players = [coder decodeObjectForKey:@"players"];
		_tokens = [coder decodeObjectForKey:@"tokens"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:_tokens forKey:@"tokens"];
	[coder encodeObject:_players forKey:@"players"];
	[coder encodeObject:_board forKey:@"board"];
}

- (void)addPlayerWithParticipantID:(NSString *)playerID {
	Player *player = [[Player alloc] init];
	player.participantID = playerID;
	[self addPlayer:player];
	[self pullStartTokensForPlayer:player];
}

- (void)pullStartTokensForPlayer:(Player *)player {
	int startTokenAmount = startTokens;
	for (int i = 0; i < startTokenAmount; i++) {
		[self pullTokenForPlayer:player];
	}
}

- (void)initializeTokens {
	_tokens = [[NSMutableArray alloc] init];
	NSInteger identifierCounter = 0;
	for (TokenColor color = TokenColorYellow; color <= TokenColorPurple; color++) {
		for (TokenShape shape = TokenShapeCircle; shape <= TokenShapeCross; shape++) {
			for (int tokenCount = 0; tokenCount < TokenPerTokenType; tokenCount++) {
				Token *token = [[Token alloc] initWithColor:color shape:shape identifier:identifierCounter];
				identifierCounter++;
				[_tokens addObject:token];
			}
		}
	}
}

- (void)addPlayer:(Player *)player {
	[_players addObject:player];
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

- (Player *)playerWithParticipantID:(NSString *)playerID {
	for (Player *player in self.players) {
		if ([player.participantID isEqualToString:playerID]) {
			return player;
		}
	}
	return nil;
}
@end