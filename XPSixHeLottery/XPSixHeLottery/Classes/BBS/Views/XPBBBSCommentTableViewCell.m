//
//  XPBBBSCommentTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBBSCommentTableViewCell.h"

@implementation XPBBBSCommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(5);
        }];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-10);
        }];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *detailLabel = [UILabel new];
        [self addSubview:detailLabel];
        _detailLabel = detailLabel;
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.bottom.mas_equalTo(-10);
        }];
        detailLabel.textColor = [UIColor blackColor];
        detailLabel.font = [UIFont systemFontOfSize:13];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha = 0.8;
        
    }
    return self;
}

-(void)setDataModel:(XPBBBSCommentsModel *)dataModel
{
    _dataModel = dataModel;
    self.titleLabel.text = dataModel.reply_user_name;
    self.detailLabel.text = dataModel.reply_content;
    self.dateLabel.text = dataModel.reply_time;
}

@end
