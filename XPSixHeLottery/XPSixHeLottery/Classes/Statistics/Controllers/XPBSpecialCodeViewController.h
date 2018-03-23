//
//  XPBSpecialCodeViewController.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseViewController.h"

typedef NS_ENUM(NSInteger,StatisticsType){
    
    StatisSpeHisType = 0,   //特码历史
    StatisNorHisType,       //正码历史
};

@interface XPBSpecialCodeViewController : BPBaseViewController

@property(nonatomic,assign)StatisticsType statisticsType;

@end
