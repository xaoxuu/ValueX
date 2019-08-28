//
//  NSObject+ValueX.m
//  ValueX
//
//  Created by xaoxuu on 2019/8/27.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

#import "NSObject+ValueX.h"
#import "VXObject.h"

static inline BOOL isNullStr(id obj) {
    if ([obj isKindOfClass:NSString.class] && ((NSString *)obj).length <= 8) {
        static NSArray<NSString *> *nullArray = nil;
        if (!nullArray) {
            nullArray = @[@"<null>", @"(null)", @"null", @"<nil>", @"(nil)", @"nil", @"<nsnull>", @"(nsnull)", @"nsnull"];
        }
        if ([nullArray containsObject:((NSString *)obj).lowercaseString]) {
            return YES;
        }
    }
    return NO;
}

static inline NSNumber *numberValue(NSString *str) {
    NSString *lower = NSSafeString(str).lowercaseString;
    if (!lower.length) {
        return nil;
    }
    static NSCharacterSet *dot;
    if (!dot) {
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    }
    if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) {
        return @(YES);
    } else if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) {
        return @(NO);
    } else if ([str rangeOfCharacterFromSet:dot].location != NSNotFound) {
        return @(str.doubleValue);
    } else {
        return @(str.longLongValue);
    }
}

inline NSString *NSSafeString(id obj) {
    if ([obj isKindOfClass:NSString.class]) {
        if (isNullStr(obj)) {
            return nil;
        } else {
            return obj;
        }
    } else {
        if ([obj isKindOfClass:NSNumber.class]) {
            return ((NSNumber *)obj).stringValue;
        } else if ([obj isKindOfClass:NSData.class]) {
            return [[NSString alloc] initWithData:(NSData *)obj encoding:NSUTF8StringEncoding] ?: nil;
        } else {
            return nil;
        }
    }
}

inline NSNumber *NSSafeNumber(NSNumber *obj) {
    if ([obj isKindOfClass:NSNumber.class]) {
        return obj;
    } else {
        if ([obj isKindOfClass:NSString.class]) {
            if (isNullStr(obj)) {
                return nil;
            } else {
                return numberValue((NSString *)obj);
            }
        } else {
            return nil;
        }
    }
}

inline NSArray *NSSafeArray(NSArray *obj) {
    if ([obj isKindOfClass:NSArray.class]) {
        return obj;
    } else {
        return nil;
    }
}

inline NSDictionary *NSSafeDictionary(NSDictionary *obj) {
    if ([obj isKindOfClass:NSDictionary.class]) {
        return obj;
    } else {
        return nil;
    }
}

inline NSData *NSSafeData(NSData *obj) {
    if ([obj isKindOfClass:NSData.class]) {
        return obj;
    } else {
        if ([obj isKindOfClass:NSString.class]) {
            if (isNullStr(obj)) {
                return nil;
            } else {
                return [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding] ?: nil;
            }
        } else {
            return nil;
        }
    }
}

@implementation NSString (VXObject)

- (VXObject *)vx {
    return [self vxWithOptions:NSJSONReadingMutableContainers];
}

- (VXObject *)vxWithOptions:(NSJSONReadingOptions)opt {
    return [VXObject objectWithJsonReadingOptions:opt dataValue:^NSData * _Nonnull(NSError * _Nullable __autoreleasing * _Nullable error) {
        return [self dataUsingEncoding:NSUTF8StringEncoding];
    }];
}

@end

@implementation NSNumber (VXObject)

- (VXObject *)vx {
    return self.stringValue.vx;
}

@end

@implementation NSData (VXObject)

- (VXObject *)vx {
    return [self vxWithOptions:NSJSONReadingMutableContainers];
}

- (VXObject *)vxWithOptions:(NSJSONReadingOptions)opt {
    return [VXObject objectWithJsonReadingOptions:opt dataValue:^NSData * _Nonnull(NSError * _Nullable __autoreleasing * _Nullable error) {
        return self;
    }];
}

@end


@implementation NSArray (VXObject)

- (VXObject *)vx {
    return [self vxWithOptions:NSJSONWritingPrettyPrinted];
}

- (VXObject *)vxWithOptions:(NSJSONWritingOptions)opt {
    return [VXObject objectWithJsonWritingOptions:opt objectValue:^id _Nonnull(NSError * _Nullable __autoreleasing * _Nullable error) {
        return self;
    }];
}


@end


@implementation NSSet (VXObject)

- (VXObject *)vx {
    return [self vxWithOptions:NSJSONWritingPrettyPrinted];
}

- (VXObject *)vxWithOptions:(NSJSONWritingOptions)opt {
    return [VXObject objectWithJsonWritingOptions:opt objectValue:^id _Nonnull(NSError * _Nullable __autoreleasing * _Nullable error) {
        return self.allObjects;
    }];
}

@end


@implementation NSDictionary (VXObject)

- (VXObject *)vx{
    return [self vxWithOptions:NSJSONWritingPrettyPrinted];
}

- (VXObject *)vxWithOptions:(NSJSONWritingOptions)opt {
    return [VXObject objectWithJsonWritingOptions:opt objectValue:^id _Nonnull(NSError * _Nullable __autoreleasing * _Nullable error) {
        return self;
    }];
}

+ (nullable instancetype)dictionaryWithJsonString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    } else {
        return nil;
    }
}

- (NSDictionary *)dictionaryForKey:(NSString *)key{
    return key.length ? ValueX(self[key]).dictionaryValue : nil;
}

- (NSArray *)arrayForKey:(NSString *)key{
    return key.length ? ValueX(self[key]).arrayValue : nil;
}

- (NSString *)stringForKey:(NSString *)key{
    return key.length ? NSSafeString(ValueX(self[key]).stringValue) : nil;
}

- (NSNumber *)numberForKey:(NSString *)key{
    return key.length ? NSSafeNumber(self[key]) : nil;
}

@end
