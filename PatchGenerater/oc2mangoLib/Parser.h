//
//  Parser.h
//  oc2mangoLib
//
//  Created by jianmei on 2019/4/24.
//

#import <Foundation/Foundation.h>
#import "AST.h"
#import "ORPatchFile.h"
#import "BinaryPatchHelper.h"
#define OCParser [Parser shared]
NS_ASSUME_NONNULL_BEGIN

@interface CodeSource: NSObject
@property(nonatomic,nullable,copy)NSString *source;
@property(nonatomic,nullable,copy)NSString *filePath;
- (instancetype)initWithFilePath:(NSString *)filePath;
- (instancetype)initWithSource:(NSString *)source;
@end

@interface Parser : NSObject
@property(nonatomic,nonnull,strong)NSLock *lock;
@property(nonatomic,nullable,copy)NSString *error;
@property(nonatomic,nullable,copy)NSAttributedString *errorAttributedString;
@property(nonatomic,nullable,strong)CodeSource *source;
+ (nonnull instancetype)shared;
- (AST *)parseCodeSource:(CodeSource *)source;
- (AST *)parseSource:(nullable NSString *)source;
- (BOOL)isSuccess;

-(void)onParserError:(const char *)error;

@end
NS_ASSUME_NONNULL_END
