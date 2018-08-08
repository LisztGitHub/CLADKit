#import <UIKit/UIKit.h>
@interface CLNJKWebViewProgressView : UIView
@property (nonatomic) float progress;
@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; 
@property (nonatomic) NSTimeInterval fadeAnimationDuration; 
@property (nonatomic) NSTimeInterval fadeOutDelay; 
- (void)setProgress:(float)progress animated:(BOOL)animated;
@end
