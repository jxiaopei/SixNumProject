//
//  LCPartnerTableViewCell.m
//  LotteryClient
//
//  Created by Dick on 2017/7/26.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "LCPartnerTableViewCell.h"

@interface LCPartnerTableViewCell ()

@end

@implementation LCPartnerTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 80)];
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = 40;;
        [self.contentView addSubview:_headImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 40, SCREENWIDTH - 120, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

@end
