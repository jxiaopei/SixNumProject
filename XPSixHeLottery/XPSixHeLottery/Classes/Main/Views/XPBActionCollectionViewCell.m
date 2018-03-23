//
//  XPBActionCollectionViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBActionCollectionViewCell.h"

@interface XPBActionCollectionViewCell()



@end

@implementation XPBActionCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _iconView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
            
        }];
        imageView.image = [UIImage imageNamed:@"占位图"];
        
    }
    
    return self;
    
}

-(void)setDataModel:(XPBActionDataModel *)dataModel{
    
    _dataModel = dataModel;

}

@end
