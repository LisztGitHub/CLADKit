#import "CLADNetworking.h"
#import <AFNetworking.h>
#import "NSObject+Encrypt3DES.h"
@implementation CLADNetworking
+ (void)POSTRequestHandleUrl:(NSString *)urlString configParams:(NSDictionary *)params successComplete:(void (^)(NSURLSessionDataTask *, id))successCompleteBlock failedComplete:(void (^)(NSURLSessionDataTask *, NSError *))failereCompleteBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval = 10.f;
    [session POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        result = LisztJSONObjectByRemovingKeysWithNullValues([self decrypt:result[@"data"]], NSJSONReadingMutableLeaves);
        result = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
        if(successCompleteBlock){
            successCompleteBlock(task,result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failereCompleteBlock){
            failereCompleteBlock(task,error);
        }
    }];
}
static id LisztJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:LisztJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = LisztJSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    return JSONObject;
}
@end
