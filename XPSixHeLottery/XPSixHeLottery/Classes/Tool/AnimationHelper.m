//
//  AnimationHelper.m
//  SmartWatch
//
//  Created by liliang on 15/10/1.
//  Copyright © 2015年 liliang. All rights reserved.
//

#import "AnimationHelper.h"

@implementation AnimationHelper

/**
 *  设置点赞动画
 *
 *  @param view  执行动画的对象
 *  @param image 转换的image (option)
 */
+ (void)setupPriseAnimation:(UIView *)view withImage:(UIImage *)image {
    //添加点赞动画
    view.layer.contents = (id)image.CGImage;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1),@(1.0),@(1.5)];
    animation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    [view.layer addAnimation:animation forKey:@"animationShow"];
}

/**
 *  暂停一个View的动画
 *
 *  @param layer
 */
+ (void)pauseAnimation:(CALayer *)layer {
    // 取出当前的时间点，就是暂停的时间点
    CFTimeInterval pausetime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设定时间偏移量，让动画定格在那个时间点
    [layer setTimeOffset:pausetime];
    
    // 将速度设为0
    [layer setSpeed:0.0f];
}

/**
 *  恢复一个View的动画
 *
 *  @param layer
 */
+ (void)resumeAnimation:(CALayer *)layer {
    // 获取暂停的时间
    CFTimeInterval pausetime = layer.timeOffset;
    
    // 计算出此次播放时间(从暂停到现在，相隔了多久时间)
    CFTimeInterval starttime = CACurrentMediaTime() - pausetime;
    
    // 将时间偏移量设为0(重新开始)；
    layer.timeOffset = 0.0;
    
    // 设置开始时间(beginTime是相对于父级对象的开始时间,系统会根据时间间隔帮我们算出什么时候开始动画)
    layer.beginTime = starttime;
    
    // 将速度恢复，设为1
    layer.speed = 1.0;
}


@end
