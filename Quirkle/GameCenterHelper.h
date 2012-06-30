#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GameCenterHelperDelegate
- (void)startNewGameForMatch:(GKTurnBasedMatch *)match;
- (void)takeTurnInMatch:(GKTurnBasedMatch *)match;
- (void)updateMatch:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match;
- (void)receiveEndOfMatch:(GKTurnBasedMatch *)match;
@end

@interface GameCenterHelper : NSObject <GKTurnBasedEventHandlerDelegate, GKTurnBasedMatchmakerViewControllerDelegate>

@property (nonatomic, strong) GKTurnBasedMatch *currentMatch;
@property (nonatomic, strong) UIViewController *presentingViewController;
@property (nonatomic, weak) id<GameCenterHelperDelegate> delegate;

+ (GameCenterHelper *)sharedInstance;
- (void)authenticateLocalPlayer;
- (void)findMatchWithMinPlayers:(NSUInteger)minPlayers maxPlayers:(NSUInteger)maxPlayers viewController:(UIViewController *)viewController;
- (GKTurnBasedParticipant *)nextActiveParticipantInMatch:(GKTurnBasedMatch *)match;


@end