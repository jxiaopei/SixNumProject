//
//  XCTools.h
//  xcwl
//
//  Created by cong on 16/10/25.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCTools : NSObject
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
+ (void)shakeAnimationForView:(UIView *) view;
@end
