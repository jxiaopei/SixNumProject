//
//  CheckHelper.m
//  
//
//  Created by liliang on 15/6/16.
//  Copyright (c) 2015年 QYJ. All rights reserved.
//

#import "CheckHelper.h"

@implementation CheckHelper


+ (BOOL)checkAmount:(NSString *)amount {
    NSString *regex = @"^(0|[1-9][0-9]{0,9})(\.[0-9]{1,2})?$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    BOOL isMatch =  [test evaluateWithObject:amount];
    return isMatch;
}


+ (BOOL)checkName:(NSString *)name {
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";//@"[\u4e00-\u9fa5]";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    BOOL isMatch =  [test evaluateWithObject:name];
    return isMatch;
}

//校验纯数字
+ (BOOL)checkNumber:(NSString *)number {
    NSString *regex = @"[0-9]";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    BOOL isMatch =  [test evaluateWithObject:number];
    return isMatch;
}

+ (BOOL)checkTelNumber:(NSString *)telNumber
{
    //NSString *pattern = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *pattern = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (BOOL)checkNumberAndLetter:(NSString *)string {
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    BOOL isMatch =  [test evaluateWithObject:string];
    return isMatch;
}

+ (BOOL)checkEmail:(NSString *)email
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    return [test evaluateWithObject:email];
}

+ (BOOL)checkPersonIDCardNumber:(NSString *)value {
    
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    BOOL isIDCard = [test evaluateWithObject:value];
    return isIDCard;
}

//+ (BOOL)checkIDCardNumber:(NSString *)value {
//    
//    NSString *regex = @"\\d{14}[0-9a-zA-Z])|(\\d{17}[0-9a-zA-Z]";
//    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
//    BOOL isIDCard = [test evaluateWithObject:value];
//    return isIDCard;
//    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    NSInteger length =0;
//    if (!value) {
//        return NO;
//    }else {
//        length = value.length;
//        
//        if (length !=15 && length !=18) {
//            return NO;
//        }
//    }
//    // 省份代码
//    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
//    
//    NSString *valueStart2 = [value substringToIndex:2];
//    BOOL areaFlag =NO;
//    for (NSString *areaCode in areasArray) {
//        if ([areaCode isEqualToString:valueStart2]) {
//            areaFlag =YES;
//            break;
//        }
//    }
//    
//    if (!areaFlag) {
//        return false;
//    }
//    
//    NSRegularExpression *regularExpression;
//    NSUInteger numberofMatch;
//    
//    int year = 0;
//    switch (length) {
//        case 15:
//            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
//            
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                
//                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                              options:NSMatchingReportProgress
//                                                                range:NSMakeRange(0, value.length)];
//            
//            //[regularExpression release];
//            
//            if(numberofMatch >0) {
//                return YES;
//            }else {
//                return NO;
//            }
//        case 18:
//            
//            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                              options:NSMatchingReportProgress
//                                                                range:NSMakeRange(0, value.length)];
//            
//            //[regularExpression release];
//            
//            if(numberofMatch >0) {
//                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
//                int Y = S %11;
//                NSString *M =@"F";
//                NSString *JYM =@"10X98765432";
//                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
//                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
//                    return YES;// 检测ID的校验位
//                }else {
//                    return NO;
//                }
//                
//            }else {
//                return NO;
//            }
//        default:
//            return NO;
//    }
//}


+ (BOOL)checkBankCardNumber:(NSString *)cardNo {
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength - 1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    
    for (int i = cardNoLength - 1; i >= 1; i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i - 1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 == 1) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal >= 10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0){
        return YES;
    }
    else {
        return NO;
    }
}

@end
