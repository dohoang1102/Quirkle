#import <GameKit/GameKit.h>
#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController {
	GKLocalPlayer *_localPlayer;
}

@synthesize statusLabel;
@synthesize createGameButton;
@synthesize localPlayer = _localPlayer;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeGameCenter];
}

- (void)initializeGameCenter {
	GKLocalPlayer *localPlayer = [self localPlayer];
	__weak MainViewController *weakSelf = self;
	[localPlayer authenticateWithCompletionHandler:^(NSError *error) {
		if (localPlayer.isAuthenticated) {
			weakSelf.statusLabel.text = @"LocalPlayer authenticated";
		} else {
			weakSelf.statusLabel.text = @"LocalPlayer not authenticated";
		}
		[weakSelf enableCreateGameButton:[weakSelf localPlayer].authenticated];
	}];
}

- (void)enableCreateGameButton:(BOOL)enabled {
	self.createGameButton.enabled = enabled;
	self.createGameButton.titleLabel.textColor = enabled? [UIColor blueColor] : [UIColor redColor];
	NSLog(@"enable button");
}

- (GKLocalPlayer *)localPlayer {
	if (_localPlayer == nil) {
		return [GKLocalPlayer localPlayer];
	} else {
		return _localPlayer;
	}
}

- (IBAction)createGameButtonTouched:(id)sender {
	if ([self localPlayer].authenticated) {
		GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init];
		matchRequest.minPlayers = 2;
		matchRequest.maxPlayers = 4;

	}
}

- (void)viewDidUnload {
    [self setStatusLabel:nil];
    [self setCreateGameButton:nil];
    [super viewDidUnload];
}
@end
