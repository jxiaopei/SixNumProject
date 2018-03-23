//
//  XPBBBSListTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/25.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBBSListTableViewCell.h"

@interface XPBBBSListTableViewCell ()

@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *anthorLabel;
@property(nonatomic,strong)UILabel *commentsLabel;
@property(nonatomic,strong)UIButton *appreciatesBtn;

@end

@implementation XPBBBSListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *heLineView = [UIView new];
        heLineView.alpha = 0.6;
        [self addSubview:heLineView];
        [heLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
        heLineView.backgroundColor = GlobalLightGreyColor;
        
        UIImageView *iconView = [UIImageView new];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(heLineView.mas_bottom).mas_offset(15);
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
        anthorLabel.textColor = [UIColor blackColor];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).mas_offset(5);
            make.bottom.mas_equalTo(iconView.mas_bottom);
        }];
        _dateLabel = dateLabel;
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = [UIColor grayColor];
        
        UILabel *commentsLabel = [UILabel new];
        [self addSubview:commentsLabel];
        _commentsLabel = commentsLabel;
        [commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(dateLabel.mas_top);
        }];
        commentsLabel.font = [UIFont systemFontOfSize:13];
        commentsLabel.textColor = [UIColor grayColor];
        
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(commentsLabel.mas_left).mas_offset(-3);
            make.centerY.mas_equalTo(commentsLabel.mas_centerY);
            make.width.height.mas_equalTo(15);
        }];
        imageView.image = [UIImage imageNamed:@"评论"];
        
        UIButton *appreciatesBtn = [UIButton new];
        [self addSubview:appreciatesBtn];
        _appreciatesBtn = appreciatesBtn;
        [appreciatesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(imageView.mas_left).mas_offset(-10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(40);
            make.centerY.mas_equalTo(commentsLabel.mas_centerY);
        }];
        [appreciatesBtn setTitle:@"0" forState:UIControlStateNormal];
        [appreciatesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        appreciatesBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [appreciatesBtn setImage:[UIImage imageNamed:@"未点赞"] forState:UIControlStateNormal];
        [appreciatesBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateSelected];
        appreciatesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        appreciatesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);

        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(dateLabel.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        _titleLabel = titleLabel;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"标题";
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10);
        }];
        _contentLabel = contentLabel;
        contentLabel.textAlignment =  NSTextAlignmentLeft;
        contentLabel.numberOfLines = 4;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textColor = [UIColor grayColor];
        
    }
    return self;
}


-(void)setDataModel:(XPBBBSListDataModel *)dataModel
{
    _dataModel = dataModel;
    _dateLabel.text = dataModel.main_time;
    _commentsLabel.text = [NSString stringWithFormat:@"%zd",dataModel.count];
    NSString *periodStr = [dataModel.lottery_result_num substringFromIndex:4];
    _titleLabel.text = [NSString stringWithFormat:@"%@期:%@",periodStr, dataModel.post_title];
    if(dataModel.is_top){
        _titleLabel.textColor = [UIColor redColor];
    }else{
        _titleLabel.textColor = [UIColor blackColor];
    }
    _contentLabel.text = dataModel.post_content;
    _anthorLabel.text =dataModel.main_user_name;
    NSString *countStr = [NSString stringWithFormat:@"%zd",dataModel.like_count];
    _appreciatesBtn.selected = [dataModel.like_user_id isNotNil];
    [_appreciatesBtn setTitle:countStr forState:UIControlStateNormal];
    CGFloat margin = 2 * countStr.length;
    _appreciatesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, margin, 0, 0);
    _appreciatesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, margin);

    
}

@end
