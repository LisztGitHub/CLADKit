#import "CLADObject.h"
#import "CLAdView.h"
#import "CLADNetworking.h"
#import "CLVersionManager.h"
#import <YYModel.h>
#import "NSObject+Encrypt3DES.h"
#import "CLDataCache.h"
#import "CLCoreStatus.h"
static CLADObject *adObject;
static dispatch_once_t onceToken;
@implementation CLADObject
+ (instancetype)adObject{
    dispatch_once(&onceToken, ^{
        adObject = [[self alloc] init];
    });
    return adObject;
}
+ (void)releaseAdObject{
    adObject = nil;
    onceToken = 0;
}
- (void)showADObjectAtView:(UIView *)view{
    if(self.adView)
    {
        NSLog(@"广告视图已存在.不会重复创建");
        return;
    }
    self.adView = [CLAdView adViewAt:view gameUrl:self.gameAddressURL];
}
- (void)setStatusHidden:(BOOL)statusHidden{
    _statusHidden = statusHidden;
    [[UIApplication sharedApplication]setStatusBarHidden:statusHidden];
}
- (void)setAdObjects:(NSArray<CLADObjectConfig *> *)adObjects{
    NSAssert(self.adView, @"请先创建广告视图");
    [self.adView setADObjectConfigs:adObjects];
}
- (void)setGameAddressURL:(NSURL *)gameAddressURL{
    _gameAddressURL = gameAddressURL;
    [self.adView.adWebView addRequestURL:gameAddressURL];
}
- (void)setAdObjectShowType:(LisztADObjectShowType)adObjectShowType{
    _adObjectShowType = adObjectShowType;
    if(adObjectShowType==LisztADObjectShowType_CustomContent){
        if(!self.adView.adWebView){
            NSLog(@"请先调用showADObjectAtView实现添加广告视图");
            return;
        }
        [self.adView.adWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.adView);
            make.bottom.mas_offset(-[CLADObject tabBarHeight]);
        }];
    }
}
- (void)requestUserInfoDataWithUserId:(NSString *)userId comple:(void (^)(BOOL))compleBlock{
    if([CLDataCache isCacheData]){
        NSDictionary *responseObject = [CLDataCache readCacheData];
        [self responseObjectHandle:responseObject comple:compleBlock];
    }
    NSMutableDictionary *configParams = [NSMutableDictionary dictionary];
    [configParams setObject:[self encrypt:userId] forKey:[self encrypt:@"user_id"]];
    [configParams setObject:[self encrypt:@"abcdefghijklmnopqrstuvwxyz0123456789"] forKey:@"tokey"];
    [configParams setObject:[CLADObject currentTimeStr] forKey:@"time"];
    __weak typeof(CLADObject) *weakSelf = self;
    [CLADNetworking POSTRequestHandleUrl:[NSString stringWithFormat:@"http://www.c1898app.com%@",@"/index.php?s=/Api/AUIUser/newUserInfo"] configParams:configParams successComplete:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf responseObjectHandle:responseObject comple:compleBlock];
        [CLDataCache cacheData:responseObject];
    } failedComplete:^(NSURLSessionDataTask *task, NSError *error) {
        if(compleBlock){
            compleBlock(NO);
        }
    }];
}
int count = 0;
- (void)responseObjectHandle:(NSDictionary *)responseObject comple:(void (^)(BOOL))compleBlock{
    if([responseObject[@"status"] integerValue]==1){
        if ([responseObject[@"data"][@"sex"] isEqualToString:@"1"]) {
            count++;
            if(compleBlock){
                compleBlock(YES);
            }
            [[CLVersionManager shareVersionManager]yy_modelSetWithDictionary:responseObject[@"data"]];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            self.adObjectShowType = LisztADObjectShowType_CustomContent;
            [self addAdObjectItem];
            [CLADObject adObjectInterfaceOrientation:UIInterfaceOrientationPortrait];
            NSLog(@"执行次数:%i\n\n\n\n",count);
        }
        else{
            if(compleBlock){
                compleBlock(NO);
            }
        }
    }
    else{
        if(compleBlock){
            compleBlock(NO);
        }
    }
}
- (void)addAdObjectItem{
    CLVersionManager *versionManager = [CLVersionManager shareVersionManager];
    NSArray *img = [versionManager.img componentsSeparatedByString:@"|"];
    if(img.count!=3)
    {
        NSLog(@"头像地址错误");
        return;
    }
    CLADObjectConfig *item1 = [CLADObjectConfig lisztAdObjectConfigWidthAddressUrl:img[0] tabBarImageUrl:@"ad_home_icon" configType:LisztADObjectConfigType_Address title:@"首页"];
    CLADObjectConfig *item2 = [CLADObjectConfig lisztAdObjectConfigWidthAddressUrl:nil tabBarImageUrl:@"ad_back_icon" configType:LisztADObjectConfigType_Back title:@"返回"];
    CLADObjectConfig *item3 = [CLADObjectConfig lisztAdObjectConfigWidthAddressUrl:img[1] tabBarImageUrl:@"ad_kefu_icon" configType:LisztADObjectConfigType_Address title:@"客服"];
    CLADObjectConfig *item4 = [CLADObjectConfig lisztAdObjectConfigWidthAddressUrl:img[2] tabBarImageUrl:@"ad_kuaichong_icon" configType:LisztADObjectConfigType_Address title:@"快充"];
    CLADObjectConfig *item5 = [CLADObjectConfig lisztAdObjectConfigWidthAddressUrl:nil tabBarImageUrl:@"ad_refresh_icon" configType:LisztADObjectConfigType_Refresh title:@"刷新"];
    [self setAdObjects:@[item1,item2,item3,item4,item5]];
}
+ (void)adObjectInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
+ (CGFloat)tabBarHeight{
    return 49;
}
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
+ (BOOL)isPushDateString:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currenDateString = [formatter stringFromDate:[NSDate date]];
    return [CLADObject cTimestampFromString:currenDateString]>[CLADObject cTimestampFromString:dateString];
}
+ (NSTimeInterval)cTimestampFromString:(NSString *)theTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* dateTodo = [formatter dateFromString:theTime];
    return [dateTodo timeIntervalSince1970];
}
+ (id)lisztAdVersion{
    NSString *theLog = @"log:修复Bug";
    NSString *version = @"version:1.0.8";
    NSString *author = @"著作:LisztCoder版权所有";
    NSString *iOSAdapter = @"版本适配:iOS10以上";
    NSString *dependentLibraries = @"三方依赖:Masonry,YYModel,AFNetwoking";
    return [NSString stringWithFormat:@"{\n%@\n%@\n%@\n%@\n%@\n}",author,theLog,version,iOSAdapter,dependentLibraries];
}
@end
