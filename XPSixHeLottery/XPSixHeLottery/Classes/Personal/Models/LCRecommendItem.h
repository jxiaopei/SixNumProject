//
//  LCRecommendItem.h
//  LotteryClient
//
//  Created by Dick on 2017/7/12.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCRecommendItem : NSObject

@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *link_url;
@property (nonatomic, strong) NSString *show_flag;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type_name;

@end
