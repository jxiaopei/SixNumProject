//
//  AnimationHelper.h
//  SmartWatch
//
//  Created by liliang on 15/10/1.
//  Copyright © 2015年 liliang. All rights reserved.
//
//  动画辅助类
//

#import <Foundation/Foundation.h>

@interface AnimationHelper : NSObject

/**
 *  设置点赞动画
 *
 *  @param view  执行动画的对象
 *  @param image 转换的image (option)
 */
+ (void)setupPriseAnimation:(UIView *)view withImage:(UIImage *)image;

/**
 *  暂停一个View的动画
 *
 *  @param layer
 */
+ (void)pauseAnimation:(CALayer *)layer;

/**
 *  恢复一个View的动画
 *
 *  @param layer
 */
+ (void)resumeAnimation:(CALayer *)layer;


@end
