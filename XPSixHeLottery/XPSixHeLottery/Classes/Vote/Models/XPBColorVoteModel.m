//
//  XPBColorVoteModel.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBColorVoteModel.h"

@implementation XPBColorVoteModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             @"isAttention": @"bool",
             };
}

@end
