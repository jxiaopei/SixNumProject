//
//  MDFAnimation.h
//  JDBClient
//
//  Created by You Tu on 15/1/12.
//  Copyright (c) 2015年 JDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MDFAnimation : NSObject

typedef enum {
    MDFAnimationTypeRotate,     // 自转动画
    MDFAnimationTypeWiggle,     // 不停摇摆动画
    MDFAnimationTypeShake,      // 不停摇晃动画
    MDFAnimationTypeRipple,     // 涟漪动画
    MDFAnimationTypeStretch,    // x轴变形动画
    MDFAnimationTypeBreath,     // 呼吸动画
} MDFAnimationActionType;       // 视图运动的动画类型

typedef enum {
    MDFAnimationTypeFadeIn,     // 渐隐效果出现
    MDFAnimationTypeBounce,     // 弹簧效果出现
    MDFAnimationTypePop,        // 弹跳效果出来 （由0放大后至1）
    MDFAnimationTypePopUp,      // 弹出放大效果 （由0放大后至1）
} MDFAnimationAppearType;       // 视图出现的动画类型

typedef enum {
    MDFAnimationTypeFadeOut,           // 渐隐效果消失
    MDFAnimationTypeBounceDisappear,   // 弹簧效果消失
    MDFAnimationTypePopDisappear,      // 弹跳效果消失 （放1放大后至0）
} MDFAnimationDisappearType;           // 视图消失的动画类型

typedef enum {
    MDFAnimationCellTypeScaleFadeIn,     // 由大及小渐入
    MDFAnimationCellTypeNarrowFadeIn,    // 由宽及窄渐入
} MDFAnimationCellType;                  // cell出现方式的动画类型


// 根据视图出现的动画类型返回相应动画
+ (CAAnimation *)mdf_animationWithActionType:(MDFAnimationActionType)type;

// 根据视图出现的动画类型返回相应动画
+ (CAAnimation *)mdf_animationWithAppearType:(MDFAnimationAppearType)type;

// 根据视图出现的动画类型返回相应动画
+ (CAAnimation *)mdf_animationWithDisappearType:(MDFAnimationDisappearType)type;

// 根据视图出现的动画类型返回相应动画
+ (CAAnimation *)mdf_animationWithCellType:(MDFAnimationCellType)type;

// 渐现
+ (CAAnimation *)mdf_fadeInWithDuration:(NSTimeInterval)duration;

// 渐隐
+ (CAAnimation *)mdf_fadeOutWithDuration:(NSTimeInterval)duration;

// 自转
+ (CAAnimation *)mdf_rotateWithDuration:(NSTimeInterval)duration repeatCount:(NSUInteger)count;

// 摇摆
+ (CAAnimation *)mdf_wiggleWithDuration:(NSTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue repeatCount:(NSUInteger)count;

// 摇晃
+ (CAAnimation *)mdf_shakeWithDuration:(NSTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue repeatCount:(NSUInteger)count;

// 涟漪
+ (CAAnimation *)mdf_rippleWithDuration:(NSTimeInterval)duration repeatCount:(NSUInteger)count;

// x转变形
+ (CAAnimation *)mdf_stretchWithDuration:(NSTimeInterval)duration fromValue:(float)fromValue toValue:(float)toValue repeatCount:(NSUInteger)count;

// pop scale from 0 -> identity
+ (CAAnimation *)mdf_popWithDuration:(NSTimeInterval)duration;

// sclae from identity -> 0
+ (CAAnimation *)mdf_popDisappearWithDuration:(NSTimeInterval)duration;

@end
