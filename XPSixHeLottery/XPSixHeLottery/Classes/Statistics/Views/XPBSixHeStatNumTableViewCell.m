//
//  XPBSixHeStatTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/7.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBSixHeStatNumTableViewCell.h"

@interface XPBSixHeStatNumTableViewCell()



@end

@implementation XPBSixHeStatNumTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *appearSNumLabel = [UILabel new];
        [self addSubview:appearSNumLabel];
        appearSNumLabel.frame = CGRectMake(5 , 5, SCREENWIDTH - 10, 20);
        appearSNumLabel.textColor = [UIColor blackColor];
        appearSNumLabel.font = [UIFont systemFontOfSize:12];
        CGFloat margant = (SCREENWIDTH - 10 * 25 - 10)/9;
        for(int i = 0;i < 10; i++)
        {
            UIButton *btn = [UIButton new];
            [self addSubview:btn];
            [btn setBackgroundImage:[UIImage imageNamed:@"占位图"] forState:UIControlStateNormal];
            [btn setTitle:@"0" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
           
            [btn addTarget:self action:@selector(didClickDataBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(5+ i * (25+ margant) , CGRectGetMaxY(appearSNumLabel.frame) + 5, 25, 25);
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

-(void)setDataSource:(NSMutableArray <XPBReferenceBallModel *>*)dataSource
{
    _dataSource = dataSource;
    
    for(UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)view;
            XPBReferenceBallModel *dataModel = dataSource[btn.tag];
            [btn setBackgroundImage:[UIImage imageNamed:dataModel.color] forState:UIControlStateNormal];
            [btn setTitle:dataModel.number forState:UIControlStateNormal];

        }else if([view isKindOfClass:[UILabel class]]){
            
            UILabel *titleLabel = (UILabel *)view;
            titleLabel.text = self.titleStr;
        }
    }
    
}



@end
