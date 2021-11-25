//
//  VXObject.m
//  ValueX
//
//  Created by xaoxuu on 2019/8/27.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

#import <VXObject.h>
#import <NSObject+ValueX.h>


NSErrorDomain const VXErrorDomain = @"https://xaoxuu.com/wiki/valuex";

inline VXObject *ValueX(id <VXConvertable>obj) {
    if ([obj respondsToSelector:@selector(vx)]) {
        return obj.vx;
    } else {
        return [VXObject objectWithObjectValue:^id _Nonnull(NSError * _Nullable __autoreleasing * _Nullable error) {
            *error = [NSError errorWithDomain:VXErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@不是有效的VXConvertable类型", NSStringFromClass(obj.class)]}];
            return nil;
        }];
    }
}

typedef NS_ENUM(NSUInteger, VXClass) {
    VXString,
    VXNumber,
    VXArray,
    VXSet,
    VXDictionary,
    VXData
};

static inline id transformValue(id value, VXClass toClass, NSError **error, NSJSONReadingOptions readingOpts, NSJSONWritingOptions writingOpts) {
    if ([value isKindOfClass:NSNull.class]) {
        return nil;
    } else if ([value isKindOfClass:NSString.class]) {
        // NSString =>
        NSString *str = value;
        if (toClass == VXString) {
            // => NSString
            return value;
        } else if (toClass == VXNumber) {
            // => NSNumber
            return NSSafeNumber(value);
        } else if (toClass == VXData) {
            // => NSData
            return [str dataUsingEncoding:NSUTF8StringEncoding];
        } else if (toClass == VXArray || toClass == VXSet || toClass == VXDictionary) {
            // => NSArray/NSSet/NSDictionary
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            id ret = [NSJSONSerialization JSONObjectWithData:data options:readingOpts error:error];
            if ([ret isKindOfClass:[NSArray class]]) {
                if (toClass == VXArray) {
                    // => NSArray
                    return ret;
                } else if (toClass == VXSet) {
                    // => NSSet
                    return [NSSet setWithArray:(NSArray *)ret];
                }
            } else if ([ret isKindOfClass:NSDictionary.class] && toClass == VXDictionary) {
                // => NSDictionary
                return ret;
            }
        }
    } else if ([value isKindOfClass:NSNumber.class]) {
        // NSNumber =>
        if (toClass == VXString) {
            // => NSString
            return NSSafeString(value);
        } else if (toClass == VXNumber) {
            // => NSNumber
            return value;
        } else if (toClass == VXData) {
            // => NSData
            NSString *str = NSSafeString(value);
            return [str dataUsingEncoding:NSUTF8StringEncoding];
        }
    } else if ([value isKindOfClass:NSArray.class] || [value isKindOfClass:NSSet.class]) {
        NSArray *arr = nil;
        if ([value isKindOfClass:NSArray.class]) {
            arr = value;
        } else if ([value isKindOfClass:NSSet.class]) {
            NSSet *set = value;
            arr = set.allObjects;
        }
        // NSArray/NSSet => NSSet/NSArray
        if ([value isKindOfClass:NSArray.class]) {
            if (toClass == VXArray) {
                return value;
            } else if (toClass == VXSet) {
                // NSArray => NSSet
                return [NSSet setWithArray:value];
            }
        } else if ([value isKindOfClass:NSSet.class]) {
            if (toClass == VXSet) {
                return value;
            } else if (toClass == VXArray) {
                // NSSet => NSArray
                return arr;
            }
        }
        if (toClass == VXData || toClass == VXString) {
            // => NSData/NSString
            if ([NSJSONSerialization isValidJSONObject:arr]) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:writingOpts error:error];
                if (toClass == VXData) {
                    return data;
                } else if (toClass == VXString) {
                    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                }
            }
        }
    } else if ([value isKindOfClass:NSDictionary.class]) {
        // NSDictionary =>
        if (toClass == VXDictionary) {
            return value;
        } else if (toClass == VXData || toClass == VXString) {
            // => NSData/NSString
            if ([NSJSONSerialization isValidJSONObject:value]) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:value options:writingOpts error:error];
                if (toClass == VXData) {
                    return data;
                } else if (toClass == VXString) {
                    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                }
            }
        }
    } else if ([value isKindOfClass:NSData.class]) {
        // NSData =>
        NSData *data = value;
        if (data == nil) {
            return nil;
        }
        if (toClass == VXString) {
            // => NSString
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        } else if (toClass == VXNumber) {
            // => NSNumber
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return NSSafeNumber(str);
        } else if (toClass == VXData) {
            // => NSData
            return data;
        } else if (toClass == VXArray || toClass == VXSet || toClass == VXDictionary) {
            // => NSArray/NSSet/NSDictionary
            id ret = [NSJSONSerialization JSONObjectWithData:data options:readingOpts error:error];
            if ([ret isKindOfClass:[NSArray class]]) {
                if (toClass == VXArray) {
                    // => NSArray
                    return ret;
                } else if (toClass == VXSet) {
                    // => NSSet
                    return [NSSet setWithArray:(NSArray *)ret];
                }
            } else if ([ret isKindOfClass:[NSDictionary class]] && toClass == VXDictionary) {
                // => NSDictionary
                return ret;
            }
        }
    }
    return nil;
}


