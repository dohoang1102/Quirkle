#import "Board.h"


@implementation Board {
	NSMutableArray *_tokens;
}

- (void)clean {
	_tokens = [[NSMutableArray alloc] init];
}


@end