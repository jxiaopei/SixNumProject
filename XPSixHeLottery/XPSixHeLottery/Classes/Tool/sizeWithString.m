//
//  sizeWithString.m
//  Love500m
//
//  Created by 樊建鑫 on 16/11/15.
//  Copyright © 2016年 LTZS. All rights reserved.
//

#import "sizeWithString.h"

@implementation sizeWithString
+(CGFloat)heightWithString:(NSString *)str andfontSize :(CGFloat)fontSize {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lable.text = str;
    lable.numberOfLines = 1;
    lable.font = [UIFont systemFontOfSize:fontSize];
    [lable sizeToFit];
    return lable.bounds.size.height;
}

+(CGFloat)widthWithString:(NSString *)str andfontSize :(CGFloat)fontSize {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lable.text = str;
    lable.numberOfLines = 1;
    lable.font = [UIFont systemFontOfSize:fontSize];
    [lable sizeToFit];
    return lable.bounds.size.width;
}

+(CGFloat)getSpaceLabelHeight:(NSString *)str withWidh:(CGFloat)width font:(NSInteger)font
{
    NSMutableParagraphStyle *paragphStyle=[[NSMutableParagraphStyle alloc]init];
    paragphStyle.lineSpacing=0;//设置行距为0
    paragphStyle.firstLineHeadIndent=0.0;
    paragphStyle.hyphenationFactor=0.0;
    paragphStyle.paragraphSpacingBefore=0.0;
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paragphStyle, NSKernAttributeName:@1.0f };
    CGSize size=[str boundingRectWithSize:CGSizeMake(width,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

+(NSMutableAttributedString *)setStrColorWithStr:(NSString *)string Corlor:(UIColor*)color font:(UIFont*)fontsize range:(NSRange)range {
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [AttributedStr addAttribute:NSFontAttributeName value:fontsize range:range];
    return AttributedStr;
}

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss aaa"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

-(NSString *)DateTimesWithString:(NSString *)str {
    // 获得有多少秒
    
    NSTimeInterval second = str.longLongValue / 1000.0;
    
    // 时间戳->NSDate
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    format.dateFormat = @"yyyy年MM月dd号 HH:mm:ss aaa";
    return [format stringFromDate:date];
}

-(NSString *)getStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

- (__kindof NSString*__nullable)getTimeInterval:(NSString*__nullable)currentime  {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [formatter dateFromString:currentime];
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    NSString *dural = [NSString stringWithFormat:@"%d时%d分%d秒", hour, minute,second];
    return dural;
}

@end
