#import <GameKit/GameKit.h>
#import "MainViewController.h"
#import "GameCenterHelper.h"
#import "Game.h"

@interface MainViewController ()

@end

@implementation MainViewController {
}

@synthesize statusLabel;
@synthesize createGameButton;
@synthesize takeTurnButton;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[GameCenterHelper sharedInstance].delegate = self;
}

- (IBAction)createGameButtonTouched:(id)sender {
	[[GameCenterHelper sharedInstance] findMatchWithMinPlayers:MinPlayers maxPlayers:MaxPlayers viewController:self];
}

- (IBAction)takeTurnButtonTouched:(id)sender {
	GKTurnBasedMatch *currentMatch = [[GameCenterHelper sharedInstance] currentMatch];

	GKTurnBasedParticipant *nextParticipant = [[GameCenterHelper sharedInstance] nextActiveParticipantInMatch:currentMatch];
	[currentMatch endTurnWithNextParticipant:nextParticipant
	                               matchData:[@"matchData" dataUsingEncoding:NSUTF8StringEncoding]
			completionHandler:^(NSError *error) {
				if (error) {
					NSLog(@"%@", error);
				} else {
					self.takeTurnButton.enabled = NO;
				}
			}];
	self.statusLabel.text = @"Turn taken, waitung for response";
}

- (void)viewDidUnload {
	[self setStatusLabel:nil];
	[self setCreateGameButton:nil];
	[self setTakeTurnButton:nil];
	[super viewDidUnload];
}

#pragma mark GameCenterHelperDelegate methods
- (void)startNewGameForMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Your turn";
	self.takeTurnButton.enabled = YES;
}

- (void)takeTurnInMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Your turn";
	self.takeTurnButton.enabled = YES;
}

- (void)updateMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Other players turn";
	self.takeTurnButton.enabled = NO;
}

- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match {
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Another game needs your attention!"
	                                             message:notice
		                                        delegate:self cancelButtonTitle:@"Sweet!"
				                       otherButtonTitles:nil];
	[av show];
}

- (void)receiveEndOfMatch:(GKTurnBasedMatch *)match {
	self.statusLabel.text = @"Game over";
}

@end
