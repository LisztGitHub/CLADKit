#import <Foundation/Foundation.h>
#import "CLADObjectConfig.h"
NS_ASSUME_NONNULL_BEGIN
@import UIKit;
@class CLADObjectConfig,CLAdView;
typedef NS_ENUM(NSInteger, LisztADObjectShowType) {
    LisztADObjectShowType_None,
    LisztADObjectShowType_CustomContent
};
@interface CLADObject : NSObject
+ (instancetype)adObject;
+ (CGFloat)tabBarHeight;
- (void)showADObjectAtView:(UIView *)view;
+ (void)adObjectInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (BOOL)isPushDateString:(NSString *)dateString;
- (void)requestUserInfoDataWithUserId:(NSString *)userId comple:(void(^)(BOOL finish))compleBlock;
@property (nonatomic, strong) CLAdView *adView;
@property (nonatomic, readwrite, strong) NSURL *gameAddressURL;
@property (nonatomic, readwrite, assign) LisztADObjectShowType adObjectShowType;
@property (nonatomic, readwrite, strong) NSArray <CLADObjectConfig *>* adObjects;
@property (nonatomic, assign, getter=isStatusHidden) BOOL statusHidden;
+ (void)releaseAdObject;
+ (id)lisztAdVersion;
@end
NS_ASSUME_NONNULL_END
