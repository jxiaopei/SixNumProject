//
//  XPBActionCollectionViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBActionCollectionViewCell.h"

@interface XPBActionCollectionViewCell()

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIButton *statueBtn;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;

@end

@implementation XPBActionCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _iconView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(100);
        }];
        imageView.image = [UIImage imageNamed:@"占位图"];
        
        UIButton *statueBtn = [UIButton new];
        [self addSubview:statueBtn];
        _statueBtn =  statueBtn;
        [statueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
        statueBtn.layer.masksToBounds = YES;
        statueBtn.layer.cornerRadius = 5;
        [statueBtn setTitle:@"活动状态" forState:UIControlStateNormal];
        [statueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        statueBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        statueBtn.backgroundColor = [UIColor grayColor];
        
        UILabel *nameLabel = [UILabel new];
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(statueBtn.mas_bottom).mas_offset(10);
        }];
        nameLabel.text = @"活动名称";
        nameLabel.textColor = GlobalRedColor;
        nameLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *timeLabel = [UILabel new];
        [self addSubview:timeLabel];
        _timeLabel = timeLabel;
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(5);
        }];
        timeLabel.text = @"活动时间:xxxx年xx月xx-xx月xx日";
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(timeLabel.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(0.5);
        }];
        lineView.backgroundColor = [UIColor grayColor];
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        _contentLabel = contentLabel;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(lineView.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(50);
        }];
        contentLabel.text = @"活动内容";
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.numberOfLines = 3;
    }
    
    return self;
    
}

-(void)setDataModel:(XPBActionDataModel *)dataModel{
    
    _dataModel = dataModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:dataModel.act_pic_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
    if([dataModel.act_type_name isEqualToString:@"未开始"]){
        [_statueBtn setTitle:@"未开始" forState:UIControlStateNormal];
        _statueBtn.backgroundColor = GlobalBlueBallColor;
    }else if ([dataModel.act_type_name isEqualToString:@"进行中"]){
        [_statueBtn setTitle:@"进行中" forState:UIControlStateNormal];
        _statueBtn.backgroundColor = GlobalRedBallColor;
    }else if ([dataModel.act_type_name isEqualToString:@"已结束"]){
        [_statueBtn setTitle:@"已结束" forState:UIControlStateNormal];
        _statueBtn.backgroundColor = GlobalGreenBallColor;
    }else if ([dataModel.act_type_name isEqualToString:@"已作废"]){
        [_statueBtn setTitle:@"已作废" forState:UIControlStateNormal];
        _statueBtn.backgroundColor = [UIColor grayColor];
    }
    
    _nameLabel.text = dataModel.act_name;
    NSString *beginStr = [dataModel.begin_time substringToIndex:11];
    NSString *endStr = [dataModel.end_time substringToIndex:11];
    NSString *beginYear = [beginStr substringToIndex:4];
    NSString *endYear = [endStr substringToIndex:4];
    if([endYear isEqualToString:beginYear]){
        endStr = [endStr substringFromIndex:5];
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@至 %@",beginStr,endStr];
    _contentLabel.text = dataModel.act_content;
}

@end
