//
//  NSDictionary+Extension.m
//  WHH
//
//  Created by Mac on 2017/1/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

//-(NSString*) getMD5
//{
//    //12
//    NSMutableArray* arr = [NSMutableArray new];
//    for (NSString *key in [self allKeys]) {
//        [arr addObject:key];
//    }
//    
//    NSStringCompareOptions comparisonOptions = NSLiteralSearch|NSNumericSearch|
//    
//    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
//    
//    NSComparator sort = ^(NSString *obj1,NSString *obj2){
//        
//        NSRange range = NSMakeRange(0,obj1.length);
//        
//        return [obj1 compare:obj2 options:comparisonOptions range:range];
//        
//    };
//    
//    //排序
//    NSArray *resultArray = [arr sortedArrayUsingComparator:sort];
//    
//  
//    NSMutableString* allstr = [NSMutableString new];
//    
//    for (NSString* str in resultArray) {
//        if ([self[str] isEqualToString:@""]) {
//            NSLog(@"空参数%@",self[str] );
//            
//        }else{
//         allstr = [NSMutableString stringWithFormat:@"%@%@%@",allstr,str,self[str]];
//       
//        }
//       
//    }
//
//    //PRIVATE KEY       
//    allstr = [NSMutableString stringWithFormat:@"%@%@",allstr,APP_MD5PRIVATE_KEY];
//    
//    NSString* md5 = [allstr md5HexDigest];
//    
//    return md5;
//}
//-(NSString*) getStr
//{
//    //12
//    NSMutableArray* arr = [NSMutableArray new];
//    for (NSString *key in [self allKeys]) {
//        [arr addObject:key];
//    }
//    
//    NSStringCompareOptions comparisonOptions = NSLiteralSearch|NSNumericSearch|
//    
//    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
//    
//    NSComparator sort = ^(NSString *obj1,NSString *obj2){
//        
//        NSRange range = NSMakeRange(0,obj1.length);
//        
//        return [obj1 compare:obj2 options:comparisonOptions range:range];
//        
//    };
//    
//    //排序
//    NSArray *resultArray = [arr sortedArrayUsingComparator:sort];
//    
//    
//    NSMutableString* allstr = [NSMutableString new];
//    
//    for (NSString* str in resultArray) {
//        if ([self[str] isEqualToString:@""]) {
//            NSLog(@"空参数%@",self[str] );
//            
//        }else{
//            allstr = [NSMutableString stringWithFormat:@"%@%@%@",allstr,str,self[str]];
//            
//        }
//        
//    }
//    
//    //PRIVATE KEY
//    allstr = [NSMutableString stringWithFormat:@"%@%@",allstr,APP_MD5PRIVATE_KEY];
//   
//   
//    
//    return allstr;
//}
@end
