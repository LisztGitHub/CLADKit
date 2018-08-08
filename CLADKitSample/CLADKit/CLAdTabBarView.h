#import <UIKit/UIKit.h>
@class CLADObjectConfig;
@interface CLAdTabBarView : UIView
+ (instancetype)tabBarItemConfigs:(NSArray <CLADObjectConfig *>*)configs;
- (instancetype)initWithTabBarConfigs:(NSArray<CLADObjectConfig *>*)configs;
@property (nonatomic, copy) void(^tabBarItemButtonDidSelectAction)(NSInteger selectIndex);
@end
