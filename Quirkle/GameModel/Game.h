#import <Foundation/Foundation.h>

@class Player;
@class Board;

#define TokenPerTokenType 3
#define MinPlayers 2
#define MaxPlayers 4


@interface Game : NSObject {
	NSMutableArray *_tokens;
	NSMutableArray *_players;
	Board *_board;
	int startTokens;
}

@property (nonatomic, strong, readonly) NSArray *tokens;
@property (nonatomic, strong, readonly) NSArray *players;
@property (nonatomic, strong) Board *board;

- (void)addPlayer:(Player *)player;
- (void)startGame;
- (void)distributeStartTokens;

- (Player *)playerWithParticipantID:(NSString *)playerID;
@end