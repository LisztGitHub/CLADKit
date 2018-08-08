#import <Foundation/Foundation.h>
@interface CLVersionManager : NSObject
@property (nonatomic, strong) NSDictionary *versionData;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *complete;
@property (nonatomic, copy) NSString *emial;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *user_id;
+ (instancetype)shareVersionManager;
@end
