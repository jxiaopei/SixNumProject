//
//  ImageHelper.h
//  SmartWatch
//
//  Created by liliang on 15/10/21.
//  Copyright © 2015年 liliang. All rights reserved.
//
//  图片辅助类
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface ImageHelpers : NSObject

/**
 *  保存图片
 *
 *  @param tempImage
 *
 *  @return 返回图片路径
 */
+ (NSString *)saveImage:(UIImage *)tempImage;

/**
 *  保存图片
 *
 *  @param tempImage 图片
 *  @param name      图片名称
 *
 *  @return 返回图片路径
 */
+ (NSString *)saveImage:(UIImage *)tempImage withName:(NSString *)name;

/**
 *  清除缓存
 */
+ (void)clearImageCache;

/**
 *  压缩图片大小
 *
 *  @param originImage 原图
 *  @param newSize     新尺寸
 *
 *  @return 返回压缩后的图片
 */
+ (UIImage *)compressImage:(UIImage *)originImage toScale:(CGFloat)scale;

/**
 *  检查头像Url是网络图片还是系统默认下标
 *
 *  @param imageUrl 头像的Url地址
 *
 *  @return 返回检测的系统头像下标，没有则返回-1
 */
//+ (NSInteger)checkHeadImageUrl:(NSString *)imageUrl;

/**
 *  获取视频的缩略图
 *
 *  @param videoUrl 视频url
 *
 *  @return 返回视频的缩略图
 */
+ (UIImage *)thumbnailImageRequest:(NSURL *)videoUrl;

/**
 *  将录制视频转换为MP4格式
 *
 *  @param videoUrl 原视频url
 *  @param completed 转换完成block<转换后的url>
 *
 */
+ (void)convertToMP4WithUrl:(NSURL *)videoUrl completed:(void (^)(NSURL *covertUrl))completed;


@end
