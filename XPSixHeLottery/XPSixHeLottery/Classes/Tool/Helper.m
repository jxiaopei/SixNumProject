//
//  Helper.m
//
//
//  Created by liliang on 15/6/4.
//  Copyright (c) 2015年 QYJ. All rights reserved.
//

#import "Helper.h"
#import "XPActivityIndicatorView.h"

@interface Helper ()
@end

@implementation Helper
/**
 *  获取当前的格式化时间
 *
 *  @param nil
 *
 *  @return 格式化时间
 */
+ (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/**
 *  获得某天的日期
 *
 *  @param day 和今天间隔多少天
 *
 *  @return 格式化日期
 */
+ (NSString *)getDateFromThisDay:(NSInteger)day {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day]+day)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

/**
 *  获取当前时间戳
 *
 *  @return 时间戳
 */
+ (NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

/**
 *  根据时间戳返回时间字符串
 *
 *  @param time 时间戳
 *
 *  @return 格式化时间
 */
+ (NSString *)getDateStringByTimestamp:(NSString *)time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];

    return dateString;
}

/**
 *  根据时间字符串返回时间对象
 *
 *  @param dateString 日期字符串
 *
 *  @return 日期对象
 */
+ (NSDate*)getDateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

/**
 *  计算时间差
 *
 *  @param theDate 目标时间
 *
 *  @return 相差秒数
 */
+ (NSInteger)intervalSinceNow:(NSString *)theDate {
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [date dateFromString:theDate];
    
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    
    NSTimeInterval cha = now-late;
    
    timeString = [NSString stringWithFormat:@"%f", cha];
    return [timeString integerValue];
}

/**
 *  判断是否包含表情
 *
 *  @param string 需验证的文字
 *
 *  @return 结果
 */
+ (BOOL)stringContainsEmoji:(NSString *)string

{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                
        const unichar hs = [substring characterAtIndex:0];
        
        if (0xd800 <= hs && hs <= 0xdbff) {
            
            if (substring.length > 1) {
                
                const unichar ls = [substring characterAtIndex:1];
                
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    
                    returnValue = YES;
                    
                }
                
            }
            
        } else if (substring.length > 1) {
            
            const unichar ls = [substring characterAtIndex:1];
            
            if (ls == 0x20e3) {
                
                returnValue = YES;
                
            }
            
        } else {
            
            if (0x2100 <= hs && hs <= 0x27ff) {
                
                returnValue = YES;
                
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                
                returnValue = YES;
                
            } else if (0x2934 <= hs && hs <= 0x2935) {
                
                returnValue = YES;
                
            } else if (0x3297 <= hs && hs <= 0x3299) {
                
                returnValue = YES;
                
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                
                returnValue = YES;
                
            }
            
        }
        
    }];
    return returnValue;
}

/**
 *  根据字符串文本后缀判断文件类型
 *
 *  @param aString 文件后缀
 *
 *  @return 文件类型
 */
+ (FileType)getFileType:(NSString *)aString {
    if([aString rangeOfString:@".amr"].location != NSNotFound)
    {
        return FileType_Voice;
    }
    else if([aString rangeOfString:@".png"].location != NSNotFound || [aString rangeOfString:@".jpg"].location != NSNotFound
         || [aString rangeOfString:@".gif"].location != NSNotFound || [aString rangeOfString:@".jpeg"].location != NSNotFound)
    {
        return FileType_Image;
    }
    return FileType_Text;
}

/**
 *  根据颜色返回图片
 *
 *  @param color 颜色
 *
 *  @return 创建的Image对象
 */
