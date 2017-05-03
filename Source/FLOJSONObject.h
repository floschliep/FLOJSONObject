//
//  FLOJSONObject.h
//  FLOJSONObject
//
//  Created by Florian Schliep on 03.05.17.
//
//

#import <Foundation/Foundation.h>

@interface FLOJSONObject : NSObject

@property (nullable, readonly) NSArray<FLOJSONObject *> *array;
@property (nullable, readonly) NSMutableArray<FLOJSONObject *> *mutableArray;
@property (nullable, readonly) NSDictionary<NSString *, FLOJSONObject *> *dictionary;
@property (nullable, readonly) NSMutableDictionary<NSString *, FLOJSONObject *> *mutableDictionary;
@property (nullable, readonly) NSString *string;
@property (nullable, readonly) NSMutableString *mutableString;
@property (nullable, readonly) NSNumber *number;
@property (nullable, readonly) NSNull *null;

+ (nullable instancetype)objectWithData:(NSData * _Nonnull)data options:(NSJSONReadingOptions)options error:(NSError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithData:(NSData * _Nonnull)data options:(NSJSONReadingOptions)options error:(NSError * _Nullable * _Nullable)error NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_UNAVAILABLE;

@end
