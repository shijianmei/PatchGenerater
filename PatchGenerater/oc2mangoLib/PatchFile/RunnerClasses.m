//
//  ORunner.m
//  MangoFix
//
//  Created by jianmei on 2020/4/26.
//  Copyright © 2020 yongpengliang. All rights reserved.
//

#import "RunnerClasses.h"
@implementation ORTypeSpecial
+ (instancetype)specialWithType:(TypeKind)type name:(NSString *)name{
    ORTypeSpecial *s = [ORTypeSpecial new];
    s.type = type;
    s.name = name;
    return s;
}
@end
@implementation ORVariable
+ (instancetype)copyFromVar:(ORVariable *)var{
    ORVariable *new = [[self class] new];
    new.ptCount = var.ptCount;
    new.varname = var.varname;
    new.isBlock = var.isBlock;
    return new;
}
@end
@implementation ORTypeVarPair
- (NSUInteger)hash{
    return [self.var.varname hash];
}
- (BOOL)isEqual:(id)object{
    return [self hash] == [object hash];
}
@end
@implementation ORFuncVariable
@end
@implementation ORFuncDeclare
- (BOOL)isBlockDeclare{
    return self.funVar.isBlock;
}
@end
@implementation ORNode
@end
@implementation ORValueExpression
@end

@implementation ORIntegerValue
@end

@implementation ORUIntegerValue: ORNode
@end

@implementation ORDoubleValue
@end

@implementation ORBoolValue
@end

@interface ORMethodCall()
@property (nonatomic, copy)NSString *selectorName;
@end
@implementation ORMethodCall
- (NSString *)selectorName{
    if (_selectorName == nil){
        NSMutableArray *names = [self.names mutableCopy];
        if (self.values.count >= 1){
            [names addObject:@""];
        }
        _selectorName = [names componentsJoinedByString:@":"];
    }
    return _selectorName;
}
@end
@implementation ORCFuncCall
@end

@implementation ORScopeImp
- (instancetype)init
{
    self = [super init];
    self.statements = [NSMutableArray array];
    return self;
}
- (void)addStatements:(id)statements{
    if ([statements isKindOfClass:[NSArray class]]) {
        [self.statements addObjectsFromArray:statements];
    }else{
        [self.statements addObject:statements];
    }
}
- (void)copyFromImp:(ORScopeImp *)imp{
    self.statements = imp.statements;
}

@end
@implementation ORFunctionImp
- (instancetype)normalFunctionImp{
    ORFunctionImp *imp = [ORFunctionImp new];
    imp.declare = [self.declare copy];
    imp.scopeImp = self.scopeImp;
    imp.declare.funVar.isBlock = NO;
    return imp;
}
- (BOOL)isBlockImp{
    return self.declare.funVar.isBlock;
}
@end
@implementation ORSubscriptExpression
@end
@implementation ORAssignExpression
- (NSString *)varname{
    if ([self.value isKindOfClass:[ORValueExpression class]]) {
        return [(ORValueExpression *)self.value value];
    }
    return nil;
}
@end
@implementation ORDeclareExpression
@end
@implementation ORUnaryExpression
@end
@implementation ORBinaryExpression
@end
@implementation ORTernaryExpression
- (instancetype)init
{
    self = [super init];
    self.values = [NSMutableArray array];
    return self;
}
@end

@implementation ORIfStatement
@end
@implementation ORWhileStatement
@end
@implementation ORDoWhileStatement
@end
@implementation ORCaseStatement
@end
@implementation ORSwitchStatement
- (instancetype)init
{
    self = [super init];
    self.cases = [NSMutableArray array];
    return self;
}
@end
@implementation ORForStatement
@end
@implementation ORForInStatement
@end
@implementation ORReturnStatement
@end
@implementation ORBreakStatement
@end
@implementation ORContinueStatement
@end
@implementation ORPropertyDeclare
- (MFPropertyModifier)modifier{
    NSDictionary *cache = @{
        @"strong":@(MFPropertyModifierMemStrong),
        @"weak":@(MFPropertyModifierMemWeak),
        @"copy":@(MFPropertyModifierMemCopy),
        @"assign":@(MFPropertyModifierMemAssign),
        @"nonatomic":@(MFPropertyModifierNonatomic),
        @"atomic":@(MFPropertyModifierAtomic)
    };
    uint32_t value = 0;
    for (NSString *keyword in self.keywords) {
        NSNumber *keywordValue = cache[keyword];
        if (keywordValue) {
            value = value | keywordValue.unsignedIntValue;
        }
    }
    return value;
}
- (NSUInteger)hash{
    return [self.var hash];
}
- (BOOL)isEqual:(ORPropertyDeclare *)object{
    return [self hash] == [object hash];
}
@end
@interface ORMethodDeclare()
@property (nonatomic, copy)NSString *selectorName;
@end
@implementation ORMethodDeclare
- (NSString *)selectorName{
    if (_selectorName == nil){
        NSMutableArray *names = [self.methodNames mutableCopy];
        if (self.parameterNames.count >= 1){
            [names addObject:@""];
        }
        _selectorName = [names componentsJoinedByString:@":"];
    }
    return _selectorName;
}
@end
@implementation ORMethodImplementation
- (NSUInteger)hash{
    return [[self.declare selectorName] stringByAppendingFormat:@"%d",self.declare.isClassMethod].hash;
}
- (BOOL)isEqual:(id)object{
    return [self hash] == [object hash];
}
@end
@implementation ORClass
+ (instancetype)classWithClassName:(NSString *)className{
    ORClass *class = [ORClass new];
    class.className = className;
    return class;
}
- (instancetype)init
{
    self = [super init];
    self.properties  = [NSMutableArray array];
    self.privateVariables = [NSMutableArray array];
    self.properties = [NSMutableArray array];
    self.methods = [NSMutableArray array];
    
    return self;
}
- (void)merge:(ORClass *)target key:(nonnull NSString *)key{
    NSMutableSet *sourceSet = [NSMutableSet setWithArray:[self valueForKey:key]];
    NSMutableSet *compredSet = [NSMutableSet setWithArray:[target valueForKey:key]];
    [compredSet unionSet:sourceSet];
    [compredSet minusSet:sourceSet];
    NSMutableArray *array = [self valueForKey:key];
    [array addObjectsFromArray:compredSet.allObjects];
}
@end
@implementation ORProtocol
+ (instancetype)protcolWithProtcolName:(NSString *)protcolName{
    ORProtocol *protcol = [ORProtocol new];
    protcol.protcolName = protcolName;
    return protcol;
}
- (instancetype)init
{
    self = [super init];
    self.properties  = [NSMutableArray array];
    self.properties = [NSMutableArray array];
    self.methods = [NSMutableArray array];
    return self;
}
@end

@implementation ORStructExpressoin

@end

@implementation OREnumExpressoin

@end

@implementation ORTypedefExpressoin

@end
