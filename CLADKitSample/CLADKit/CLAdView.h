#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "CLAdWebView.h"
NS_ASSUME_NONNULL_BEGIN
@class CLADObjectConfig,CLAdTabBarView;
@interface CLAdView : UIView
@property (nonatomic, strong) CLAdWebView *adWebView;
@property (nonatomic, strong) CLAdTabBarView *adTabBarView;
+ (id)adViewAt:(UIView *)view gameUrl:(NSURL *)gameUrl;
- (void)setADObjectConfigs:(NSArray <CLADObjectConfig *>*)adObjectConfigs;
@end
NS_ASSUME_NONNULL_END
