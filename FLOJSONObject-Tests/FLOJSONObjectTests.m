//
//  FLOJSONObjectTests.m
//  FLOJSONObjectTests
//
//  Created by Florian Schliep on 03.05.17.
//
//

#import <XCTest/XCTest.h>
#import "FLOJSONObject.h"

@interface FLOJSONObjectTests : XCTestCase

@end

@implementation FLOJSONObjectTests

- (void)testArray {
    NSData *data = [self jsonDataWithObject:@[ @"test1", @"test2", @42 ]];
    FLOJSONObject *object = [FLOJSONObject objectWithData:data options:kNilOptions error:nil];
    XCTAssertNotNil(object);
    XCTAssertNil(object.mutableArray);
    XCTAssertNil(object.dictionary);
    XCTAssertNil(object.mutableDictionary);
    XCTAssertNil(object.string);
    XCTAssertNil(object.number);
    XCTAssertNil(object.null);
    
    NSArray<FLOJSONObject *> *array = object.array;
    XCTAssertNotNil(array);
    
    XCTAssertEqual(array.count, 3);
    XCTAssertEqualObjects(array[0].string, @"test1");
    XCTAssertEqualObjects(array[1].string, @"test2");
    XCTAssertEqualObjects(array[2].number, @42);
    XCTAssertNil(array[1].number);
    XCTAssertNil(array[1].null);
    XCTAssertNil(array[2].string);
    XCTAssertNil(array[2].null);
    XCTAssertNil(array[2].dictionary);
}

- (void)testDictionary {
    NSData *data = [self jsonDataWithObject:@{ @"testString": @"testObject", @"testNum": @42 }];
    FLOJSONObject *object = [FLOJSONObject objectWithData:data options:kNilOptions error:nil];
    XCTAssertNotNil(object);
    XCTAssertNil(object.mutableDictionary);
    XCTAssertNil(object.array);
    XCTAssertNil(object.mutableArray);
    XCTAssertNil(object.string);
    XCTAssertNil(object.number);
    XCTAssertNil(object.null);
    
    NSDictionary<NSString *, FLOJSONObject *> *dict = object.dictionary;
    XCTAssertNotNil(dict);
    
    XCTAssertEqual(dict.count, 2);
    XCTAssertEqualObjects(dict[@"testString"].string, @"testObject");
    XCTAssertEqualObjects(dict[@"testNum"].number, @42);
    XCTAssertNil(dict[@"invalidKey"]);
    XCTAssertNil(dict[@"testString"].number);
    XCTAssertNil(dict[@"testString"].null);
    XCTAssertNil(dict[@"testNum"].string);
    XCTAssertNil(dict[@"testNum"].null);
}

- (void)testMutableArray {
    NSData *data = [self jsonDataWithObject:@[ @"foo", @42, [NSNull null] ]];
    FLOJSONObject *object = [FLOJSONObject objectWithData:data options:NSJSONReadingMutableContainers error:nil];
    XCTAssertNotNil(object.array);
    XCTAssertNotNil(object.mutableArray);
    XCTAssertNil(object.dictionary);
    XCTAssertNil(object.mutableDictionary);
    XCTAssertNil(object.string);
    XCTAssertNil(object.number);
    XCTAssertNil(object.null);
    
    NSMutableArray<FLOJSONObject *> *array = object.mutableArray;
    XCTAssertTrue([array isKindOfClass:[NSMutableArray class]]);
    
    XCTAssertEqual(array.count, 3);
    XCTAssertEqualObjects(array[0].string, @"foo");
    XCTAssertEqualObjects(array[1].number, @42);
    XCTAssertNotNil(array[2].null);
    XCTAssertNil(array[2].number);
    XCTAssertNil(array[2].string);
    XCTAssertNil(array[2].dictionary);
    XCTAssertNil(array[2].array);
}

