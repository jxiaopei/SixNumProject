//
//  NSString+Utility.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "NSString+Utility.h"
#import <commoncrypto/CommonDigest.h>

@implementation NSString (Utility)

- (BOOL)isNotNil
{
    if (self == nil || (id)self == [NSNull null] || [self isEqualToString:@""] || [self isEqualToString:@" "] || [self class] == NULL)
        return NO;
    
    return YES;
}

- (NSString *)mdf_md5
{
    if (!self) {
        return nil;
    }
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)(strlen(cStr)), result );
    
    NSString* s = [NSString stringWithFormat:
                   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   result[0], result[1], result[2], result[3],
                   result[4], result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11],
                   result[12], result[13], result[14], result[15]
                   ];
    return s;
}

@end
