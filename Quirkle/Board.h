#import <Foundation/Foundation.h>

@class Token;


@interface Board : NSObject

@property (nonatomic, strong, readonly) NSArray *tokens;

- (void)clean;
- (void)putFirstToken:(Token *)token1;

@end