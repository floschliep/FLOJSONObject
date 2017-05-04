//
//  FLOJSONObject.h
//  FLOJSONObject
//
//  Created by Florian Schliep on 03.05.17.
//
//

#import <Foundation/Foundation.h>

@interface FLOJSONObject : NSObject

@property (nullable, nonatomic, readonly) NSArray<FLOJSONObject *> *array;
@property (nullable, nonatomic, readonly) NSMutableArray<FLOJSONObject *> *mutableArray;
@property (nullable, nonatomic, readonly) NSDictionary<NSString *, FLOJSONObject *> *dictionary;
@property (nullable, nonatomic, readonly) NSMutableDictionary<NSString *, FLOJSONObject *> *mutableDictionary;
@property (nullable, nonatomic, readonly) NSString *string;
@property (nullable, nonatomic, readonly) NSNumber *number;
@property (nullable, nonatomic, readonly) NSNull *null;

+ (nullable instancetype)objectWithData:(NSData * _Nonnull)data options:(NSJSONReadingOptions)options error:(NSError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithData:(NSData * _Nonnull)data options:(NSJSONReadingOptions)options error:(NSError * _Nullable * _Nullable)error NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_UNAVAILABLE;

@end
