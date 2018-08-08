#import "CLADProgressBar.h"
@implementation CLADProgressBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(self.bgColor){
        [self drawProgressBgColorContext:context rect:rect];
    }
    if(self.bufferProgressValue>0){
        [self drawBufferProgress:context withFrame:rect];
    }
    if(self.progressValue>0){
        [self drawProgress:context withFrame:rect];
    }
}
- (void)drawProgressBgColorContext:(CGContextRef)context rect:(CGRect)rect{
    CGContextSaveGState(context);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    [roundedRect fill];
    UIBezierPath *roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect:CGRectMake(-10, -10, rect.size.width+10, rect.size.height+10)];
    [roundedRectangleNegativePath appendPath:roundedRect];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;
    [roundedRect addClip];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rect.size.width), 0);
    [roundedRectangleNegativePath applyTransform:transform];
    [[UIColor grayColor] setFill];
    [roundedRectangleNegativePath fill];
    CGContextRestoreGState(context);
    [roundedRect addClip];
}
- (void)drawProgress:(CGContextRef)context withFrame:(CGRect)frame {
    CGRect rectToDrawIn = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width * self.progressValue, frame.size.height);
    CGRect insetRect = CGRectInset(rectToDrawIn, 0, 0);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:0];
    CGContextSaveGState(context);
    [roundedRect addClip];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id)self.progressColor.CGColor, (__bridge id)self.progressColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(insetRect.size.width / 2, 0), CGPointMake(insetRect.size.width / 2, insetRect.size.height), 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
- (void)drawBufferProgress:(CGContextRef)context withFrame:(CGRect)frame {
    CGRect rectToDrawIn = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width * self.bufferProgressValue, frame.size.height);
    CGRect insetRect = CGRectInset(rectToDrawIn, 0, 0);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:0];
    CGContextSaveGState(context);
    [roundedRect addClip];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id)self.bufferColor.CGColor, (__bridge id)self.bufferColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(insetRect.size.width / 2, 0), CGPointMake(insetRect.size.width / 2, insetRect.size.height), 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
#pragma mark - public attribute
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
}
- (void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
}
- (void)setBufferColor:(UIColor *)bufferColor{
    _bufferColor = bufferColor;
}
- (void)setProgressValue:(CGFloat)progressValue{
    _progressValue = progressValue;
    [self setNeedsDisplay];
}
- (void)setBufferProgressValue:(CGFloat)bufferProgressValue{
    _bufferProgressValue = bufferProgressValue;
    [self setNeedsDisplay];
}
@end
