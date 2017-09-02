//
//  MDFAnimation.m
//  JDBClient
//
//  Created by You Tu on 15/1/12.
//  Copyright (c) 2015年 JDB. All rights reserved.
//

#import "MDFAnimation.h"

@implementation MDFAnimation

+ (CAAnimation *)mdf_animationWithAppearType:(MDFAnimationAppearType)type
{
    CAAnimation *animation = nil;
    
    switch(type)
    {
        case MDFAnimationTypeFadeIn:
            animation = [MDFAnimation mdf_fadeInWithDuration:0.25];
            break;
        case MDFAnimationTypeBounce:
            break;
        case MDFAnimationTypePop:
            animation = [MDFAnimation mdf_popWithDuration:0.45];
            break;
        case MDFAnimationTypePopUp:
            animation = [MDFAnimation popUpWithDuration:0.25];
            break;
        default:
            break;
    }
    
    return animation;
}

+ (CAAnimation *)mdf_animationWithDisappearType:(MDFAnimationDisappearType)type
{
    CAAnimation *animation = nil;
    
    switch(type)
    {
        case MDFAnimationTypeFadeOut:
            animation = [MDFAnimation mdf_fadeInWithDuration:0.25];
            break;
        case MDFAnimationTypeBounceDisappear:
            break;
        default:
            break;
    }
    
    return animation;
}

+ (CAAnimation *)mdf_animationWithActionType:(MDFAnimationActionType)type
{
    CAAnimation *animation = nil;
    switch (type)
    {
        case MDFAnimationTypeRotate:
            animation = [MDFAnimation mdf_rotateWithDuration:0.25 repeatCount:HUGE_VAL];
            break;
        case MDFAnimationTypeWiggle:
            animation = [MDFAnimation mdf_wiggleWithDuration:0.25 fromValue:(-M_PI_2 / 8) toValue:(M_PI_2 / 8) repeatCount:5];
            break;
        case MDFAnimationTypeShake:
            animation = [MDFAnimation mdf_shakeWithDuration:0.25 fromValue:-10 toValue:10 repeatCount:5];
            break;
        case MDFAnimationTypeStretch:
            animation = [MDFAnimation mdf_stretchWithDuration:0.25 fromValue:1.0 toValue:1.08 repeatCount:3];
            break;
        case MDFAnimationTypeRipple:
            animation = [MDFAnimation mdf_rippleWithDuration:0.25 repeatCount:3];
            break;
        case MDFAnimationTypeBreath:
            animation = [MDFAnimation breathWithDuration:0.25 repeatCount:3];
            break;
        default:
            break;
    }
    return animation;
}

+ (CAAnimation *)mdf_animationWithCellType:(MDFAnimationCellType)type
{
    CAAnimation *animation = nil;
    
    switch (type)
    {
        case MDFAnimationCellTypeScaleFadeIn:
            animation = [MDFAnimation cellScaleAndFadeIn:0.25];
            break;
        case MDFAnimationCellTypeNarrowFadeIn:
            animation = [MDFAnimation cellNarrowAndFadeIn:0.25];
            break;
        default:
            break;
    }
    
    return animation;
}

#pragma mark - Appear Animation

+ (CAAnimation *)mdf_fadeInWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.fromValue = [NSNumber numberWithFloat:0.0];
    fadeIn.toValue = [NSNumber numberWithFloat:1.0];
    fadeIn.duration = duration;
    return fadeIn;
}

#pragma mark - Disappear Animation

+ (CAAnimation *)mdf_fadeOutWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.fromValue = [NSNumber numberWithFloat:1.0];
    fadeIn.toValue = [NSNumber numberWithFloat:0.0];
    fadeIn.duration = duration;
    return fadeIn;
}

#pragma mark - Action Animations

+ (CAAnimation *)mdf_rotateWithDuration:(NSTimeInterval)duration repeatCount:(NSUInteger)count;
{
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = @(0);
    rotate.toValue = @(M_PI * 2);
    rotate.duration = duration;
    rotate.repeatCount = count;
    return rotate;
}

