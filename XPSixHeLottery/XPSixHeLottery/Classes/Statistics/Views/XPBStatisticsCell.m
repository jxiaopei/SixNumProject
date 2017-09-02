//
//  XPBStatisticsCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/5.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBStatisticsCell.h"

@implementation XPBStatisticsCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel *titleLabel = [UILabel new];
        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-10);
        }];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
    
        UIImageView *iconView = [UIImageView new];
        _iconView = iconView;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(titleLabel.mas_top).mas_offset(-5);
            make.width.mas_equalTo((SCREENWIDTH - 2)/6);
            make.height.mas_equalTo((SCREENWIDTH - 2)/6);
        }];
        
        
        
    }
    return self;
}

@end
