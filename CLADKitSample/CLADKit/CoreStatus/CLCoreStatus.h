#import <Foundation/Foundation.h>
#import "CLReachability.h"
#import "CoreNetWorkStatus.h"
#import "CoreStatusSingleton.h"
#import "CoreStatusProtocol.h"
@interface CLCoreStatus : NSObject
HMSingletonH(CLCoreStatus)
+(CoreNetWorkStatus)currentNetWorkStatus;
+(NSString *)currentNetWorkStatusString;
+(void)beginNotiNetwork:(id<CoreStatusProtocol>)listener;
+(void)endNotiNetwork:(id<CoreStatusProtocol>)listener;
+(BOOL)isWifiEnable;
+(BOOL)isNetworkEnable;
+(BOOL)isHighSpeedNetwork;
@end
