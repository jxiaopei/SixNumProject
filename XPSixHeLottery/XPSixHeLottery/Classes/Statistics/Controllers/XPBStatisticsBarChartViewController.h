//
//  XPBStatisticsBarChartViewController.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/31.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseViewController.h"

typedef NS_ENUM(NSInteger,StatisticType){
    
    StatisSpeZodiacType = 0,      //生肖特码
    StatisNorZodiacType,          //生肖正码
    StatisSpeColorType,           //波色特码
    StatisNorColorType,           //波色正码
    StatisSpeMantissType,         //特码尾数
    StatisNorMantissType,         //正码尾数
    
};

@interface XPBStatisticsBarChartViewController : BPBaseViewController

@property(nonatomic,assign)StatisticType statisticsType;

@end
