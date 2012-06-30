#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"

@class GKLocalPlayer;

@interface MainViewController : UIViewController <GameCenterHelperDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *createGameButton;
@property (weak, nonatomic) IBOutlet UIButton *takeTurnButton;

- (IBAction)createGameButtonTouched:(id)sender;
- (IBAction)takeTurnButtonTouched:(id)sender;

@end
