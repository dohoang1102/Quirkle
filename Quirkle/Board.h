#import <Foundation/Foundation.h>
#import "Token.h"

@class Token;


@interface Board : NSObject

@property (nonatomic, strong, readonly) NSArray *tokens;

- (void)clean;
- (void)putFirstToken:(Token *)token;
- (void)addToken:(Token *)token to:(Token *)neighbour atSide:(TokenSide)side;

@end