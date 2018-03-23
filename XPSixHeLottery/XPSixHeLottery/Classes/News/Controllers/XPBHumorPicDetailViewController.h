//
//  XPBHumorPicDetailViewController.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseViewController.h"

@interface XPBHumorPicDetailViewController : BPBaseViewController

@property(nonatomic,copy)NSString *picID;
@property(nonatomic,copy)NSString *picDataStr;
@property(nonatomic,copy)NSString *picContent;
@property(nonatomic,assign)BOOL isAttention;

@end
