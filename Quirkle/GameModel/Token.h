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

typedef struct TokenCoordinate {
  NSInteger x;
  NSInteger y;
} TokenCoordinate;

CG_INLINE TokenCoordinate
TokenCoordinateMake(NSInteger x, NSInteger y) {
  TokenCoordinate c; c.x = x; c.y = y; return c;
}

@interface Token : NSObject <NSCoding>

@property (nonatomic, assign) TokenColor color;
@property (nonatomic, assign) TokenShape shape;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) TokenCoordinate coordinate;
@property (nonatomic, strong) NSArray *gameRules;

- (id)initWithColor:(TokenColor)color shape:(TokenShape)shape identifier:(NSInteger)identifier;
- (void)putNeighbour:(Token *)token toSide:(TokenSide)side;
- (BOOL)canPutNeighbour:(Token *)token toSide:(TokenSide)side;

- (Token *)neighbourAtSide:(TokenSide)side;

@end