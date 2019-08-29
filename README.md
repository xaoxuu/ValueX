<img src="https://img.vim-cn.com/63/7ef9dc770675854daabd4295b28de50fc842f1.png" height="120px">

**实用的安全对象类型转换库（ObjC）**
NSString/NSNumber/NSArray/NSSet/NSDictionary/NSData 无缝转换


## 特性

- 有效避免后台返回数据类型异常导致程序崩溃
- 快速由已知对象得到期望的对象类型


## 示例

### 确保正确的类型

```ObjC
- (void)test01 {
    NSDictionary *d1 = @{@"name": @"Mr. Xu", @"info": @"{\n    \"age\" : \"23\",\n    \"userId\" : \"123123123\",\n    \"deviceId\" : \"<null>\"\n}"};
    NSLog(@"\nd1: %@", d1);
    NSDictionary *d11 = NSSafeDictionary([d1 dictionaryForKey:@"name"]);
    NSDictionary *d12 = NSSafeDictionary([d1 dictionaryForKey:@"info"]);
    NSLog(@"\n d11: %@,\n d12: %@", d11, d12);

    NSDictionary *d2 = @{@"age": @23, @"userId": @"123123123", @"deviceId": @"<null>"};
    NSLog(@"\nd2: %@", d2);
    NSNumber *d21 = [d2 numberForKey:@"userId"];
    NSString *d22 = [d2 stringForKey:@"userId"];
    NSNumber *d23 = [d2 numberForKey:@"age"];
    NSString *d24 = [d2 stringForKey:@"age"];
    NSNumber *d25 = [d2 numberForKey:@"deviceId"];
    NSString *d26 = [d2 stringForKey:@"deviceId"];
    NSLog(@"\n d21: %@,\n d22: %@,\n d23: %@,\n d24: %@,\n d25: %@,\n d26: %@", d21, d22, d23, d24, d25, d26);
}
```

### 后台返回数据类型不确定性

```ObjC
/**
 测试: 从后台接收到字典

 @param value 后台返回的字典数据
 */
- (void)test1:(NSDictionary *)value {
    NSLog(@"value: %@", value);
    // 真实类型并不一定是NSDictionary，要确保拿来用的时候一定是NSDictionary
    VXObject *vx = ValueX(value);
    NSDictionary *dict = ValueX(value).dictionaryValue;
    NSLog(@"ValueX(value).dictionaryValue: %@", dict);
    // 获取其中的某个值
    NSNumber *deviceId = [dict numberForKey:@"deviceId"];
    NSString *userId = [dict stringForKey:@"userId"];
    NSNumber *age = [dict numberForKey:@"age"];
    NSLog(@"deviceId: %@, userId: %@, age: %@", deviceId, userId, age);
    NSString *str = vx.stringValue;
    NSLog(@"ValueX(value).stringValue: %@", str);
}

- (void)test2:(NSDictionary *)value {
    NSLog(@"value: %@", value);
    // 真实类型并不一定是NSDictionary，要确保拿来用的时候一定是NSDictionary
    NSDictionary *dict = ValueX(value).dictionaryValue;
    NSLog(@"ValueX(value).dictionaryValue: %@", dict);
    // 获取其中的某个值
    NSDictionary *info = [dict dictionaryForKey:@"info"];
    NSLog(@"info: %@", info);
}
```
