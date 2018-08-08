#import <UIKit/UIKit.h>
@interface CLADProgressBar : UIView
@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UIColor *progressColor;
@property (strong, nonatomic) UIColor *bufferColor;
@property (assign, nonatomic) CGFloat progressValue;
@property (assign, nonatomic) CGFloat bufferProgressValue;
@end
