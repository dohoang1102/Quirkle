#import <Foundation/Foundation.h>
#import "Token.h"

@class Player;
@class Board;

#define TokenPerTokenType 3
#define MinPlayers 2
#define MaxPlayers 4


@interface Game : NSObject <NSCoding> {
	NSMutableArray *_tokens;
	NSMutableArray *_players;
	Board *_board;
	int startTokens;
}

@property (nonatomic, strong, readonly) NSArray *tokens;
@property (nonatomic, strong, readonly) NSArray *players;
@property (nonatomic, strong) Board *board;

- (Game *)initWithParticipantIDs:(NSArray *)participants;
- (void)addPlayer:(Player *)player;

- (Player *)playerWithParticipantID:(NSString *)playerID;
- (void)player:(Player *)player putToken:(Token *)token atTokenCoordinate:(TokenCoordinate)coordinate atSide:(TokenSide)side;
@end