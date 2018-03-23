//
//  XPBPersonCollectionViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBPersonCollectionViewCell.h"

@implementation XPBPersonCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.iconView = [UIImageView new];
        [self addSubview:self.iconView];
        self.iconView.frame = CGRectMake(((SCREENWIDTH -2*2)/3 - 40 - 65)/2, 20, 40, 40);
        
        self.title = [UILabel new];
        self.title.textColor = [UIColor blackColor];
        self.title.font = [UIFont systemFontOfSize:13];
        self.title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.title];
        
        self.title.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame)+5, 30, 60, 20);
    }
    
    return self;
    
}

@end
