#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"

@interface MainViewController : UIViewController <GameCenterHelperDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIButton *createGameButton;
@property (nonatomic, weak) IBOutlet UIButton *takeTurnButton;

- (IBAction)createGameButtonTouched:(id)sender;
- (IBAction)takeTurnButtonTouched:(id)sender;

@end
