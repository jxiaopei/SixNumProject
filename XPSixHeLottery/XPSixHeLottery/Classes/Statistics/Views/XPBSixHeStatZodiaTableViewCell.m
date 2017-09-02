//
//  XPBSixHeStatZodiaTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/7.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBSixHeStatZodiaTableViewCell.h"

@implementation XPBSixHeStatZodiaTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *appearSNumLabel = [UILabel new];
        [self addSubview:appearSNumLabel];
        appearSNumLabel.frame = CGRectMake(5 , 5, SCREENWIDTH/2 - 5, 20);
        appearSNumLabel.textColor = [UIColor blackColor];
        appearSNumLabel.font = [UIFont systemFontOfSize:12];
        appearSNumLabel.textAlignment = NSTextAlignmentRight;
        CGFloat margant = (SCREENWIDTH/2 - 6 * 20 - 10)/5;
        for(int i = 0;i < 6; i++)
        {
            UIButton *btn = [UIButton new];
            [self addSubview:btn];
            [btn setTitle:@"龙" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickDataBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(SCREENWIDTH/2 + 5+ i * (20+ margant) , CGRectGetMinY(appearSNumLabel.frame), 20, 20);
            btn.tag = i;
        }
        
    }
    return self;
}

-(void)didClickDataBtn:(UIButton *)sender
{
//    if(_didClickBtnBlock)
//    {
//        _didClickBtnBlock(self.titleStr,@"XX",20);
//    }
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    for(UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)view;
            [btn setTitle:self.dataSource[btn.tag] forState:UIControlStateNormal];
            
        }else if([view isKindOfClass:[UILabel class]]){
            
            UILabel *titleLabel = (UILabel *)view;
            titleLabel.text = [self.titleStr stringByAppendingString:@":"];
        }
    }
    
}

@end
