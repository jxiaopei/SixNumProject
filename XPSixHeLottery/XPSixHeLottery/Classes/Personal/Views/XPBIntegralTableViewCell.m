//
//  XPBIntegralTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBIntegralTableViewCell.h"

@interface XPBIntegralTableViewCell ()

@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *sorceLabel;
@property(nonatomic,strong)UILabel *detailLabel;

@end

@implementation XPBIntegralTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
        }];
        dateLabel.text = @"0000.00.00 00:00";
        dateLabel.font = [UIFont systemFontOfSize:15];
        dateLabel.textColor = [UIColor grayColor];
        
        UILabel *sorceLabel = [UILabel new];
        [self addSubview:sorceLabel];
        _sorceLabel = sorceLabel;
        [sorceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(80);
            make.left.mas_equalTo(SCREENWIDTH/2-25);
        }];
        sorceLabel.text = @"0";
        sorceLabel.font = [UIFont systemFontOfSize:15];
        sorceLabel.textAlignment = NSTextAlignmentCenter;
        sorceLabel.textColor = [UIColor grayColor];
        
        UILabel *detailLabel = [UILabel new];
        [self addSubview:detailLabel];
        _detailLabel = detailLabel;
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        detailLabel.text = @"消费内容";
        detailLabel.font = [UIFont systemFontOfSize:15];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor = [UIColor grayColor];
        
    }
    return self;
}

-(void)setDataModel:(XPBIntegralDataModel *)dataModel
{
    _dataModel = dataModel;
    _dateLabel.text = [dataModel.create_time substringToIndex:dataModel.create_time.length - 3];
    _sorceLabel.text = dataModel.mission_point;
    _detailLabel.text = dataModel.mission_name;
}

@end
