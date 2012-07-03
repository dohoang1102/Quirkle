#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"

@class Game;

@interface MainViewController : UIViewController <GameCenterHelperDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIButton *createGameButton;
@property (nonatomic, weak) IBOutlet UIButton *takeTurnButton;
@property (nonatomic, weak) IBOutlet UILabel *tokenCountLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *playerTokensView;

@property (nonatomic, strong) NSMutableDictionary *currentGames;

- (IBAction)createGameButtonTouched:(id)sender;
- (IBAction)takeTurnButtonTouched:(id)sender;

@end
