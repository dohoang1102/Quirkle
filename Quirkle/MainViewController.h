#import <UIKit/UIKit.h>

@class GKLocalPlayer;

@interface MainViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) GKLocalPlayer *localPlayer;

@end
