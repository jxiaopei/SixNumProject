//
//  XPBLotteryTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/18.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBLotteryTableViewCell.h"

@interface XPBLotteryTableViewCell ()

@property(nonatomic,strong)NSMutableArray *btnArr;
@property(nonatomic,strong)NSMutableArray *labelArr;
@property(nonatomic,strong)UILabel *periodLabel;
@property(nonatomic,strong)UILabel *dateLabel;

@end

@implementation XPBLotteryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *periodLabel = [UILabel new];
        [self addSubview:periodLabel];
        _periodLabel = periodLabel;
        [periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
        periodLabel.font = [UIFont systemFontOfSize:13];
        periodLabel.textColor = [UIColor grayColor];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(periodLabel.mas_right).mas_offset(5);
            make.top.mas_equalTo(10);
        }];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor grayColor];
        
        
        
        CGFloat btnW = 30;
        CGFloat margant = (SCREENWIDTH - btnW *7 -20 - 25)/7;
        for(int i= 0; i< 6;i++)
        {
            UIButton *btn = [UIButton new];
            [self addSubview:btn];
            
            btn.frame = CGRectMake(10 + (margant + btnW) * i, 40, btnW, btnW);
            [btn setBackgroundImage:[UIImage imageNamed:@"红波"] forState:UIControlStateNormal];
            [btn setTitle:@"0" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = i;
            UILabel *zodiaLabel = [UILabel new];
            [self addSubview:zodiaLabel];
            zodiaLabel.frame = CGRectMake(10 + (margant + btnW) * i, 45 + btnW, btnW, 30);
            zodiaLabel.textColor = [UIColor blackColor];
            zodiaLabel.textAlignment = NSTextAlignmentCenter;
            zodiaLabel.font = [UIFont systemFontOfSize:13];
            zodiaLabel.adjustsFontSizeToFitWidth = YES;
            zodiaLabel.text = @"龙";
            [self.btnArr addObject:btn];
            [self.labelArr addObject:zodiaLabel];
        }
        
        UIButton *plusBtn = [UIButton new];
        [self addSubview:plusBtn];
        plusBtn.frame = CGRectMake(10 + (margant + btnW) * 6,40, 25, btnW);
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [plusBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
        [plusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        plusBtn.titleLabel.font = [UIFont systemFontOfSize:40];
        
        UIButton *spcNumBtn = [UIButton new];
        [self addSubview:spcNumBtn];
        spcNumBtn.frame = CGRectMake(10 + (margant + btnW) * 6 + margant +25, 40, btnW, btnW);
        [spcNumBtn setBackgroundImage:[UIImage imageNamed:@"绿波"] forState:UIControlStateNormal];
        [spcNumBtn setTitle:@"0" forState:UIControlStateNormal];
        [spcNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        spcNumBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        UILabel *spcZodiaLabel = [UILabel new];
        [self addSubview:spcZodiaLabel];
        spcZodiaLabel.frame = CGRectMake(10 + (margant + btnW) * 6 + margant +25, 45 + btnW, btnW, 30);
        spcZodiaLabel.textColor = [UIColor blackColor];
        spcZodiaLabel.font = [UIFont systemFontOfSize:13];
        spcZodiaLabel.textAlignment = NSTextAlignmentCenter;
        spcZodiaLabel.adjustsFontSizeToFitWidth = YES;
        spcZodiaLabel.text = @"龙";
        [self.btnArr addObject:spcNumBtn];
        [self.labelArr addObject:spcZodiaLabel];
        
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

-(void)setDataModel:(XPBMarkSixLotteryDataModel *)dataModel
{
    _dataModel = dataModel;
    NSString *periodStr = [dataModel.lottery_nper substringFromIndex:4];
    _periodLabel.text = [NSString stringWithFormat:@"第%@期",periodStr];
    _dateLabel.text = [NSString stringWithFormat:@"%@",[[dataModel.open_time substringToIndex:8] insertDateUnitWithCN ]];//,dataModel.open_week
    
    for(int i = 0; i < dataModel.lottery_result.count;i++)
    {
        XPBLotteryModel *model = dataModel.lottery_result[i];
        UIButton *btn = _btnArr[i];
        [btn setBackgroundImage:[UIImage imageNamed:model.colour] forState:UIControlStateNormal];
        [btn setTitle:model.number forState:UIControlStateNormal];
        UILabel *label = _labelArr[i];
        label.text = [NSString stringWithFormat:@"%@/%@", model.name,model.fiveElement];
    }
}

-(NSMutableArray *)btnArr
{
    if(_btnArr == nil)
    {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

-(NSMutableArray *)labelArr
{
    if(_labelArr == nil)
    {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}
@end
