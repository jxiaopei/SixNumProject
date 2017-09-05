//
//  XPBSignInTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/30.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBSignInTableViewCell.h"

@interface XPBSignInTableViewCell()

@property(nonatomic,strong)UIButton *completeBtn;
@property(nonatomic,strong)UILabel *missionLabel;
@property(nonatomic,strong)UIButton *scoreBtn;

@end

@implementation XPBSignInTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GlobalLightGreyColor;
        
        UIButton *completeBtn = [UIButton new];
        [self addSubview:completeBtn];
        _completeBtn = completeBtn;
        [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(20);
        }];
        [completeBtn setImage:[UIImage imageNamed:@"未完成签到任务"] forState:UIControlStateNormal];
        [completeBtn setImage:[UIImage imageNamed:@"完成签到任务"] forState:UIControlStateSelected];
        
        UILabel *missionLabel = [UILabel new];
        [self addSubview:missionLabel];
        _missionLabel = missionLabel;
        [missionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(completeBtn.mas_right).mas_offset(10);
            make.width.mas_equalTo(200);
        }];
        missionLabel.textColor = [UIColor blackColor];
        missionLabel.font = [UIFont systemFontOfSize:15];
        missionLabel.text = @"任务内容";
        missionLabel.numberOfLines = 2;
        
        UIButton *scoreBtn = [UIButton new];
        [self addSubview:scoreBtn];
        _scoreBtn =scoreBtn;
        [scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-30);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
        }];
        [scoreBtn setTitle:@"+0" forState:UIControlStateNormal];
        [scoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        scoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [scoreBtn setBackgroundColor:[UIColor grayColor]];
        scoreBtn.layer.masksToBounds = YES;
        scoreBtn.layer.cornerRadius = 10;
        
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

-(void)setDataModel:(XPBSignInMissionModel *)dataModel
{
    _dataModel = dataModel;
    _completeBtn.selected = dataModel.mission_stat ;
    _scoreBtn.backgroundColor = dataModel.mission_stat ? [UIColor blackColor] : [UIColor grayColor];
    [_scoreBtn setTitle:dataModel.mission_point forState:UIControlStateNormal];
    _missionLabel.text = dataModel.mission_name;
}


@end
