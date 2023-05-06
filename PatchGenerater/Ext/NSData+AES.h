//
//  NSData+AES.h
//  OC2PatchTool
//
//  Created by jianmei on 2023/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES)

- (nullable NSData *)AES128ParmEncryptWithKey:(NSString *)key iv:(NSString *)iv;

- (nullable NSData *)AES128ParmDecryptWithKey:(NSString *)key iv:(NSString *)iv;

@end

NS_ASSUME_NONNULL_END
