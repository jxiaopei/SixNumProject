//
//  XPBSixHeStatTableViewCell.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/7.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPBReferenceBallModel.h"

@interface XPBSixHeStatNumTableViewCell : UITableViewCell

@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,strong)NSMutableArray <XPBReferenceBallModel *>*dataSource;
@property(nonatomic,copy)void (^didClickBtnBlock)(NSString *title,NSString *btnTitle,NSInteger count);

@end
