//
//  XPBMarkSixListModel.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBMarkSixListModel.h"

@implementation XPBMarkSixListModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"rows":[XPBMarkSixLotteryDataModel class]};
}

@end
