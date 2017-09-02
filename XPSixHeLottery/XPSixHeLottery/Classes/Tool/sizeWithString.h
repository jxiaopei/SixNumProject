//
//  sizeWithString.h
//  Love500m
//
//  Created by 樊建鑫 on 16/11/15.
//  Copyright © 2016年 LTZS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface sizeWithString : NSObject

+(CGFloat)heightWithString:(NSString *)str andfontSize :(CGFloat)fontSize;
+(CGFloat)widthWithString:(NSString *)str andfontSize :(CGFloat)fontSize;

//根据字符串获得字符串的高度(固定宽)
+(CGFloat)getSpaceLabelHeight:(NSString *)str withWidh:(CGFloat)width font:(NSInteger)font;
/**
 *@brief 一段字符串显示不同的颜色和字体大小
 *@param string string
 *@font fontsize 字体大小
 *@param color 颜色
 *@param range 范围
 */
+(NSMutableAttributedString *)setStrColorWithStr:(NSString *)string Corlor:(UIColor*)color font:(UIFont*)fontsize range:(NSRange)range;


/**
 *@brief 获取当前时间戳
 */
+(NSString*)getCurrentTimes;

/**
 *@brief 字符串转成时间戳
 *@param str 时间字符串
 */
-(NSString *)DateTimesWithString:(NSString *)str;

/**
 *@brief 时间戳转成字符串
 *@param date 时间字符串
 */
-(NSString *)getStringWithDate:(NSDate *)date;

/**
 *@brief 计算开始时间与结束时间中间相隔xx天xx时xx分
 *@param currentime 传入的时间

 */
- (__kindof NSString*__nullable)getTimeInterval:(NSString*__nullable)currentime;

@end
