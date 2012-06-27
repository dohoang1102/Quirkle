#import <GameKit/GameKit.h>
#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController {
	GKLocalPlayer *_localPlayer;
}

@synthesize statusLabel;
@synthesize localPlayer = _localPlayer;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	GKLocalPlayer *localPlayer = [self localPlayer];
	__weak MainViewController *weakSelf = self;
	[localPlayer authenticateWithCompletionHandler:^(NSError *error) {
		if (localPlayer.isAuthenticated) {
			weakSelf.statusLabel.text = @"LocalPlayer authenticated";
		} else {
			weakSelf.statusLabel.text = @"LocalPlayer not authenticated";
		}
	}];
}

- (GKLocalPlayer *)localPlayer {
	if (_localPlayer == nil) {
		return [GKLocalPlayer localPlayer];
	} else {
		return _localPlayer;
	}
}

- (void)viewDidUnload {
    [self setStatusLabel:nil];
    [super viewDidUnload];
}
@end
