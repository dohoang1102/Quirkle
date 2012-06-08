#import "Board.h"
#import "Token.h"

@interface BoardTest : SenTestCase
@end

@implementation BoardTest {
	Board *board;
}

- (void)setUp {
	board = [[Board alloc] init];
}

- (void)testTheFirstTokenSetNeedNoRules {
	Token *token = YellowCircleToken;
	[board putFirstToken:token];
	expect(board.tokens).toContain(token);
}

- (void)testTreadsOnlyOneTokenAsFirstToken {
	[board putFirstToken:YellowCircleToken];
	Token *token2 = BlueCrossToken;
	[board putFirstToken:token2];
	expect(board.tokens).Not.toContain(token2);
}

- (void)testCleanRemovesAllTokens {
	[board putFirstToken:YellowCircleToken];
	[board clean];
	expect(board.tokens.count).toEqual(0);
}

- (void)testStoresAllPuttedTokens {

}

@end