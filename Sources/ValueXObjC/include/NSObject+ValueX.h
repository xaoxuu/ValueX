//
//  NSObject+ValueX.h
//  ValueX
//
//  Created by xaoxuu on 2019/8/27.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VXObject;
NS_ASSUME_NONNULL_BEGIN

/**
 安全的NSString（NSString对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSString * __nullable NSSafeString(id obj);

/**
 安全的NSNumber（NSNumber对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSNumber * __nullable NSSafeNumber(id obj);

/**
 安全的NSData（NSData对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSData * __nullable NSSafeData(id obj);

/**
 安全的NSArray（NSArray对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSArray * __nullable NSSafeArray(id obj);

/**
 安全的NSArray（NSArray对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSSet * __nullable NSSafeSet(id obj);

/**
 安全的NSDictionary（NSDictionary对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSDictionary * __nullable NSSafeDictionary(id obj);


/**
 可转换成VXObject
 */
@protocol VXConvertable <NSObject>

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *)vx;

@end

@protocol VXConvertableObject <VXConvertable>

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *)vxWithOptions:(NSJSONWritingOptions)opt;

@end

@protocol VXConvertableData <VXConvertable>

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *)vxWithOptions:(NSJSONReadingOptions)opt;

@end

@interface NSString (VXObject) <VXConvertableData>

/// 字符串长度不为0，则返回true
- (BOOL)isNotEmpty;

@end

@interface NSNumber (VXObject) <VXConvertable>
@end

@interface NSData (VXObject) <VXConvertableData>
@end

@interface NSArray (VXObject) <VXConvertableObject>
@end

@interface NSSet (VCObject) <VXConvertableObject>
@end

@interface NSDictionary<KeyType, ObjectType> (VXObject) <VXConvertableObject>

/**
 根据json字符串创建字典
 
 @param string json字符串
 @return 字典
 */
+ (nullable instancetype)dictionaryWithJsonString:(NSString *)string;

/**
 解析dictionary中的dictionary，返回值可能为空
 
 @return 值
 */
- (nullable NSDictionary *)dictionaryForKey:(KeyType<NSCopying>)key;

/**
 解析dictionary中的array，返回值可能为空
 
 @return 值
 */
- (nullable NSArray *)arrayForKey:(KeyType<NSCopying>)key;

/**
 解析dictionary中的string，返回值可能为空
 
 @return 值
 */
- (nullable NSString *)stringForKey:(KeyType<NSCopying>)key;

/**
 解析dictionary中的number，返回值可能为空
 
 @return 值
 */
- (nullable NSNumber *)numberForKey:(KeyType<NSCopying>)key;

/// 解析dictionary中的bool值
/// @param key 键
/// @param defaultValue 默认值
- (BOOL)boolForKey:(KeyType<NSCopying>)key defaultValue:(BOOL)defaultValue;

@end

NS_ASSUME_NONNULL_END
