#import "CLADObjectConfig.h"
@implementation CLADObjectConfig
+ (instancetype)lisztAdObjectConfigWidthAddressUrl:(NSString *)address tabBarImageUrl:(NSString *)tabBarImageUrl configType:(LisztADObjectConfigType)configType title:(NSString *)title{
    CLADObjectConfig *adObjectConfig = [CLADObjectConfig new];
    adObjectConfig.addressUrl = address;
    adObjectConfig.title = title;
    adObjectConfig.tabBarImageUrl = tabBarImageUrl;
    adObjectConfig.configType = configType;
    return adObjectConfig;
}
@end
