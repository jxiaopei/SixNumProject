//
//  XPBPersonalEixtTableViewCell.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPBPersonalEixtTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,assign)BOOL ishiddenBtn;
@property(nonatomic,copy)void(^didClickExitBtnBlock)();

@end
