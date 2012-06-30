#import <Foundation/Foundation.h>
#import "GameCenterHelper.h"

@interface GameCenterHelper (TestSetter)

+ (void)setSharedInstance:(GameCenterHelper *)instance;

@end