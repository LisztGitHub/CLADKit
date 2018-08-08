#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif
extern const float NJKInitialProgressValue;
extern const float NJKInteractiveProgressValue;
extern const float NJKFinalProgressValue;
typedef void (^NJKWebViewProgressBlock)(float progress);
@protocol NJKWebViewProgressDelegate;
@interface CLNJKWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, njk_weak) id<NJKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, njk_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; 
- (void)reset;
@end
@protocol NJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(CLNJKWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end
