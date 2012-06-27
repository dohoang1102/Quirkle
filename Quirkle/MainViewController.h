#import <UIKit/UIKit.h>

@class GKLocalPlayer;

@interface MainViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *createGameButton;
@property (nonatomic, strong) GKLocalPlayer *localPlayer;

- (void)initializeGameCenter;
- (IBAction)createGameButtonTouched:(id)sender;

@end