+ (CAAnimation *)mdf_wiggleWithDuration:(NSTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue repeatCount:(NSUInteger)count
{
    CABasicAnimation *wiggle = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    wiggle.fromValue = @(fromValue);
    wiggle.toValue = @(toValue);
    wiggle.duration = duration;
    wiggle.repeatCount = count;
    return wiggle;
}

+ (CAAnimation *)mdf_shakeWithDuration:(NSTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue repeatCount:(NSUInteger)count
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = @(fromValue);
    shake.toValue = @(toValue);
    shake.repeatCount = count;
    shake.duration = duration;
    shake.autoreverses = YES;
    shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return shake;
}

+ (CAAnimation *)mdf_rippleWithDuration:(NSTimeInterval)duration repeatCount:(NSUInteger)count
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = @"rippleEffect";
    return transition;
}

+ (CAAnimation *)mdf_stretchWithDuration:(NSTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(NSUInteger)count
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = count;
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

#pragma mark - Breath Animation

+ (CAAnimation *)breathWithDuration:(NSTimeInterval)duration repeatCount:(NSUInteger)count
{
    CABasicAnimation *breath = [CABasicAnimation animationWithKeyPath:@"opacity"];
    breath.fromValue = [NSNumber numberWithFloat:1.0];
    breath.toValue = [NSNumber numberWithFloat:0.0];
    breath.duration = duration;
    breath.repeatCount = count;
    breath.autoreverses = YES;
    return breath;
}

#pragma mark - Cell Animation

+ (CAAnimation *)cellScaleAndFadeIn:(NSTimeInterval)duration
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.fromValue = @(1.08);
    scale.toValue = @(1);
    scale.fillMode = kCAFillModeForwards;
    scale.removedOnCompletion = NO;
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = duration;
    fadeIn.fromValue = @(0);
    fadeIn.toValue = @(1);
    fadeIn.fillMode = kCAFillModeForwards;
    fadeIn.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale, fadeIn];
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    return group;
}

+ (CAAnimation *)cellNarrowAndFadeIn:(NSTimeInterval)duration
{
    CABasicAnimation *narrow = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    narrow.duration = duration;
    narrow.fromValue = @(1.08);
    narrow.toValue = @(1.0);
    narrow.fillMode = kCAFillModeForwards;
    narrow.removedOnCompletion = NO;
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = duration;
    fadeIn.fromValue = @(0);
    fadeIn.toValue = @(1);
    fadeIn.fillMode = kCAFillModeForwards;
    fadeIn.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[narrow, fadeIn];
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    return group;
}

+ (CAAnimation *)mdf_popWithDuration:(NSTimeInterval)duration
{
    NSTimeInterval zoomInDuration = duration * 0.5;
    NSTimeInterval zoomOutDuration = duration * 0.5;
    
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.duration = zoomInDuration;
    zoomIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    zoomIn.fromValue = @(0);
    zoomIn.toValue = @(1.35);
    zoomIn.fillMode = kCAFillModeForwards;
    zoomIn.removedOnCompletion = NO;
    
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.beginTime = zoomInDuration;
    zoomOut.duration = zoomOutDuration;
    zoomOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    zoomOut.fromValue = @(1.35);
    zoomOut.toValue = @(1.0);
    zoomOut.fillMode = kCAFillModeForwards;
    zoomOut.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[zoomIn, zoomOut];
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    return  group;
}

+ (CAAnimation *)popUpWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.duration = duration;
    zoomIn.fromValue = @(0.1);
    zoomIn.toValue = @(1.0);
    zoomIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    zoomIn.fillMode = kCAFillModeForwards;
    zoomIn.removedOnCompletion = NO;
    
    return zoomIn;
}

+ (CAAnimation *)mdf_popDisappearWithDuration:(NSTimeInterval)duration
{
    NSTimeInterval zoomInDuration = duration * 0.5;
    NSTimeInterval zoomOutDuration = duration * 0.5;
    
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.duration = zoomInDuration;
    zoomIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    zoomIn.fromValue = @(1);
    zoomIn.toValue = @(1.35);
    zoomIn.fillMode = kCAFillModeForwards;
    zoomIn.removedOnCompletion = NO;
    
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.beginTime = zoomInDuration;
    zoomOut.duration = zoomOutDuration;
    zoomOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    zoomOut.fromValue = @(1.35);
    zoomOut.toValue = @(0.0);
    zoomOut.fillMode = kCAFillModeForwards;
    zoomOut.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[zoomIn, zoomOut];
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    return  group;
}

@end