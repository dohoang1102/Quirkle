#import "Player.h"
#import "Token.h"
#import "Board.h"


@implementation Player {
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

- (void)pullToken:(Token *)token {
	[_tokens addObject:token];
}

- (NSInteger)putTokensToBoard:(Board *)board {
	return 0;
}


@end