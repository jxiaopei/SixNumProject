//
//  XPBFreeInforListDataModel.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBFreeInforListDataModel.h"

@implementation XPBFreeInforListDataModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

-(CGFloat)rowHeight
{
    CGSize textSize = [self.post_content boundingRectWithSize:CGSizeMake(SCREENWIDTH - 33, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    CGFloat textHeight = textSize.height > 60 ? 60 : textSize.height;
    return textHeight + 95;
    
}

@end
