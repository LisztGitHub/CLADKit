#import <Foundation/Foundation.h>
@interface NSObject (Encrypt3DES)
- (NSString*)encrypt:(NSString*)plainText;
- (NSData*)decrypt:(NSString*)encryptText;
@end
