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
            make.top.mas_equalTo(5);
        }];
        periodLabel.font = [UIFont systemFontOfSize:16];
        periodLabel.textColor = [UIColor blackColor];
        
        UILabel *dateLabel = [UILabel new];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(5);
        }];
        dateLabel.font = [UIFont systemFontOfSize:16];
        dateLabel.textColor = [UIColor blackColor];
        
        
        
        CGFloat btnW = 38;
        CGFloat margant = (SCREENWIDTH - btnW *7 -20 - 25)/7;
        for(int i= 0; i< 6;i++)
        {
            UIButton *btn = [UIButton new];
            [self addSubview:btn];
            
            btn.frame = CGRectMake(10 + (margant + btnW) * i, 45, btnW, btnW);
            [btn setBackgroundImage:[UIImage imageNamed:@"红波"] forState:UIControlStateNormal];
            [btn setTitle:@"0" forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.tag = i;
            UILabel *zodiaLabel = [UILabel new];
            [self addSubview:zodiaLabel];
            zodiaLabel.frame = CGRectMake(10 + (margant + btnW) * i, 45 + btnW, btnW, 30);
            zodiaLabel.textColor = [UIColor blackColor];
            zodiaLabel.textAlignment = NSTextAlignmentCenter;
            zodiaLabel.font = [UIFont systemFontOfSize:18];
            zodiaLabel.text = @"龙";
            [self.btnArr addObject:btn];
            [self.labelArr addObject:zodiaLabel];
        }
        
        UIButton *plusBtn = [UIButton new];
        [self addSubview:plusBtn];
        plusBtn.frame = CGRectMake(10 + (margant + btnW) * 6,45, 25, btnW);
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [plusBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
        [plusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        plusBtn.titleLabel.font = [UIFont systemFontOfSize:40];
        
        UIButton *spcNumBtn = [UIButton new];
        [self addSubview:spcNumBtn];
        spcNumBtn.frame = CGRectMake(10 + (margant + btnW) * 6 + margant +25, 45, btnW, btnW);
        [spcNumBtn setBackgroundImage:[UIImage imageNamed:@"绿波"] forState:UIControlStateNormal];
        [spcNumBtn setTitle:@"0" forState:UIControlStateNormal];
        [spcNumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
        [spcNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UILabel *spcZodiaLabel = [UILabel new];
        [self addSubview:spcZodiaLabel];
        spcZodiaLabel.frame = CGRectMake(10 + (margant + btnW) * 6 + margant +25, 45 + btnW, btnW, 30);
        spcZodiaLabel.textColor = [UIColor blackColor];
        spcZodiaLabel.font = [UIFont systemFontOfSize:18];
        spcZodiaLabel.textAlignment = NSTextAlignmentCenter;
        spcZodiaLabel.text = @"龙";
        [self.btnArr addObject:spcNumBtn];
        [self.labelArr addObject:spcZodiaLabel];
    }
    return self;
}

-(void)setDataModel:(XPBMarkSixLotteryDataModel *)dataModel
{
    _dataModel = dataModel;
    NSString *periodStr = [dataModel.lottery_nper substringFromIndex:4];
    _periodLabel.text = [NSString stringWithFormat:@"第%@期",periodStr];
    _dateLabel.text = [NSString stringWithFormat:@"%@(%@)",[[dataModel.open_time substringToIndex:8] insertDateUnitWithCN ],dataModel.open_week];
    
    for(int i = 0; i < dataModel.lottery_result.count;i++)
    {
        XPBLotteryModel *model = dataModel.lottery_result[i];
        UIButton *btn = _btnArr[i];
        [btn setBackgroundImage:[UIImage imageNamed:model.colour] forState:UIControlStateNormal];
        [btn setTitle:model.number forState:UIControlStateNormal];
        UILabel *label = _labelArr[i];
        label.text = model.name;
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
