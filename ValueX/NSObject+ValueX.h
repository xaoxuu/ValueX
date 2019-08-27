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
 安全的NSArray（NSArray对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSArray * __nullable NSSafeArray(id obj);

/**
 安全的NSDictionary（NSDictionary对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSDictionary * __nullable NSSafeDictionary(id obj);

/**
 安全的NSData（NSData对象或者nil）
 
 @param obj 目标对象
 @return 安全对象
 */
FOUNDATION_EXTERN NSData * __nullable NSSafeData(id obj);


@interface NSString (VXObject)

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *)vx;

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *(^)(NSJSONReadingOptions opt))vxWithOptions;

@end

@interface NSData (VXObject)

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *)vx;

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *(^)(NSJSONReadingOptions opt))vxWithOptions;

@end

@interface NSArray (VXObject)

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *)vx;

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *(^)(NSJSONWritingOptions opt))vxWithOptions;

@end

@interface NSDictionary (VXObject)

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *)vx;

/**
 转换成ValueX对象
 
 @return ValueX对象
 */
- (VXObject *(^)(NSJSONWritingOptions opt))vxWithOptions;


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
- (nullable NSDictionary *)dictionaryForKey:(NSString *)key;

/**
 解析dictionary中的array，返回值可能为空
 
 @return 值
 */
- (nullable NSArray *)arrayForKey:(NSString *)key;

/**
 解析dictionary中的string，返回值可能为空
 
 @return 值
 */
- (nullable NSString *)stringForKey:(NSString *)key;

/**
 解析dictionary中的number，返回值可能为空
 
 @return 值
 */
- (nullable NSNumber *)numberForKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END