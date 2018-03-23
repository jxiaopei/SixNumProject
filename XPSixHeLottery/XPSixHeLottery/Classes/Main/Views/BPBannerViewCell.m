//
//  BPBannerViewCell.m
//  baseProgram
//
//  Created by iMac on 2017/7/27.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBannerViewCell.h"

@interface BPBannerViewCell()



@end

@implementation BPBannerViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.imageView = [UIImageView new];
        [self addSubview:self.imageView];
        self.imageView.frame = CGRectMake(0, 0, SCREENWIDTH, self.bounds.size.height);
    }
    
    return self;
    
}

@end
