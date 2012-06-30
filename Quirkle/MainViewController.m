#import <GameKit/GameKit.h>
#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController {
}

@synthesize statusLabel;
@synthesize createGameButton;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (IBAction)createGameButtonTouched:(id)sender {
}

- (void)viewDidUnload {
    [self setStatusLabel:nil];
    [self setCreateGameButton:nil];
    [super viewDidUnload];
}
@end
