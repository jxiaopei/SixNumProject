//
//  XPBNorPicTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/25.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBAttentionPicTableViewCell.h"

@implementation XPBAttentionPicTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        UILabel *titleLabel = [UILabel new];
        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
        }];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"图片名称";
        
        UIButton *attentionBtn = [UIButton new];
        _attentionBtn = attentionBtn;
        [self addSubview:attentionBtn];
        [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(30);
        }];
        [attentionBtn setImage:[UIImage imageNamed:@"未关注"] forState:UIControlStateSelected];
        [attentionBtn setImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
        
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-2);
        }];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha = 0.8;
        
        
    }
    return self;
}


@end
