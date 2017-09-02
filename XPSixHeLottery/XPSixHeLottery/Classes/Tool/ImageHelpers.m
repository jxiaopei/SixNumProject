//
//  ImageHelper.m
//  SmartWatch
//
//  Created by liliang on 15/10/21.
//  Copyright © 2015年 liliang. All rights reserved.
//

#import "ImageHelpers.h"


@implementation ImageHelpers : NSObject 

/**
 *  保存图片
 *
 *  @param tempImage
 *
 *  @return 返回图片路径
 */
+ (NSString *)saveImage:(UIImage *)tempImage {
    return [self saveImage:tempImage withName:@"tmp"];
}

/**
 *  保存图片
 *
 *  @param tempImage 图片
 *  @param name      图片名称
 *
 *  @return 返回图片路径
 */
+ (NSString *)saveImage:(UIImage *)tempImage withName:(NSString *)name {
    NSData *imageData;
    NSString *imageSuffix;//图片后缀
    
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
        imageSuffix = @".png";
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
        imageSuffix = @".jpeg";
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", name, imageSuffix]];
    
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    return fullPathToFile;
}

/**
 *  清除缓存
 */
//+ (void)clearImageCache {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *path = [paths objectAtIndex:0];
//    
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            //如有需要，加入条件，过滤掉不想删除的文件
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            [fileManager removeItemAtPath:absolutePath error:nil];
//        }
//    }
//    [[SDImageCache sharedImageCache] clearMemory];
//}

/**
 *  压缩图片大小
 *
 *  @param originImage 原图
 *  @param newSize     新尺寸
 *
 *  @return 返回压缩后的图片
 */
+ (UIImage *)compressImage:(UIImage *)image toScale:(CGFloat)scale{
    if (scale == 0) {
        NSData *imageData = UIImagePNGRepresentation(image);
        if (imageData.length/1024 < 300) {
            return image;
        }
        scale = sqrt(205.0*1024/imageData.length);
    }
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scale, image.size.height*scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width*scale, image.size.height*scale)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

/**
 *  获取视频的缩略图
 *
 *  @param videoUrl 视频url
 *
 *  @return 返回视频的缩略图
 */
//录制完成，根据指定时间生成缩略图
+ (UIImage *)thumbnailImageRequest:(NSURL *)videoUrl {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef cgImage = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    //缩略图
    UIImage *thumb = [[UIImage alloc] initWithCGImage:cgImage];
    
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }

    //剪切缩略图
    UIImage *image = thumb;
    CGRect mCGRect = CGRectMake(0, 0, 480, 360);
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;

    //    //保存到相册
    //    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    //    CGImageRelease(image);
}

/**
 *  将录制视频转换为MP4格式
 *
 *  @param videoUrl 原视频url
 *  @param completed 转换完成block<转换后的url>
 *  
 */
+ (void)convertToMP4WithUrl:(NSURL *)videoUrl completed:(void (^)(NSURL *covertUrl))completed {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                          presetName:AVAssetExportPreset640x480];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
    exportSession.outputURL = [NSURL fileURLWithPath:mp4Path];
    exportSession.outputFileType = AVFileTypeMPEG4;

    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusFailed: {
                NSLog(@"转换失败");
            }
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                break;
            case AVAssetExportSessionStatusCompleted: {
                if (completed) {
                    completed(exportSession.outputURL);
                }
            }
                break;
            default:
                break;
        }
    }];
}

@end
