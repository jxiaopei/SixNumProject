//
//  CheckHelper.h
//  
//
//  Created by liliang on 15/6/16.
//  Copyright (c) 2015年 QYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckHelper : NSObject

//校验价格数字
+ (BOOL)checkAmount:(NSString *)amount;

//校验中文姓名
+ (BOOL)checkName:(NSString *)name;

//校验纯数字
+ (BOOL)checkNumber:(NSString *)number;

//校验手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;

//校验数字和字母的组合
+ (BOOL)checkNumberAndLetter:(NSString *)string;

//校验邮箱格式
+ (BOOL)checkEmail:(NSString *)email;

//校验身份证号
+ (BOOL)checkPersonIDCardNumber:(NSString *)value;

//校验银行卡号
+ (BOOL)checkBankCardNumber:(NSString *)cardNo;


@end