- (void)testMutableDictionary {
    NSData *data = [self jsonDataWithObject:@{ @"testString": @"testObject", @"testNum": @42, @"testNull": [NSNull null] }];
    FLOJSONObject *object = [FLOJSONObject objectWithData:data options:NSJSONReadingMutableContainers error:nil];
    XCTAssertNotNil(object.dictionary);
    XCTAssertNotNil(object.mutableDictionary);
    XCTAssertNil(object.array);
    XCTAssertNil(object.mutableArray);
    XCTAssertNil(object.string);
    XCTAssertNil(object.number);
    XCTAssertNil(object.null);
    
    NSMutableDictionary<NSString *, FLOJSONObject *> *dict = object.mutableDictionary;
    XCTAssertTrue([dict isKindOfClass:[NSMutableDictionary class]]);
    
    XCTAssertEqual(dict.count, 3);
    XCTAssertEqualObjects(dict[@"testString"].string, @"testObject");
    XCTAssertEqualObjects(dict[@"testNum"].number, @42);
    XCTAssertNotNil(dict[@"testNull"].null);
    XCTAssertNil(dict[@"invalidKey"]);
    XCTAssertNil(dict[@"testString"].number);
    XCTAssertNil(dict[@"testString"].null);
    XCTAssertNil(dict[@"testNum"].string);
    XCTAssertNil(dict[@"testNum"].null);
    XCTAssertNil(dict[@"testNull"].number);
    XCTAssertNil(dict[@"testNull"].string);
}

- (void)testNestedGraphs {
    NSData *data = [self jsonDataWithObject:@{ @"count": @1, @"data": @[ @{ @"foo": @"bar", @"idx": @42, @"values": @[@1, @2, @3] } ] }];
    FLOJSONObject *object = [FLOJSONObject objectWithData:data options:kNilOptions error:nil];
    
    NSDictionary<NSString *, FLOJSONObject *> *root = object.dictionary;
    XCTAssertEqual(root.count, 2);
    XCTAssertEqualObjects(root[@"count"].number, @1);
    
    NSArray<FLOJSONObject *> *jsonData = root[@"data"].array;
    XCTAssertEqual(jsonData.count, 1);
    
    NSDictionary<NSString *, FLOJSONObject *> *firstData = jsonData.firstObject.dictionary;
    XCTAssertEqual(firstData.count, 3);
    XCTAssertEqualObjects(firstData[@"foo"].string, @"bar");
    XCTAssertEqualObjects(firstData[@"idx"].number, @42);
    
    NSArray<FLOJSONObject *> *values = firstData[@"values"].array;
    XCTAssertEqual(values.count, 3);
    XCTAssertEqualObjects(values[0].number, @1);
    XCTAssertEqualObjects(values[1].number, @2);
    XCTAssertEqualObjects(values[2].number, @3);
}

- (void)testFragments {
    NSData *stringData = [self jsonDataWithFragmentObject:@"foo"];
    FLOJSONObject *stringObject = [FLOJSONObject objectWithData:stringData options:NSJSONReadingAllowFragments error:nil];
    XCTAssertEqualObjects(stringObject.string, @"foo");
    XCTAssertNil(stringObject.array);
    XCTAssertNil(stringObject.dictionary);
    XCTAssertNil(stringObject.number);
    
    NSData *numberData = [self jsonDataWithFragmentObject:@42];
    FLOJSONObject *numberObject = [FLOJSONObject objectWithData:numberData options:NSJSONReadingAllowFragments error:nil];
    XCTAssertEqualObjects(numberObject.number, @42);
    XCTAssertNil(numberObject.string);
    XCTAssertNil(numberObject.array);
    XCTAssertNil(numberObject.dictionary);
    
    NSData *nullData = [self jsonDataWithFragmentObject:[NSNull null]];
    FLOJSONObject *nullObject = [FLOJSONObject objectWithData:nullData options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(nullObject.null);
    XCTAssertNil(nullObject.string);
    XCTAssertNil(nullObject.number);
    XCTAssertNil(nullObject.array);
    XCTAssertNil(nullObject.dictionary);
}

- (void)testInvalidData {
    XCTAssertNil([FLOJSONObject objectWithData:[self jsonDataWithFragmentObject:@"foo"] options:kNilOptions error:nil]);
    XCTAssertNil([FLOJSONObject objectWithData:[self jsonDataWithFragmentObject:@42] options:kNilOptions error:nil]);
    
    NSError *error = nil;
    FLOJSONObject *object1 = [FLOJSONObject objectWithData:[NSData new] options:kNilOptions error:&error];
    XCTAssertNil(object1);
    XCTAssertNotNil(error);
}

#pragma mark - Helpers

- (NSData *)jsonDataWithObject:(id)object {
    return [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:nil];
}

- (NSData *)jsonDataWithFragmentObject:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return [[NSString stringWithFormat:@"\"%@\"", object] dataUsingEncoding:NSUTF8StringEncoding];
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [[object stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return [@"null" dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

@end
