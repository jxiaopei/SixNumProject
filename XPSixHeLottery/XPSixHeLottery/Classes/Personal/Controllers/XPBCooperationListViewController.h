//
//  XPBCooperationListViewController.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseViewController.h"

typedef NS_ENUM(NSInteger,CooperationListType){
    
    CooperationType = 0,   //合作伙伴
    RecommendedType,       //今日推荐
};

@interface XPBCooperationListViewController : BPBaseViewController

@property(nonatomic,assign)CooperationListType listType;

@end
