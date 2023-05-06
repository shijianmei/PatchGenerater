//
//  CategoryBridge.m
//  PatchGenerater
//
//  Created by jianmei on 2023/3/5.
//

#import "CategoryBridge.h"
#import "NSData+AES.h"
#import "NSString+URL.h"

@implementation CategoryBridge

+ (nullable NSString *)strFilePath:(NSString *)urlStr {
    return [NSString filePathFromURL:urlStr];
}

+ (nullable NSData *)AES128ParmEncryptWithKey:(NSString *)key iv:(NSString *)iv data:(NSData *)data {
    return [data AES128ParmEncryptWithKey:key iv:iv];
}

+ (nullable NSData *)AES128ParmDecryptWithKey:(NSString *)key iv:(NSString *)iv data:(NSData *)data {
    return  [data AES128ParmDecryptWithKey:key iv:iv];
}


@end
