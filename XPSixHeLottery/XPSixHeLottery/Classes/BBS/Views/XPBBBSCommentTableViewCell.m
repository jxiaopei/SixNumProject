//
//  XPBBBSCommentTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBBSCommentTableViewCell.h"

@interface XPBBBSCommentTableViewCell ()

@property(nonatomic,strong)UILabel *anthorLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *dateLabel;

@end

@implementation XPBBBSCommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(15);
            make.width.height.mas_equalTo(30);
        }];
        iconView.image = [UIImage imageNamed:@"默认头像 (1)"];
        
        UILabel *anthorLabel = [UILabel new];
        [self addSubview:anthorLabel];
        [anthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconView.mas_top);
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
        }];
        _anthorLabel = anthorLabel;
        anthorLabel.font = [UIFont systemFontOfSize:13];
        anthorLabel.textColor = [UIColor grayColor];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
            make.bottom.mas_equalTo(iconView.mas_bottom);
        }];
        _dateLabel = dateLabel;
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = [UIColor grayColor];
        
        UILabel *levelLabel = [UILabel new];
        [self addSubview:levelLabel];
        _levelLabel = levelLabel;
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(iconView.mas_top);
        }];
        levelLabel.textColor = [UIColor grayColor];
        levelLabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        _contentLabel = contentLabel; 
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
        }];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha = 0.6;
        
    }
    return self;
}

-(void)setDataModel:(XPBBBSCommentsModel *)dataModel
{
    _dataModel = dataModel;
    self.anthorLabel.text = dataModel.reply_user_name;
    self.contentLabel.text = dataModel.reply_content;
    self.dateLabel.text = dataModel.reply_time;
}

@end
