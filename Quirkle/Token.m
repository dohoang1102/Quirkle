#import "Token.h"


@implementation Token {
	TokenColor _color;
	TokenShape _shape;
	NSMutableArray *_neighbours;
}

@synthesize color = _color;
@synthesize shape = _shape;

- (Token *)initWithColor:(TokenColor)color shape:(TokenShape)shape {
	self = [super init];
	if (self) {
		_color = color;
		_shape = shape;
		_neighbours = [[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null], [NSNull null], [NSNull null], nil];
	}
	return self;
}

- (void)putNeighbour:(Token *)token toSide:(TokenSide)side {
	if ([self isEmpty:side] && ([self isSameColor:token] || [self isSameShape:token])) {
		[_neighbours replaceObjectAtIndex:side withObject:token];
		[token putNeighbour:self toSide:[self oppositeSideOf:side]];
	}
}

- (TokenSide)oppositeSideOf:(TokenSide)side {
	switch (side) {
		case TokenSideLeft: return TokenSideRight;
		case TokenSideRight: return TokenSideLeft;
		case TokenSideTop: return TokenSideBottom;
		case TokenSideBottom: return TokenSideTop;
	}
	return TokenSideLeft;
}

- (BOOL)isEmpty:(TokenSide)side {
	return [_neighbours objectAtIndex:side] == [NSNull null];
}

- (BOOL)isSameColor:(Token *)token {
	return token.color == self.color;
}

- (BOOL)isSameShape:(Token *)token {
	return self.shape == token.shape;
}

- (Token *)neighbourAtSide:(TokenSide)side {
	if ([self isEmpty:side]) {
		return nil;
	}
	return [_neighbours objectAtIndex:side];
}
@end