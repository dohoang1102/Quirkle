#import "TokenView.h"
#import "Token.h"
#import <QuartzCore/QuartzCore.h>

@implementation TokenView {
	BOOL _selected;
	Token *_token;
}

@synthesize selected = _selected;
@synthesize token = _token;


- (id)initWithCenter:(CGPoint)center token:(Token *)token {
	CGRect frame = CGRectMake(center.x - 20, center.y - 20, 40, 40);
	self = [self initWithFrame:frame];
	if (self) {
		switch (token.color) {
			case TokenColorBlue: self.backgroundColor = [UIColor blueColor]; break;
			case TokenColorGreen: self.backgroundColor = [UIColor greenColor]; break;
			case TokenColorOrange: self.backgroundColor = [UIColor orangeColor]; break;
			case TokenColorPurple: self.backgroundColor = [UIColor purpleColor]; break;
			case TokenColorRed: self.backgroundColor = [UIColor redColor]; break;
			case TokenColorYellow: self.backgroundColor = [UIColor yellowColor]; break;
		}
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		switch (token.shape) {
			case TokenShapeCircle: label.text = @"C"; break;
			case TokenShapeCross: label.text = @"X"; break;
			case TokenShapeFlower: label.text = @"F"; break;
			case TokenShapeSquare: label.text = @"Q"; break;
			case TokenShapeStar: label.text = @"S"; break;
			case TokenShapeTriangle: label.text = @"T"; break;
		}
		[self addSubview:label];
		self.token = token;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
	    self.layer.borderWidth = 1.0;
	    self.layer.borderColor = [UIColor blackColor].CGColor;
	    self.layer.cornerRadius = 10.0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
	_selected = selected;
	if (_selected) {
		self.layer.borderWidth = 3.0;
	} else {
		self.layer.borderWidth = 1.0;
	}
}
@end
