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

- (void)clean {
	[_tokens removeAllObjects];
}

- (void)putFirstToken:(Token *)token {
	if (_tokens.count == 0) {
		[_tokens addObject:token];
	}
}

- (void)addToken:(Token *)token to:(Token *)neighbour atSide:(TokenSide)side {
	[neighbour putNeighbour:token toSide:side];
}
@end