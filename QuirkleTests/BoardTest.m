#import "Board.h"

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

- (void)testAddsTokensAsNeighbourOfOtherTokens {
	Token *yellowCircle = YellowCircleToken;
	Token *yellowCross = YellowCrossToken;
	[board putFirstToken:yellowCircle];
	[board addToken:yellowCross to:yellowCircle atSide:TokenSideLeft];
	expect([yellowCircle neighbourAtSide:TokenSideLeft]).toEqual(yellowCross);
	expect(board.tokens).toContain(yellowCross);
}

- (void)testAddsNoTokensAgainstRules {
	Token *yellowCircle = YellowCircleToken;
	Token *blueCross = BlueCrossToken;
	[board putFirstToken:yellowCircle];
	[board addToken:blueCross to:yellowCircle atSide:TokenSideLeft];
	expect([yellowCircle neighbourAtSide:TokenSideLeft]).toBeNil();
	expect(board.tokens).Not.toContain(blueCross);
}

@end