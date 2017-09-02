//
//  XPBMarkSixLotteryListModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPBMarkSixListModel.h"

@interface XPBMarkSixLotteryListModel : NSObject

@property (nonatomic, strong) NSString *next_week;
@property (nonatomic, strong) NSString *periods_name;
@property (nonatomic, strong) NSString *remanin_time;
@property (nonatomic, strong) XPBMarkSixListModel *lottery_list;
@property (nonatomic, strong) NSString *next_date;


@end
