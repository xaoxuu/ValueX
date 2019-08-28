//
//  ViewController.m
//  VXExample
//
//  Created by xaoxuu on 2019/8/27.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

#import "ViewController.h"
#import <ValueX/ValueX.h>


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ValueX";
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tv.dataSource = self;
    tv.delegate = self;
    [self.view addSubview:tv];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.numberOfLines = 0;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"测试1";
            cell.detailTextLabel.text = @"[dict stringForKey:@\"\"];\n[dict numberForKey:@\"\"];\n[dict arrayForKey:@\"\"];\n[dict dictionaryForKey:@\"\"];\nNSSafeString(obj)\nNSSafeNumber(obj)\nNSSafeArray(obj)\nNSSafeDictionary(obj)\nNSSafeData(obj)";
        } else {
            cell.textLabel.text = nil;
            cell.detailTextLabel.text = nil;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"测试1";
            cell.detailTextLabel.text = @"返回的字典中含有@\"<null>\"等含义为空但实际却是有值的字符串的情况";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"测试2";
            cell.detailTextLabel.text = @"返回字典中含有json字符串";
        } else {
            cell.textLabel.text = nil;
            cell.detailTextLabel.text = nil;
        }
    } else if (indexPath.section == 2) {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"ValueX(@\"123\")";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"ValueX(@123)";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"ValueX(data)";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"ValueX(@[@2, @3, @4])";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"ValueX(NSSet)";
        } else if (indexPath.row == 5) {
            cell.textLabel.text = @"ValueX(@{@\"name\": @\"Alex\"}})";
        } else {
            cell.textLabel.text = nil;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self test01];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self test1:@{@"age": @"23", @"userId": @"123123123", @"deviceId": @"<null>"}];
        } else if (indexPath.row == 1) {
            [self test2:@{@"name": @"Mr. Xu", @"info": @"{\n    \"age\" : \"23\",\n    \"userId\" : \"123123123\",\n    \"deviceId\" : \"<null>\"\n}"}];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self testValueX:@"123"];
        } else if (indexPath.row == 1) {
            [self testValueX:@123];
        } else if (indexPath.row == 2) {
            [self testValueX:[@"haha" dataUsingEncoding:NSUTF8StringEncoding]];
        } else if (indexPath.row == 3) {
            [self testValueX:@[@2, @3, @4]];
        } else if (indexPath.row == 4) {
            [self testValueX:[NSSet setWithArray:@[@2, @3, @4]]];
        } else if (indexPath.row == 5) {
            [self testValueX:@{@"name": @"Alex"}];
        }
    }
    
}

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

- (void)testValueX:(id <VXConvertable>)input {
    VXObject *obj = [[ValueX(input) didComplete:^(BOOL isSuccess) {
        NSLog(@"didComplete: %@", @(isSuccess));
    }] didError:^(NSError * _Nullable error) {
        NSLog(@"didError: %@", error.localizedDescription);
    }];
    NSLog(@"stringValue: %@", obj.stringValue);
    NSLog(@"numberValue: %@", obj.numberValue);
    NSLog(@"dataValue: %@", obj.dataValue);
    NSLog(@"arrayValue: %@", obj.arrayValue);
    NSLog(@"setValue: %@", obj.setValue);
    NSLog(@"dictionaryValue: %@", obj.dictionaryValue);
}

@end
