//
//  XPBAttributeReferenceCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/7.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBAttributeReferenceCell.h"

@interface XPBAttributeReferenceCell()



@end

@implementation XPBAttributeReferenceCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIButton *btn = [UIButton new];
        _btn = btn;
        btn.frame = CGRectMake(0, 0, 25, 25);
        [self addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"占位图"] forState:UIControlStateNormal];
        [btn setTitle:@"0" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 3);

    }
    return self;
}

@end
