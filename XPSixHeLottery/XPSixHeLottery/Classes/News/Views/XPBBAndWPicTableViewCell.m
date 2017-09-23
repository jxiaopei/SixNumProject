//
//  XPBBAndWPicTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBAndWPicTableViewCell.h"

@implementation XPBBAndWPicTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *horView = [UIView new];
        [self addSubview:horView];
        [horView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        horView.backgroundColor = GlobalLightGreyColor;
        
        UIImageView *imageView = [UIImageView new];
        _iconView = imageView;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(60);
        }];
        imageView.image = [UIImage imageNamed:@"占位图"];
        
        UILabel *titleLabel = [UILabel new];
        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_offset(5);
            make.top.mas_equalTo(imageView.mas_top).mas_offset(5);
        }];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"图片名称";
        
        UILabel *subTitleLabel = [UILabel new];
        _subTitleLabel = subTitleLabel;
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_left);
            make.bottom.mas_equalTo(imageView.mas_bottom);
        }];
        subTitleLabel.font = [UIFont systemFontOfSize:14];
        subTitleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.text = @"0000年00月00日 000期";
        
        
    }
    return self;
}

@end
