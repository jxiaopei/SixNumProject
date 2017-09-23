//
//  XPBZodiaVoteCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBZodiaVoteCell.h"

@implementation XPBZodiaVoteCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGFloat imgW = (SCREENWIDTH)/4 -20;
        UIButton *colorBtn = [UIButton new];
        _colorBtn =colorBtn;
        [self addSubview:colorBtn];
        colorBtn.frame = CGRectMake(10, 10, imgW, imgW);
        [colorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UILabel *countLabel = [UILabel new];
        _countLabel = countLabel;
        [self addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(colorBtn.mas_width);
            make.top.mas_equalTo(colorBtn.mas_bottom).mas_offset(5);
            make.centerX.mas_equalTo(0);
        }];
        countLabel.textColor = [UIColor blackColor];
        countLabel.font = [UIFont systemFontOfSize:15];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.adjustsFontSizeToFitWidth = YES;
        
        NSString *contentStr = @"鼠:10票";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
        //设置：在0-3个单位长度内的内容显示成红色
        [str addAttribute:NSForegroundColorAttributeName value:GlobalOrangeColor range:NSMakeRange(0, 2)];
        countLabel.attributedText = str;
        
        UIButton *voteBtn = [UIButton new];
        [self addSubview:voteBtn];
        _voteBtn = voteBtn;
        [voteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(countLabel.mas_bottom).mas_offset(5);
        }];
        voteBtn.layer.masksToBounds = YES;
        voteBtn.layer.cornerRadius = 5;
        voteBtn.layer.borderWidth = 1;
        voteBtn.layer.borderColor = GlobalOrangeColor.CGColor;
        [voteBtn setTitleColor:GlobalOrangeColor forState:UIControlStateNormal];
        [voteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [voteBtn setTitle:@"投票" forState:UIControlStateNormal];
        [voteBtn setTitle:@"已投票" forState:UIControlStateSelected];
        voteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [voteBtn addTarget:self action:@selector(didClickVoteBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
    
}

-(void)didClickVoteBtn:(UIButton *)sender
{
    //已经投票的不可以再点
    if(_voteBtn.selected)
    {
        return;
    }
    self.didClickVoteBtnBlock();
}

@end
