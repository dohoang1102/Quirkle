#import "PlaceholderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlaceholderView

- (id)initWithCenter:(CGPoint)center {
	return [self initWithFrame:CGRectMake(center.x-20, center.y-20, 40, 40)];
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

@end
