#import "UIView+UX.h"
@implementation UIView (UX)
- (void)setX:(CGFloat)x {
   CGRect frame = self.frame;
   frame.origin.x = x;
   self.frame = frame;
}
- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame= frame;
}
- (CGFloat)height {
    return self.frame.size.height;
}
#pragma mark - IB
- (UIColor *)borderColor {
	return self.borderColor;
}
- (CGFloat)borderWidth {
    return self.borderWidth;
}
- (CGFloat)cornerRadius {
    return self.cornerRadius;
}
- (void)setBorderColor:(UIColor *)borderColor {
	self.layer.borderColor = borderColor.CGColor;
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth < 0) return;
    self.layer.borderWidth = borderWidth;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
@end
