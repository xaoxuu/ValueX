//
//  VXObject.h
//  ValueX
//
//  Created by xaoxuu on 2019/8/27.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VXObject;
@protocol VXConvertable;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSErrorDomain const VXErrorDomain;

/**
 内部调用obj.vx，推荐使用这种方式，可以有效避免崩溃

 @param obj VXConvertable对象
 @return VXObject
 */
FOUNDATION_EXTERN VXObject *ValueX(id <VXConvertable>obj);

@interface VXObject : NSObject

/**
 结果：成功、失败
 */
@property (assign, readonly, nonatomic) BOOL isSuccess;

/**
 错误信息
 */
@property (strong, readonly, nullable, nonatomic) NSError *error;


// MARK: 值

/**
 原始值
 */
@property (strong, readonly, nullable, nonatomic) id value;

/**
 输出NSString对象
 
 @return NSString对象
 */
- (nullable NSString *)stringValue;

/**
 输出NSString对象
 
 @return NSString对象
 */
- (nullable NSString *)stringValueWithOptions:(NSJSONWritingOptions)opts;

/**
 输出用于打印的NSString对象
 
 @return NSString对象
 */
- (nullable NSString *)stringValueForPrint;

/**
 输出NSNumber对象
 
 @return NSNumber对象
 */
- (nullable NSNumber *)numberValue;

/**
 输出NSData对象
 
 @return NSData对象
 */
- (nullable NSData *)dataValue;

/**
 输出NSArray对象
 
 @return NSArray对象
 */
- (nullable NSArray *)arrayValue;

/**
 输出NSArray对象（自定义NSJSONReadingOptions）
 
 @return NSArray对象
 */
- (nullable NSArray *)arrayValueWithOptions:(NSJSONReadingOptions)opts;

/**
 输出NSSet对象
 
 @return NSSet对象
 */
- (nullable NSSet *)setValue;

/**
 输出NSDictionary对象
 
 @return NSDictionary对象
 */
- (nullable NSDictionary *)dictionaryValue;

/**
 输出NSDictionary对象（自定义NSJSONReadingOptions）
 
 @return NSDictionary对象
 */
- (nullable NSDictionary *)dictionaryValueWithOptions:(NSJSONReadingOptions)opts;

// MARK: 实例化

/**
 id类型的结果
 
 @param callback 回调
 @return 结果
 */
+ (instancetype)objectWithObjectValue:(id (^)(NSError **error))callback;

/**
 json对象转data
 
 @param opts options
 @param callback 回调
 @return 结果
 */
+ (instancetype)objectWithJsonWritingOptions:(NSJSONWritingOptions)opts objectValue:(id (^)(NSError **error))callback;

/**
 data转json对象
 
 @param opts options
 @param callback 回调
 @return 结果
 */
+ (instancetype)objectWithJsonReadingOptions:(NSJSONReadingOptions)opts dataValue:(NSData *(^)(NSError **error))callback;

// MARK: - 解析

/**
 操作完成的回调，此回调必然执行。
 
 @param callback 回调
 @return 结果
 */
- (instancetype)didComplete:(void (^)(BOOL isSuccess))callback;

/**
 错误信息回调，只有当error有值时才会进入此回调
 
 @param callback 回调
 @return 结果
 */
- (instancetype)didError:(void (^)(NSError * _Nullable error))callback;


@end

NS_ASSUME_NONNULL_END

