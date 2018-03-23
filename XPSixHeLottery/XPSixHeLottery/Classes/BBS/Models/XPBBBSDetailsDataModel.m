//
//  XPBBBSDetailsDataModel.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBBSDetailsDataModel.h"

@implementation XPBBBSDetailsDataModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"reply_list":[XPBBBSCommentsModel class]};
}

@end
