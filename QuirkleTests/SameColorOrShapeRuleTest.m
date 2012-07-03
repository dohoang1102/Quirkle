#import "Token.h"
#import "SameColorOrShapeRule.h"

@interface SameColorOrShapeRuleTest : SenTestCase
@end

@implementation SameColorOrShapeRuleTest {
}

- (void)testOnlyAddsSameColoredTokensAsNeighbour {
	Token *yellowCircleToken = [[Token alloc] initWithColor:TokenColorYellow shape:TokenShapeCircle identifier:0];
	Token *yellowSquareToken = [[Token alloc] initWithColor:TokenColorYellow shape:TokenShapeSquare identifier:0];
	Token *blueSquareToken = [[Token alloc] initWithColor:TokenColorBlue shape:TokenShapeSquare identifier:0];

	SameColorOrShapeRule *rule = [[SameColorOrShapeRule alloc] initWithToken:yellowCircleToken];
	expect([rule appliesToToken:yellowSquareToken atSide:TokenSideLeft]).toBeTruthy();
	expect([rule appliesToToken:blueSquareToken atSide:TokenSideLeft]).toBeFalsy();
}

- (void)testOnlyAddsSameShapedTokenAsNeighbour {
	Token *yellowCircleToken = [[Token alloc] initWithColor:TokenColorYellow shape:TokenShapeCircle identifier:0];
	Token *blueCircleToken = [[Token alloc] initWithColor:TokenColorBlue shape:TokenShapeCircle identifier:0];
	Token *blueSquareToken = [[Token alloc] initWithColor:TokenColorBlue shape:TokenShapeSquare identifier:0];

	SameColorOrShapeRule *rule = [[SameColorOrShapeRule alloc] initWithToken:yellowCircleToken];
	expect([rule appliesToToken:blueCircleToken atSide:TokenSideLeft]).toBeTruthy();
	expect([rule appliesToToken:blueSquareToken atSide:TokenSideLeft]).toBeFalsy();
}

@end