#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,LisztADObjectConfigType) {
    LisztADObjectConfigType_Address,
    LisztADObjectConfigType_Refresh,
    LisztADObjectConfigType_Back
};
@interface CLADObjectConfig : NSObject
@property (nonatomic, readwrite, copy) NSString *addressUrl;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *tabBarImageUrl;
@property (nonatomic, readwrite, assign) LisztADObjectConfigType configType;
+ (instancetype)lisztAdObjectConfigWidthAddressUrl:(NSString *)address tabBarImageUrl:(NSString *)tabBarImageUrl configType:(LisztADObjectConfigType)configType title:(NSString *)title;
@end
