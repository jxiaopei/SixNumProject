//
//  XPBWalletListTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/10/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBWalletListTableViewCell.h"

@interface XPBWalletListTableViewCell ()

@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *missionLabel;
@property(nonatomic,strong)UILabel *moneyLabel;

@end

@implementation XPBWalletListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
        dateLabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *missionLabel = [UILabel new];
        [self addSubview:missionLabel];
        _missionLabel = missionLabel;
        [missionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        missionLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel *moneyLabel = [UILabel new];
        [self addSubview:moneyLabel];
        _moneyLabel = moneyLabel;
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
        lineView.backgroundColor = GlobalLightGreyColor;
    }
    return self;
}

-(void)setDataModel:(XPBWalletDataModel *)dataModel{
    _dataModel = dataModel;
    _dateLabel.text = dataModel.create_time;
    _missionLabel.text = dataModel.task_type_name;
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",dataModel.money];
}


@end
