#import <GameKit/GameKit.h>
#import "GameCenterHelper.h"

static GameCenterHelper *_sharedInstance;

@implementation GameCenterHelper {
	BOOL _userAuthenticated;
}

+ (GameCenterHelper *)sharedInstance {
	if (_sharedInstance == nil) {
		_sharedInstance = [[GameCenterHelper alloc] init];
	}
	return _sharedInstance;
}

+ (void)setSharedInstance:(GameCenterHelper *)instance {
	_sharedInstance = instance;
}

- (id)init {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(authenticationChanged)
				                                     name:GKPlayerAuthenticationDidChangeNotificationName
					                               object:nil];
	}
	return self;
}

- (void)authenticationChanged {
	_userAuthenticated = [[GKLocalPlayer localPlayer] isAuthenticated];
}

- (void)authenticateLocalPlayer {
	if ([[GKLocalPlayer localPlayer] isAuthenticated] == NO) {
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
			[GKTurnBasedEventHandler sharedTurnBasedEventHandler].delegate = self;
		}];
	}
}


@end