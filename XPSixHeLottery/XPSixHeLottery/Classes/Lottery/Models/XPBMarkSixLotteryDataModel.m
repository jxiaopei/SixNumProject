//
//  XPBMarkSixLotteryDataModel.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBMarkSixLotteryDataModel.h"

@implementation XPBMarkSixLotteryDataModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"lottery_result":[XPBLotteryModel class]};
}

@end
