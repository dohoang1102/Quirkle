#import "Board.h"


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

- (void)addToken:(Token *)neighbour to:(Token *)token atSide:(TokenSide)side {
	if ([token canPutNeighbour:neighbour toSide:side]) {
		[_tokens addObject:neighbour];
		[token putNeighbour:neighbour toSide:side];
	}
}
@end