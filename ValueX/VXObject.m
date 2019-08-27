//
//  VXObject.m
//  ValueX
//
//  Created by xaoxuu on 2019/8/27.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

#import "VXObject.h"
#import "NSObject+ValueX.h"

inline VXObject *ValueX(id obj) {
    if ([obj isKindOfClass:NSData.class] || [obj isKindOfClass:NSArray.class] || [obj isKindOfClass:NSDictionary.class]) {
        return [VXObject vxWithJsonWritingOptions:NSJSONWritingPrettyPrinted object:^id _Nonnull(NSError * _Nullable __autoreleasing * _Nullable error) {
            return obj;
        }];
    } else {
        return [VXObject vxWithIdResult:^id _Nonnull(NSError * _Nullable __autoreleasing * _Nullable error) {
            return obj;
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

static inline id transformValue(id value, VXClass toClass, NSError **error) {
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
            id ret = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
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
            } else {
                // NSArray => NSSet
                return [NSSet setWithArray:value];
            }
        } else if ([value isKindOfClass:NSSet.class]) {
            if (toClass == VXSet) {
                return value;
            } else {
                // NSSet => NSArray
                return arr;
            }
        }
        if (toClass == VXData || toClass == VXString) {
            // => NSData/NSString
            if ([NSJSONSerialization isValidJSONObject:arr]) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:error];
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
                NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:error];
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
            id ret = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
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

/**
 空的结果（失败，未知错误信息）
 
 @param path 路径
 @return 结果
 */
+ (instancetype)vxWithPath:(NSString *)path{
    return [[self alloc] initWithPath:path];
}
- (instancetype)initWithPath:(NSString *)path{
    if (self = [super init]) {
        _path = path;
    }
    return self;
}

/**
 bool类型的结果
 
 @param path 路径
 @param callback 回调
 @return 结果
 */
+ (instancetype)vxWithPath:(NSString *)path boolResult:(BOOL (^)(NSError **error))callback{
    return [[self alloc] initWithPath:path boolResult:callback];
}
- (instancetype)initWithPath:(NSString *)path boolResult:(BOOL (^)(NSError **error))callback{
    if (self = [self initWithPath:path]) {
        NSError *error = nil;
        if (callback) {
            _isSuccess = callback(&error);
            _error = error;
        }
    }
    return self;
}

/**
 id类型的结果
 
 @param path 路径
 @param callback 回调
 @return 结果
 */
+ (instancetype)vxWithPath:(NSString *)path idResult:(id (^)(NSError *__autoreleasing *))callback{
    return [[self alloc] initWithPath:path idResult:callback];
}
- (instancetype)initWithPath:(NSString *)path idResult:(id (^)(NSError *__autoreleasing *))callback{
    if (self = [self initWithIdResult:callback]) {
        _path = path;
        NSError *error = nil;
        if (callback) {
            _value = callback(&error);
            _error = error;
            _isSuccess = !error;
        }
    }
    return self;
}
+ (instancetype)vxWithIdResult:(id  _Nonnull (^)(NSError * _Nullable __autoreleasing * _Nullable))callback{
    return [[self alloc] initWithIdResult:callback];
}
- (instancetype)initWithIdResult:(id  _Nonnull (^)(NSError * _Nullable __autoreleasing * _Nullable))callback{
    if (self = [super init]) {
        NSError *error = nil;
        if (callback) {
            _value = callback(&error);
            _error = error;
            _isSuccess = !error;
        }
    }
    return self;
}
+ (instancetype)vxWithJsonWritingOptions:(NSJSONWritingOptions)opt object:(id  _Nonnull (^)(NSError * _Nullable __autoreleasing * _Nullable))callback{
    return [[self alloc] initWithJsonObject:opt object:callback];
}
- (instancetype)initWithJsonObject:(NSJSONWritingOptions)opt object:(id  _Nonnull (^)(NSError * _Nullable __autoreleasing * _Nullable))callback{
    if (self = [super init]) {
        NSError *error = nil;
        if (callback) {
            _value = callback(&error);
            _error = error;
            _isSuccess = !error;
        }
    }
    return self;
}
+ (instancetype)vxWithJsonReadingOptions:(NSJSONReadingOptions)opt data:(NSData *(^)(NSError **error))callback{
    return [[self alloc] initWithJsonReadingOptions:opt data:callback];
}

- (instancetype)initWithJsonReadingOptions:(NSJSONReadingOptions)opt data:(NSData *(^)(NSError **error))callback{
    if (self = [super init]) {
        NSError *error = nil;
        if (callback) {
            _value = callback(&error);
            _error = error;
            _isSuccess = !error;
        }
    }
    return self;
}

- (NSString *)stringValue {
    return [self transform:VXString];
}
- (NSNumber *)numberValue {
    return [self transform:VXNumber];
}
- (NSArray *)arrayValue {
    return [self transform:VXArray];
}
- (NSSet *)setValue {
    return [self transform:VXSet];
}
- (NSDictionary *)dictionaryValue {
    return [self transform:VXDictionary];
}
- (NSData *)dataValue {
    return [self transform:VXData];
}

- (id)transform:(VXClass)toClass {
    NSError *error = nil;
    id result = transformValue(self.value, toClass, &error);
    _error = error;
    _isSuccess = !error;
    return result;
}

// MARK: - 解析

/**
 操作完成的回调，此回调必然执行。
 
 @param callback 回调
 @return 结果
 */
- (instancetype)didComplete:(void (^)(BOOL success))callback{
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

@end
