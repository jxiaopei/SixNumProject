//
//  XPBMarkSixLotteryDataModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPBLotteryModel.h"

@interface XPBMarkSixLotteryDataModel : NSObject

@property (nonatomic, strong) NSString *lottery_nper;
@property (nonatomic, strong) NSString *open_week;
@property (nonatomic, strong) NSString *open_time;
@property (nonatomic, strong) NSArray <XPBLotteryModel *>*lottery_result;

@end
