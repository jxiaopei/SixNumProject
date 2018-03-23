//
//  XPBMarkSixLotteryModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/17.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPBMarkSixLotteryDataModel.h"


@interface XPBMarkSixLotteryModel : NSObject

@property (nonatomic, strong) NSString *next_week;
@property (nonatomic, strong) NSString *periods_name;
@property (nonatomic, strong) NSString *remanin_time;
@property (nonatomic, strong) XPBMarkSixLotteryDataModel *lottery_list;
@property (nonatomic, strong) NSString *next_date;

@end


