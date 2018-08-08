#ifndef CoreStatus_CoreStatusProtocol_h
#define CoreStatus_CoreStatusProtocol_h
#import "CoreNetworkStatus.h"
@protocol CoreStatusProtocol <NSObject>
@property (nonatomic,assign) NetworkStatus currentStatus;
@optional
-(void)coreNetworkChangeNoti:(NSNotification *)noti;
@end
#endif
