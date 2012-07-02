#import "Player.h"
#import "Token.h"
#import "Board.h"


@implementation Player {
	NSMutableArray *_tokens;
@private
	NSString *_participantID;
}
@synthesize tokens = _tokens;
@synthesize participantID = _participantID;


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