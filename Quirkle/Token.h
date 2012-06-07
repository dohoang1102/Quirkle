#import <Foundation/Foundation.h>

typedef enum {
	TokenColorYellow,
	TokenColorBlue,
	TokenColorRed,
	TokenColorGreen,
	TokenColorOrange,
	TokenColorPurple
} TokenColor;

typedef enum {
	TokenShapeCircle,
	TokenShapeSquare,
	TokenShapeTriangle,
	TokenShapeFlower,
	TokenShapeStar,
	TokenShapeCross
} TokenShape;

typedef enum {
	TokenSideTop,
	TokenSideRight,
	TokenSideBottom,
	TokenSideLeft
} TokenSide;

@interface Token : NSObject

@property (nonatomic, assign) TokenColor color;
@property (nonatomic, assign) TokenShape shape;
@property (nonatomic, strong) NSArray *gameRules;

+ (Token*)tokenWithColor:(TokenColor)color shape:(TokenShape)shape;
- (id)initWithColor:(TokenColor)color shape:(TokenShape)shape;
- (void)putNeighbour:(Token *)token toSide:(TokenSide)side;
- (Token *)neighbourAtSide:(TokenSide)side;

@end