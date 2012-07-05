#import "Board.h"
#import "Token.h"


@implementation Board {
	NSMutableArray *_tokens;
}
@synthesize tokens = _tokens;

- (id)init {
	self = [super init];
	if (self) {
		_tokens = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self) {
		_tokens = [coder decodeObjectForKey:@"tokens"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:_tokens forKey:@"tokens"];
}

- (void)clean {
	[_tokens removeAllObjects];
}

- (void)putFirstToken:(Token *)token {
	if (_tokens.count == 0) {
		[_tokens addObject:token];
	}
}

- (void)addToken:(Token *)neighbour to:(Token *)token atSide:(TokenSide)side {
	if ([token canPutNeighbour:neighbour toSide:side]) {
		[_tokens addObject:neighbour];
		[token putNeighbour:neighbour toSide:side];
		neighbour.coordinate = [self coordinateOfNeighbourOfToken:token atSide:side];
	}
}

- (TokenCoordinate)coordinateOfNeighbourOfToken:(Token *)token atSide:(TokenSide)side {
	TokenCoordinate neighbourCoordinate = TokenCoordinateMake(0, 0);
	switch (side) {
		case TokenSideLeft:
	        neighbourCoordinate = TokenCoordinateMake(token.coordinate.x - 1, token.coordinate.y);
	        break;
		case TokenSideRight:
	        neighbourCoordinate = TokenCoordinateMake(token.coordinate.x + 1, token.coordinate.y);
	        break;
		case TokenSideTop:
	        neighbourCoordinate = TokenCoordinateMake(token.coordinate.x, token.coordinate.y - 1);
	        break;
		case TokenSideBottom:
	        neighbourCoordinate = TokenCoordinateMake(token.coordinate.x, token.coordinate.y + 1);
	        break;
	}
	return neighbourCoordinate;
}
@end