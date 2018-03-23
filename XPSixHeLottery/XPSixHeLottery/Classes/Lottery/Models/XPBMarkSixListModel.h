//
//  XPBMarkSixListModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPBMarkSixLotteryDataModel.h"

@interface XPBMarkSixListModel : NSObject

@property (nonatomic, strong) NSString *next_week;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) NSMutableArray < XPBMarkSixLotteryDataModel *>*rows;
@property (nonatomic, assign) NSInteger pageSize;



@end
