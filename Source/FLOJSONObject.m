//
//  FLOJSONObject.m
//  FLOJSONObject
//
//  Created by Florian Schliep on 03.05.17.
//
//

#import "FLOJSONObject.h"

#pragma mark - Class Extension

@interface FLOJSONObject () {
    id _underlyingObject;
    id _mappedObject;
}

- (instancetype)initWithUnderlyingObject:(id)object NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Foundation Extensions

@interface NSArray<__covariant ObjectType> (FLOJSONObject)

- (id)flo_map:(id (^)(ObjectType))predicate;

@end

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (FLOJSONObject)

- (id)flo_mapObjects:(id (^)(KeyType, ObjectType))predicate;

@end

#pragma mark - Implementation

@implementation FLOJSONObject

+ (instancetype)objectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError *__autoreleasing  _Nullable *)error {
    return [[self alloc] initWithData:data options:opt error:error];
}

- (instancetype)initWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError *__autoreleasing  _Nullable *)error {
    id object = [NSJSONSerialization JSONObjectWithData:data options:opt error:error];
    if (!object) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _underlyingObject = object;
    }
    
    return self;
}

- (instancetype)initWithUnderlyingObject:(id)object {
    self = [super init];
    if (self) {
        _underlyingObject = object;
    }
    
    return self;
}

#pragma mark - Properties

- (NSArray *)array {
    if ([_mappedObject isKindOfClass:[NSMutableArray class]]) {
        _mappedObject = [_mappedObject copy];
        return _mappedObject;
    }
    if ([_mappedObject isKindOfClass:[NSArray class]]) {
        return _mappedObject;
    }
    if (![self verifyClass:[NSArray class]]) {
        return nil;
    }
    _mappedObject = [(NSArray *)_underlyingObject flo_map:^id(id object) {
        return [[FLOJSONObject alloc] initWithUnderlyingObject:object];
    }];
    _underlyingObject = nil;
    
    return _mappedObject;
}

- (NSMutableArray *)mutableArray {
    if (!_mappedObject || ![_mappedObject isKindOfClass:[NSArray class]]) {
        if (![self verifyClass:[NSMutableArray class]]) {
            return nil;
        }
    }
    
    return [self.array mutableCopy];
}

- (NSDictionary<NSString *,FLOJSONObject *> *)dictionary {
    if ([_mappedObject isKindOfClass:[NSMutableDictionary class]]) {
        _mappedObject = [_mappedObject copy];
        return _mappedObject;
    }
    if ([_mappedObject isKindOfClass:[NSDictionary class]]) {
        return _mappedObject;
    }
    if (![self verifyClass:[NSDictionary class]]) {
        return nil;
    }
    _mappedObject = [(NSDictionary *)_underlyingObject flo_mapObjects:^id(NSString *key, id obj) {
        return [[FLOJSONObject alloc] initWithUnderlyingObject:obj];
    }];
    _underlyingObject = nil;
    
    return _mappedObject;
}

- (NSMutableDictionary<NSString *,FLOJSONObject *> *)mutableDictionary {
    if (!_mappedObject || ![_mappedObject isKindOfClass:[NSDictionary class]]) {
        if (![self verifyClass:[NSMutableDictionary class]]) {
            return nil;
        }
    }
    
    return [self.dictionary mutableCopy];
}

- (NSString *)string {
    if (![self verifyClass:[NSString class]]) {
        return nil;
    }
    
    return _underlyingObject;
}

- (NSNumber *)number {
    if (![self verifyClass:[NSNumber class]]) {
        return nil;
    }
    
    return _underlyingObject;
}

- (NSNull *)null {
    if (![self verifyClass:[NSNull class]]) {
        return nil;
    }
    
    return _underlyingObject;
}

#pragma mark - Helpers

- (BOOL)verifyClass:(Class)class {
    return [_underlyingObject isKindOfClass:class];
}

@end

#pragma mark - Foundation Extensions Implementation

@implementation NSArray (FLOJSONObject)

- (id)flo_map:(id (^)(id))predicate {
    NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mappedArray addObject:predicate(obj)];
    }];
    
    return [mappedArray copy];
}

@end

@implementation NSDictionary (FLOJSONObject)

- (id)flo_mapObjects:(id (^)(id, id))predicate {
    NSMutableDictionary *mappedDict = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        mappedDict[key] = predicate(key, self[key]);
    }];
    
    return [mappedDict copy];
}

@end
