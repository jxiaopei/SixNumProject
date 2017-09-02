//
//  XPBStatSingleBarChartViewController.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/31.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseViewController.h"

typedef NS_ENUM(NSInteger,StatSingleBarType){
    
    StatisDoubleOrSingleType  =0, //特码两面
    StatisNorSumType,             //正码总分
    StatisSpeNumHisType,          //特码历史
};

@interface XPBStatSingleBarChartViewController : BPBaseViewController

@property(nonatomic,assign)StatSingleBarType statSingleBarType;

@end
