#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface GameCenterHelper : NSObject <GKTurnBasedEventHandlerDelegate>

+ (GameCenterHelper *)sharedInstance;
- (void)authenticateLocalPlayer;

@end