+ (UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  根据长度生成随机数数组
 *
 *  @param length 随机的长度
 *
 *  @return 组成的字符串
 */
+ (NSString *)randomArrayWithLength:(NSInteger)length {
    NSString *randomString = @"";
    
    for (NSInteger i = 0; i < length; i++) {
        NSInteger random = arc4random() % 10;
        randomString = [randomString stringByAppendingFormat:@"%ld", random];
    }
    
    return randomString;
}

/**
 *  根据字典生成json字符串
 *
 *  @param dic 字典
 *
 *  @return json的字符串
 */
+ (NSString*)dictionaryToJsonString:(NSDictionary *)dictionary {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

/**
 *  根据json字符串生成字典
 *
 *  @param length 随机的长度
 *
 *  @return 组成的字典
 */
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    return  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
}

/**
 *  获取当前ViewController
 *
 *  @return
 */
+ (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    
    return result;
}

+(BOOL)isPhoneNumber:(NSString *)patternStr{
    
    NSString *pattern = @"^1[34578]\\d{9}$";
    //    NSString *pattern = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}
#pragma mark MBProgressHUD Methods
/**
 *  MBProgressHUD方法
 *
 *  @param tip 提示信息
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
static MBProgressHUD *loadingHud;
static XPActivityIndicatorView *loading;
+ (void)showLoading {
    if (!loadingHud) {
        loadingHud = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow].rootViewController.view];
        loadingHud.mode = MBProgressHUDModeCustomView;
        loadingHud.opacity = 0.5;
        loadingHud.removeFromSuperViewOnHide = YES;
        UIView *custiomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 68, 24)];
        loading = [[XPActivityIndicatorView alloc] initWithImage:[UIImage imageNamed:@"jvhua_bai"]];
        loading.center = custiomView.center;
        [custiomView addSubview:loading];
        [loading startAnimation];
        loadingHud.customView = custiomView;
        [[[UIApplication sharedApplication] keyWindow] addSubview:loadingHud];
        [loadingHud showAnimated:YES];
    }
    else {
        [[[UIApplication sharedApplication] keyWindow] addSubview:loadingHud];
         [loadingHud showAnimated:YES];
        [loading startAnimation];
    }
}

+ (void)hideLoading {
    if(loadingHud) {
        [loadingHud hideAnimated:YES];
        [loading stopAnimation];
    }
}


static MBProgressHUD *tipHud;
+ (void)showTip:(NSString *)tip {
    if (tip.length == 0) {
        return;
    }
    if (!tipHud) {
        tipHud = [MBProgressHUD new];
        tipHud.label.text = tip;
        tipHud.label.font = [UIFont systemFontOfSize:12];
        tipHud.mode = MBProgressHUDModeText;
        tipHud.dimBackground = NO;
        [[[UIApplication sharedApplication] keyWindow] addSubview:tipHud];
        [tipHud showAnimated:YES];
        [tipHud hideAnimated:YES afterDelay:1.5];
    }
    else {
        tipHud.label.text = tip;
        [[[UIApplication sharedApplication] keyWindow] addSubview:tipHud];
        [tipHud showAnimated:YES];
        [tipHud hideAnimated:YES afterDelay:1.5];
    }
}

+ (void)showTip:(NSString *)tip duration:(CGFloat)duration {
    if (tip.length == 0) {
        return;
    }
    if (!tipHud) {
        tipHud = [MBProgressHUD new];
        tipHud.label.text = tip;
        tipHud.label.font = [UIFont systemFontOfSize:12];
        tipHud.mode = MBProgressHUDModeText;
        tipHud.dimBackground = NO;
        [[[UIApplication sharedApplication] keyWindow] addSubview:tipHud];
        [tipHud showAnimated:YES];
        [tipHud hideAnimated:YES afterDelay:duration];
    }
    else {
        tipHud.label.text = tip;
        [[[UIApplication sharedApplication] keyWindow] addSubview:tipHud];
        [tipHud showAnimated:YES];
        [tipHud hideAnimated:YES afterDelay:duration];
    }
}

static MBProgressHUD *progressHud;
+ (void)showProgressWithProgress:(float)progress {
    if (!progressHud) {
        progressHud = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow].rootViewController.view];
        progressHud.mode = MBProgressHUDModeAnnularDeterminate;
        progressHud.opacity = 0.5;
        progressHud.label.text = @"正在上传图片";
        progressHud.label.font = [UIFont systemFontOfSize:12];
        progressHud.progress = progress;
        [[[UIApplication sharedApplication] keyWindow] addSubview:progressHud];
        [progressHud showAnimated:YES];
    }
    else {
        progressHud.progress = progress;
        [progressHud showAnimated:YES];
    }
}

+ (void)hideProgress {
    if(progressHud) {
        [progressHud hideAnimated:YES];
        progressHud = nil;
    }
}
#pragma clang diagnostic pop
@end
