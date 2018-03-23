//
//  XPBSixHeStatColorTableViewCell.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/7.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPBSixHeStatColorTableViewCell : UITableViewCell

@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,copy)void (^didClickBtnBlock)(NSString *title,NSString *btnTitle,NSInteger count);


@end
