# FLOJSONObject

**This is a proof of concept and not a full-featured library.**

`FLOJSONObject` provides a type-safe wrapper around `NSJSONSerialization` in Objective-C. Yes, you read correctly, Objective-C. This is not intended to be used with Swift, there are other, much better solutions for Swift.

`FLOJSONObject` attempts to remove the `isKindOfClass`-hell from your code by wrapping all objects parsed by `NSJSONSerialization` inside a `FLOJSONObject` object.
The `FLOJSONObject` class allows you to access JSON objects using the following properties:

```
@property (nullable, readonly) NSArray<FLOJSONObject *> *array;
@property (nullable, readonly) NSMutableArray<FLOJSONObject *> *mutableArray;
@property (nullable, readonly) NSDictionary<NSString *, FLOJSONObject *> *dictionary;
@property (nullable, readonly) NSMutableDictionary<NSString *, FLOJSONObject *> *mutableDictionary;
@property (nullable, readonly) NSString *string;
@property (nullable, readonly) NSNumber *number;
@property (nullable, readonly) NSNull *null;
```

When accessing a property, the class checks whether the JSON object matches the desired type or not and returns either the object or `nil`.

## Example

```
NSData *data = … // JSON: { "message": "Hello", "timestamp": 123456789 }
FLOJSONObject *object = [FLOJSONObject objectWithData:data options:kNilOptions error:nil];
NSDictionary<NSString *, FLOJSONObject *> *json = object.dictionary;
NSString *message = json[@"message"].string;
NSNumber *timestamp = json[@"timestamp"].number;
```
Even if the JSON didn't match the scheme you expected, not a single `unrecognized selector sent to instance` would be thrown.

## Installation

Just drop the two files from the `Source` folder into your project. The Xcode project in this repository is only used for testing.

## Contact

Florian Schliep

- http://github.com/floschliep
- http://twitter.com/floschliep
- http://floschliep.com

## License

FLOJSONObject is available under the MIT license. See the LICENSE.txt file for more info.
