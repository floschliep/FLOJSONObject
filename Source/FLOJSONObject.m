//
//  FLOJSONObject.m
//  FLOJSONObject
//
//  Created by Florian Schliep on 03.05.17.
//
//

#import "FLOJSONObject.h"

#pragma mark - Class Extension

@interface FLOJSONObject ()

@property (strong) id underlyingObject;

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
    if (![self verifyClass:[NSArray class]]) {
        return nil;
    }
    
    return [(NSArray *)self.underlyingObject flo_map:^id(id object) {
        return [[FLOJSONObject alloc] initWithUnderlyingObject:object];
    }];
}

- (NSMutableArray *)mutableArray {
    if (![self verifyClass:[NSMutableArray class]]) {
        return nil;
    }
    
    return [self.array mutableCopy];
}

- (NSDictionary<NSString *,FLOJSONObject *> *)dictionary {
    if (![self verifyClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [(NSDictionary *)self.underlyingObject flo_mapObjects:^id(NSString *key, id obj) {
        return [[FLOJSONObject alloc] initWithUnderlyingObject:obj];
    }];
}

- (NSMutableDictionary<NSString *,FLOJSONObject *> *)mutableDictionary {
    if (![self verifyClass:[NSMutableDictionary class]]) {
        return nil;
    }
    
    return [self.dictionary mutableCopy];
}

- (NSString *)string {
    if (![self verifyClass:[NSString class]]) {
        return nil;
    }
    
    return self.underlyingObject;
}

- (NSMutableString *)mutableString {
    if (![self verifyClass:[NSMutableString class]]) {
        return nil;
    }
    
    return self.underlyingObject;
}

- (NSNumber *)number {
    if (![self verifyClass:[NSNumber class]]) {
        return nil;
    }
    
    return self.underlyingObject;
}

- (NSNull *)null {
    if (![self verifyClass:[NSNull class]]) {
        return nil;
    }
    
    return self.underlyingObject;
}

#pragma mark - Helpers

- (BOOL)verifyClass:(Class)class {
    return [self.underlyingObject isKindOfClass:class];
}

@end

#pragma mark - Foundation Extensions Implementation

@implementation NSArray (FLOJSONObject)

- (id)flo_map:(id (^)(id))predicate {
    NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        [mappedArray addObject:predicate(object)];
    }
    
    return [mappedArray copy];
}

@end

@implementation NSDictionary (FLOJSONObject)

- (id)flo_mapObjects:(id (^)(id, id))predicate {
    NSMutableDictionary *mappedDict = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (NSString *key in self.allKeys) {
        mappedDict[key] = predicate(key, self[key]);
    }
    
    return [mappedDict copy];
}

@end