@implementation VXObject

// MARK: 实例化

+ (instancetype)objectWithObjectValue:(id  _Nonnull (^)(NSError * _Nullable __autoreleasing * _Nullable))callback{
    return [[self alloc] initWithIdResult:callback];
}
- (instancetype)initWithIdResult:(id  _Nonnull (^)(NSError * _Nullable __autoreleasing * _Nullable))callback{
    if (self = [self init]) {
        NSError *error = nil;
        if (callback) {
            _value = callback(&error);
            [self updateConvertResult:error];
        }
    }
    return self;
}
+ (instancetype)objectWithJsonWritingOptions:(NSJSONWritingOptions)opts objectValue:(id  _Nonnull (^)(NSError * _Nullable __autoreleasing * _Nullable))callback{
    return [[self alloc] initWithJsonObject:opts objectValue:callback];
}
- (instancetype)initWithJsonObject:(NSJSONWritingOptions)opt objectValue:(id  _Nonnull (^)(NSError * _Nullable __autoreleasing * _Nullable))callback{
    if (self = [super init]) {
        NSError *error = nil;
        if (callback) {
            _value = callback(&error);
            [self updateConvertResult:error];
        }
    }
    return self;
}
+ (instancetype)objectWithJsonReadingOptions:(NSJSONReadingOptions)opts dataValue:(NSData *(^)(NSError **error))callback{
    return [[self alloc] initWithJsonReadingOptions:opts dataValue:callback];
}

- (instancetype)initWithJsonReadingOptions:(NSJSONReadingOptions)opts dataValue:(NSData *(^)(NSError **error))callback{
    if (self = [super init]) {
        NSError *error = nil;
        if (callback) {
            _value = callback(&error);
            [self updateConvertResult:error];
        }
    }
    return self;
}

- (NSString *)stringValue {
    return [self transform:VXString];
}
- (nullable NSString *)stringValueWithOptions:(NSJSONWritingOptions)opts {
    return [self transform:VXString readingOptions:kNilOptions writingOptions:opts];
}
- (NSString *)stringValueForPrint {
    if (@available(iOS 13.0, *)) {
        return [self stringValueWithOptions:NSJSONWritingPrettyPrinted|NSJSONWritingWithoutEscapingSlashes];
    } else {
        return [self stringValueWithOptions:NSJSONWritingPrettyPrinted];
    }
}
- (NSNumber *)numberValue {
    return [self transform:VXNumber];
}
- (NSArray *)arrayValue {
    return [self transform:VXArray];
}
- (NSArray *)arrayValueWithOptions:(NSJSONReadingOptions)opts {
    return [self transform:VXArray readingOptions:opts writingOptions:kNilOptions];
}
- (NSSet *)setValue {
    return [self transform:VXSet];
}
- (NSDictionary *)dictionaryValue {
    return [self transform:VXDictionary];
}
- (NSDictionary *)dictionaryValueWithOptions:(NSJSONReadingOptions)opts {
    return [self transform:VXDictionary readingOptions:opts writingOptions:kNilOptions];
}
- (NSData *)dataValue {
    return [self transform:VXData];
}

- (id)transform:(VXClass)toClass {
    return [self transform:toClass readingOptions:kNilOptions writingOptions:kNilOptions];
}

- (id)transform:(VXClass)toClass readingOptions:(NSJSONReadingOptions)readingOptions writingOptions:(NSJSONWritingOptions)writingOptions {
    NSError *error = nil;
    id result = transformValue(self.value, toClass, &error, readingOptions, writingOptions);
    [self updateConvertResult:error];
    return result;
}

// MARK: - 解析

/**
 操作完成的回调，此回调必然执行。
 
 @param callback 回调
 @return 结果
 */
- (instancetype)didComplete:(void (^)(BOOL isSuccess))callback{
    if (callback) {
        callback(self.isSuccess);
    }
    return self;
}

/**
 错误信息回调，只有当error有值时才会进入此回调
 
 @param callback 回调
 @return 结果
 */
- (instancetype)didError:(void (^)(NSError * _Nullable))callback{
    if (callback && self.error) {
        callback(self.error);
    }
    return self;
}

- (void)updateConvertResult:(NSError *)error {
    _isSuccess = !error;
    _error = error;
}

@end
