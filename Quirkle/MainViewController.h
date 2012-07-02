#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"

@class Game;

@interface MainViewController : UIViewController <GameCenterHelperDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIButton *createGameButton;
@property (nonatomic, weak) IBOutlet UIButton *takeTurnButton;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *tokenButtons;
@property (nonatomic, weak) IBOutlet UILabel *tokenCountLabel;
@property (nonatomic, strong) NSMutableDictionary *currentGames;

- (IBAction)createGameButtonTouched:(id)sender;
- (IBAction)takeTurnButtonTouched:(id)sender;
- (IBAction)tokenButtonTouched:(id)sender;

@end
