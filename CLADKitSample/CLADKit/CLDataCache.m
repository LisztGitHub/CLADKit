#import "CLDataCache.h"
@implementation CLDataCache
+ (instancetype)shareDataCache{
    static CLDataCache *dataCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCache = [self new];
    });
    return dataCache;
}
+ (void)cacheData:(NSDictionary *)data{
    if(!data.count){
        NSLog(@"缓存信息无效.未写入缓存数据");
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:CACHE_DATA_KEY];
}
+ (NSDictionary *)readCacheData{
    return [[NSUserDefaults standardUserDefaults]objectForKey:CACHE_DATA_KEY];
}
+ (BOOL)isCacheData{
    return [[self readCacheData] count];
}
@end
