#import <UIKit/UIKit.h>

@class GKLocalPlayer;

@interface MainViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *createGameButton;

- (IBAction)createGameButtonTouched:(id)sender;

@end
