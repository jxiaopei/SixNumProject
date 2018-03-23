//
//  XPBMantissaTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBMantissaTableViewCell.h"

@interface XPBMantissaTableViewCell()

@property(nonatomic,strong)UILabel *dateLabel;

@end

@implementation XPBMantissaTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *dateLabel = [UILabel new];
        _dateLabel = dateLabel;
        [self addSubview:dateLabel];
        dateLabel.frame = CGRectMake(10, 2, 60, 20);
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = [UIFont systemFontOfSize:13];
        
        CGFloat margant = (SCREENWIDTH - 60 - 20 - 30 * 7 - 5)/6;
        for (int i = 0;i < 7;i++)
        {
            UIButton *btn = [UIButton new];
            btn.frame = CGRectMake(75 + i *(margant + 30), 2, 30, 20);
            [self addSubview:btn];
            [btn setTitle:@"10" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = i;
        }
        
    }
    return self;
}

-(void)setDataModel:(XPBMantissaDataModel *)dataModel
{
    _dataModel = dataModel;
    
    _dateLabel.text = dataModel.periods;
    for(UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIButton class]] )
        {
            UIButton *btn = (UIButton *)view;
            NSString *title = [NSString stringWithFormat:@"%@",dataModel.sizeList[btn.tag]];
            [btn setTitle:title forState:UIControlStateNormal];
        }
    }
    
}

@end
