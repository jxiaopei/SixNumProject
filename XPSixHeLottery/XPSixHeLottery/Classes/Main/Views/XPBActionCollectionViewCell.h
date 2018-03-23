//
//  XPBActionCollectionViewCell.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPBActionDataModel.h"

@interface XPBActionCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)XPBActionDataModel *dataModel;
@property(nonatomic,strong)UIImageView *iconView;

@end
