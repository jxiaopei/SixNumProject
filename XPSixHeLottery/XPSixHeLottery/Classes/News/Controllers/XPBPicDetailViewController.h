//
//  XPBPicDetailViewController.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseViewController.h"

@interface XPBPicDetailViewController : BPBaseViewController

@property(nonatomic,copy)NSString *picID;
@property(nonatomic,copy)NSString *picDataStr;
@property(nonatomic,assign)BOOL isAttention;

@end
