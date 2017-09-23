//
//  XPBBBSCommentTableViewCell.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPBBBSCommentsModel.h"

@interface XPBBBSCommentTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *levelLabel;
@property(nonatomic,strong)XPBBBSCommentsModel *dataModel;

@end
