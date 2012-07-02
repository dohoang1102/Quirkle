#import <Foundation/Foundation.h>
#import "Token.h"

@class Token;


@interface Board : NSObject

@property (nonatomic, strong, readonly) NSArray *tokens;

- (void)clean;
- (void)putFirstToken:(Token *)token;
- (void)addToken:(Token *)neighbour to:(Token *)token atSide:(TokenSide)side;

@end