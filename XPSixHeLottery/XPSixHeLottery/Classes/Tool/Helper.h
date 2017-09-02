//
//  Helper.h
//  
//
//  Created by liliang on 15/6/4.
//  Copyright (c) 2015年 QYJ. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CheckHelper.h"
#import "AnimationHelper.h"
#import "ImageHelpers.h"
#import "MBProgressHUD.h"

//文件类型
typedef NS_ENUM(NSUInteger, FileType) {
    FileType_Image,//图片
    FileType_Voice,//语音
    FileType_Text,//文本
};


typedef NS_ENUM(NSInteger, HeadImageType){
    HeadImageType_Invalid = 0,//无效类型
    HeadImageType_Local,//本地系统头像
    HeadImageType_Network,//网络图片
};



@interface Helper : NSObject
/**
 *  获取当前的格式化时间
 *
 *  @param nil
 *
 *  @return 格式化时间
 */
+ (NSString *)getCurrentDate;

/**
 *  获得某天的日期
 *
 *  @param day 和今天间隔多少天
 *
 *  @return 格式化日期
 */
+ (NSString *)getDateFromThisDay:(NSInteger)day;


/**
 *  获取当前时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)getCurrentTimestamp;

/**
 *  根据时间戳返回时间字符串
 *
 *  @param time 时间戳
 *
 *  @return 格式化时间
 */
+ (NSString *)getDateStringByTimestamp:(NSString *)time;

/**
 *  根据时间字符串返回时间对象
 *
 *  @param dateString 日期字符串
 *
 *  @return 日期对象
 */
+ (NSDate *)getDateFromString:(NSString *)dateString;

/**
 *  计算时间差
 *
 *  @param theDate 目标时间
 *
 *  @return 相差秒数
 */
+ (NSInteger)intervalSinceNow:(NSString *)theDate;

/**
 *  判断是否包含表情
 *
 *  @param string 需验证的文字
 *
 *  @return 结果
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 *  根据字符串文本后缀判断文件类型
 *
 *  @param aString 文件后缀
 *
 *  @return 文件类型
 */
+ (FileType)getFileType:(NSString *)aString;

/**
 *  根据颜色返回图片
 *
 *  @param color 颜色
 *
 *  @return 创建的Image对象
 */
+ (UIImage *)imageWithColor:(UIColor*)color;

/**
 *  根据长度生成随机数数组
 *
 *  @param length 随机的长度
 *
 *  @return 组成的字符串
 */


+ (NSString *)randomArrayWithLength:(NSInteger)length;

/**
 *  正则判断是否是手机
 *
 *  @param length 随机的长度
 *
 *  @return 组成的字符串
 */

+(BOOL)isPhoneNumber:(NSString *)patternStr;

/**
 *  根据字典生成json字符串
 *
 *  @param length 随机的长度
 *
 *  @return 组成的字符串
 */
+ (NSString *)dictionaryToJsonString:(NSDictionary *)dictionary;

/**
 *  根据json字符串生成字典
 *
 *  @param length 随机的长度
 *
 *  @return 组成的字典
 */
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString;

/**
 *  获取当前ViewController
 *
 *  @return
 */
+ (UIViewController *)getCurrentViewController;

/**
 *  MBProgressHUD方法
 *
 *  @param tip 提示信息
 */
+ (void)showLoading;
+ (void)hideLoading;
+ (void)showTip:(NSString *)tip;
+ (void)showTip:(NSString *)tip duration:(CGFloat)duration;
+ (void)showProgressWithProgress:(float)progress;
+ (void)hideProgress;

@end



