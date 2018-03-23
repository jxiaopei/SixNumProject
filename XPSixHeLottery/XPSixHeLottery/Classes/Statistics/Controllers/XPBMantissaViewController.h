//
//  XPBMantissaViewController.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseViewController.h"

typedef NS_ENUM(NSInteger,StatFormType){
    
    StatisMantissaType  =0, //尾数大小
    StatisAnimalType        //家禽野兽
    
};

@interface XPBMantissaViewController : BPBaseViewController

@property(nonatomic,assign)StatFormType statFormType;

@end
