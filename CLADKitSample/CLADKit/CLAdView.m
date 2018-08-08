#import "CLAdView.h"
#import "CLAdTabBarView.h"
#import "CLADObject.h"
#define __LisztWEAKSELF __weak typeof(self) weakSelf = self
@interface CLAdView()
{
    CLAdWebView *_adWebView;
}
@end
@implementation CLAdView
+ (instancetype)adViewAt:(UIView *)view gameUrl:(NSURL *)gameUrl{
    return [[self alloc] initWithAtView:view gameUrl:gameUrl];
}
- (instancetype)initWithAtView:(UIView *)view gameUrl:(NSURL *)gameUrl{
    if(self = [super init]){
        [view addSubview:self];
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [self addSubview:self.adWebView];
        [self.adWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        if(gameUrl){
            [self.adWebView addRequestURL:gameUrl];
        }
    }
    return self;
}
- (void)setADObjectConfigs:(NSArray *)adObjectConfigs{
    if(self.adTabBarView)
    {
        NSLog(@"LisztAdTabBarView已存在,不需要重复创建");
        return;
    }
    NSAssert(adObjectConfigs.count, @"web配置不能为空");
    self.adTabBarView = [CLAdTabBarView tabBarItemConfigs:adObjectConfigs];
    self.adTabBarView.backgroundColor = [UIColor colorWithHexString:@"1d7f5e"];
    [self addSubview:self.adTabBarView];
    [self.adTabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo([CLADObject tabBarHeight]);
    }];
    __LisztWEAKSELF;
    [self.adTabBarView setTabBarItemButtonDidSelectAction:^(NSInteger selectIndex) {
        CLADObjectConfig *config = adObjectConfigs[selectIndex];
        config.addressUrl = [config.addressUrl stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
        if(config.configType==LisztADObjectConfigType_Refresh){
            [weakSelf.adWebView reloadWebView];
            return;
        }
        if(config.configType==LisztADObjectConfigType_Back){
            [weakSelf.adWebView goBackWeb];
            return;
        }
        [weakSelf.adWebView addRequestURL:[NSURL URLWithString:config.addressUrl]];
    }];
    CLADObjectConfig *config = adObjectConfigs[0];
    [self.adWebView addRequestURL:[NSURL URLWithString:config.addressUrl]];
}
#pragma mark - 懒加载
- (CLAdWebView *)adWebView{
    if(!_adWebView){
        CLAdWebView *webView = [CLAdWebView new];
        webView.backgroundColor = [UIColor whiteColor];
        [webView setScalesPageToFit:YES];
        webView.scrollView.bounces = NO;
        [self addSubview:_adWebView = webView];
    }
    return _adWebView;
}
@end
