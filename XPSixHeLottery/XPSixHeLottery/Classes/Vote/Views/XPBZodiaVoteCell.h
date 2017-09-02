//
//  XPBZodiaVoteCell.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPBZodiaVoteCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UIButton *colorBtn;
@property(nonatomic,strong)UIButton *voteBtn;
@property(nonatomic,copy)void (^didClickVoteBtnBlock)();

@end
