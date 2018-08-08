#import <Foundation/Foundation.h>
@interface CLADNetworking : NSObject
+ (void)POSTRequestHandleUrl:(NSString *)urlString configParams:(NSDictionary *)params successComplete:(void (^)(NSURLSessionDataTask *task, id responseObject))successCompleteBlock failedComplete:(void (^)(NSURLSessionDataTask *task, NSError *error))failereCompleteBlock;
@end
