#import "CLCoreStatus.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
static NSString *const CoreStatusChangedNoti = @"CoreStatusChangedNoti";
@interface CLCoreStatus ()
@property (nonatomic,strong) NSArray *technology2GArray;
@property (nonatomic,strong) NSArray *technology3GArray;
@property (nonatomic,strong) NSArray *technology4GArray;
@property (nonatomic,strong) NSArray *coreNetworkStatusStringArray;
@property (nonatomic,strong) CLReachability *reachability;
@property (nonatomic,strong) CTTelephonyNetworkInfo *telephonyNetworkInfo;
@property (nonatomic,copy) NSString *currentRaioAccess;
@property (nonatomic,assign) BOOL isNoti;
@end
@implementation CLCoreStatus
HMSingletonM(CLCoreStatus)
+(void)initialize{
    CLCoreStatus *status = [CLCoreStatus sharedCoreStatus];
    status.telephonyNetworkInfo =  [[CTTelephonyNetworkInfo alloc] init];
}
+(CoreNetWorkStatus)currentNetWorkStatus{
    CLCoreStatus *status = [CLCoreStatus sharedCoreStatus];
    return [status statusWithRadioAccessTechnology];
}
+(NSString *)currentNetWorkStatusString{
    CLCoreStatus *status = [CLCoreStatus sharedCoreStatus];
    return status.coreNetworkStatusStringArray[[self currentNetWorkStatus]];
}
-(CLReachability *)reachability{
    if(_reachability == nil){
        _reachability = [CLReachability reachabilityForInternetConnection];
    }
    return _reachability;
}
-(CTTelephonyNetworkInfo *)telephonyNetworkInfo{
    if(_telephonyNetworkInfo == nil){
        _telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }
    return _telephonyNetworkInfo;
}
-(NSString *)currentRaioAccess{
    if(_currentRaioAccess == nil){
        _currentRaioAccess = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    }
    return _currentRaioAccess;
}
+(void)beginNotiNetwork:(id<CoreStatusProtocol>)listener{
    CLCoreStatus *status = [CLCoreStatus sharedCoreStatus];
    if(status.isNoti){
        NSLog(@"CoreStatus已经处于监听中，请检查其他页面是否关闭监听！");
        [self endNotiNetwork:(id<CoreStatusProtocol>)listener];
    }
    [[NSNotificationCenter defaultCenter] addObserver:listener selector:@selector(coreNetworkChangeNoti:) name:CoreStatusChangedNoti object:status];
    [[NSNotificationCenter defaultCenter] addObserver:status selector:@selector(coreNetWorkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:status selector:@selector(coreNetWorkStatusChanged:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    [status.reachability startNotifier];
    status.isNoti = YES;
}
+(void)endNotiNetwork:(id<CoreStatusProtocol>)listener{
    CLCoreStatus *status = [CLCoreStatus sharedCoreStatus];
    if(!status.isNoti){
        NSLog(@"CoreStatus监听已经被关闭"); return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:status name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:status name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:listener name:CoreStatusChangedNoti object:status];
    status.isNoti = NO;
}
- (void)coreNetWorkStatusChanged:(NSNotification *)notification
{
    if (notification.name == CTRadioAccessTechnologyDidChangeNotification &&
        notification.object != nil) {
        self.currentRaioAccess = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    }
    NSDictionary *userInfo = @{@"currentStatusEnum":@([CLCoreStatus currentNetWorkStatus]),@"currentStatusString":[CLCoreStatus currentNetWorkStatusString]};
    [[NSNotificationCenter defaultCenter] postNotificationName:CoreStatusChangedNoti object:self userInfo:userInfo];
}
- (CoreNetWorkStatus)statusWithRadioAccessTechnology{
    CoreNetWorkStatus status = (CoreNetWorkStatus)[self.reachability currentReachabilityStatus];
    NSString *technology = self.currentRaioAccess;
    if (status == CoreNetWorkStatusWWAN &&
        technology != nil) {
        if ([self.technology2GArray containsObject:technology]){
            status = CoreNetWorkStatus2G;
        }else if ([self.technology3GArray containsObject:technology])
            status = CoreNetWorkStatus3G;
        else if ([self.technology4GArray containsObject:technology]){
            status = CoreNetWorkStatus4G;
        }
    }
    return status;
}
-(NSArray *)technology2GArray{
    if(_technology2GArray == nil){
        _technology2GArray = @[CTRadioAccessTechnologyEdge,CTRadioAccessTechnologyGPRS];
    }
    return _technology2GArray;
}
-(NSArray *)technology3GArray{
    if(_technology3GArray == nil){
        _technology3GArray = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMA1x,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    }
    return _technology3GArray;
}
-(NSArray *)technology4GArray{
    if(_technology4GArray == nil){
        _technology4GArray = @[CTRadioAccessTechnologyLTE];
    }
    return _technology4GArray;
}
-(NSArray *)coreNetworkStatusStringArray{
    if(_coreNetworkStatusStringArray == nil){
        _coreNetworkStatusStringArray = @[@"无网络",@"Wifi",@"蜂窝网络",@"2G",@"3G",@"4G",@"未知网络"];
    }
    return _coreNetworkStatusStringArray;
}
+(BOOL)isWifiEnable{
    return [self currentNetWorkStatus] == CoreNetWorkStatusWifi;
}
+(BOOL)isNetworkEnable{
    CoreNetWorkStatus networkStatus = [self currentNetWorkStatus];
    return networkStatus!=CoreNetWorkStatusUnkhow && networkStatus != CoreNetWorkStatusNone;
}
+(BOOL)isHighSpeedNetwork{
    CoreNetWorkStatus networkStatus = [self currentNetWorkStatus];
    return networkStatus == CoreNetWorkStatus3G || networkStatus == CoreNetWorkStatus4G || networkStatus == CoreNetWorkStatusWifi;
}
@end
