#import <UIKit/UIKit.h>

@class Token;

@interface TokenView : UIView

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) Token *token;
- (id)initWithCenter:(CGPoint)center token:(Token *)token;


@end
