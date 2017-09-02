//
//  XPBFreeInforListTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBFreeInforListTableViewCell.h"

@interface XPBFreeInforListTableViewCell()

@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIView *verLineView;

@end

@implementation XPBFreeInforListTableViewCell

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
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-10);
        }];
        _dateLabel = dateLabel;
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor blackColor];
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(heLineView.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        _titleLabel = titleLabel;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"标题";
        
        UIView *verLineView = [UIView new];
        [self addSubview:verLineView];
        _verLineView = verLineView;
        verLineView.backgroundColor = [UIColor redColor];
        verLineView.frame = CGRectMake(20, 50, 3, 60);
        
        UILabel *contentLabel = [UILabel new];
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(verLineView.mas_right).mas_offset(5);
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(15);
        }];
        _contentLabel = contentLabel;
        contentLabel.textAlignment =  NSTextAlignmentLeft;
        contentLabel.numberOfLines = 4;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textColor = [UIColor grayColor];
        
        
    }
    return self;
}

-(void)setDataModel:(XPBFreeInforListDataModel *)dataModel
{
    _dataModel = dataModel;
    _dateLabel.text = dataModel.main_time;
    _titleLabel.text = dataModel.post_title;
    _contentLabel.text = dataModel.post_content;
    
    CGSize textSize = [dataModel.post_content boundingRectWithSize:CGSizeMake(SCREENWIDTH - 33, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    CGFloat textHeight = textSize.height > 60 ? 60 : textSize.height;
    CGFloat viewHeight = textHeight + 10;
    _verLineView.frame = CGRectMake(20, 50, 3, viewHeight);
}

@end
