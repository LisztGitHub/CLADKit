#import <Foundation/Foundation.h>
#import "LisztADHeader.h"
@interface CLDataCache : NSObject
+ (instancetype)shareDataCache;
+ (void)cacheData:(NSDictionary *)data;
+ (NSDictionary *)readCacheData;
+ (BOOL)isCacheData;
@end
