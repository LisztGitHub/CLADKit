#import "CLVersionManager.h"
@implementation CLVersionManager
+ (instancetype)shareVersionManager{
    static CLVersionManager *versionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        versionManager = [self new];
    });
    return versionManager;
}
@end
