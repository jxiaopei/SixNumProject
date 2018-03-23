//
//  LCNetDataParsing.m
//  LotteryClient
//
//  Created by Dick on 2017/7/3.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "LCNetDataParsing.h"

@implementation LCNetDataParsing

+ (NSString *)inputParsing:(NSDictionary *)dict {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

+ (NSDictionary *)outputParsing:(id)responseObject {
    NSError *error;
    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    if (str.length < 1) {
        return nil;
    }
    str = [str stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\\n"];
    str = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
    str = [str substringWithRange:NSMakeRange(1, str.length - 2)];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return dict;
}

+ (NSDictionary *)outputImageParsing:(id)responseObject {
    NSError *error;
    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    if (str.length < 1) {
        return nil;
    }
    str = [str stringByReplacingOccurrencesOfString:@"\\\\r\\\\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\\n"];
    str = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
    str = [str substringWithRange:NSMakeRange(1, str.length - 2)];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return dict;
}

@end

