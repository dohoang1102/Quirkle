#import "Player.h"
#import "Token.h"
#import "Board.h"


@implementation Player {
	NSMutableArray *_tokens;
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

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self ) {
		_tokens = [coder decodeObjectForKey:@"tokens"];
		_participantID = [coder decodeObjectForKey:@"participantID"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:_participantID forKey:@"participantID"];
	[coder encodeObject:_tokens forKey:@"tokens"];
}

- (void)pullToken:(Token *)token {
	[_tokens addObject:token];
}

- (NSInteger)putTokensToBoard:(Board *)board {
	return 0;
}


@end