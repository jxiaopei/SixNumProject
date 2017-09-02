//
//  XPBAttributeReferenceColorCell.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/8.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPBReferenceBallModel.h"

@interface XPBAttributeReferenceColorCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray <XPBReferenceBallModel *>*dataSource;
@property(nonatomic,copy)NSString *nameStr;

@end
