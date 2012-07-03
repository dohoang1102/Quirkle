#import "Token.h"
#import "Board.h"

@interface BoardCoordinateTest : SenTestCase
@end

@implementation BoardCoordinateTest {
	Board *board;
	Token *firstToken;
	Token *secondToken;
}

- (void)setUp {
	board = [[Board alloc] init];
	firstToken = YellowCircleToken;
	firstToken.coordinate = TokenCoordinateMake(1, 1);
	secondToken = BlueCircleToken;
	[board putFirstToken:firstToken];
}


- (void)testFirstTokenGetInitialCoordinates {
	Token *token = YellowCircleToken;
	[board putFirstToken:token];
	expect(token.coordinate.x).toEqual(0);
	expect(token.coordinate.y).toEqual(0);
}

- (void)testComputesCoordinatesWhenTokenSetToLeft {
	[board addToken:secondToken to:firstToken atSide:TokenSideLeft];
	[self expectOffsetX:-1 offsetY:0];
}

- (void)testComputesCoordinatesWhenTokenSetToRight {
	[board addToken:secondToken to:firstToken atSide:TokenSideRight];
	[self expectOffsetX:1 offsetY:0];
}

- (void)testComputesCoordinatesWhenTokenSetToTop {
	[board addToken:secondToken to:firstToken atSide:TokenSideTop];
	[self expectOffsetX:0 offsetY:-1];
}

- (void)testComputesCoordinatesWhenTokenSetToBottom {
	[board addToken:secondToken to:firstToken atSide:TokenSideBottom];
	[self expectOffsetX:0 offsetY:1];
}

- (void)expectOffsetX:(NSInteger)xOffset offsetY:(NSInteger)yOffset {
	expect(firstToken.coordinate.x).toEqual(1);
	expect(firstToken.coordinate.y).toEqual(1);
	expect(secondToken.coordinate.x).toEqual(1+xOffset);
	expect(secondToken.coordinate.y).toEqual(1+yOffset);
}


@end