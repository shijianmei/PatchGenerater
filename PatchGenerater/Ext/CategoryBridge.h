//
//  CategoryBridge.h
//  PatchGenerater
//
//  Created by jianmei on 2023/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryBridge : NSObject

+ (nullable NSString *)strFilePath:(NSString *)urlStr;

+ (nullable NSData *)AES128ParmEncryptWithKey:(NSString *)key iv:(NSString *)iv data:(NSData *)data;

+ (nullable NSData *)AES128ParmDecryptWithKey:(NSString *)key iv:(NSString *)iv data:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
