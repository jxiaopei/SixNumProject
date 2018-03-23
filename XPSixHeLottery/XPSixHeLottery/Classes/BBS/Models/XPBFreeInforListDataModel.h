//
//  XPBFreeInforListDataModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPBFreeInforListDataModel : NSObject

@property (nonatomic, copy) NSString *main_time;
@property (nonatomic, copy) NSString *post_title;
@property (nonatomic, copy) NSString *lottery_result_num;
@property (nonatomic, copy) NSString *post_content;
@property (nonatomic, assign) BOOL  is_top;
@property (nonatomic, assign) BOOL  is_essene;
@property(nonatomic,copy)NSString *post_type;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) CGFloat rowHeight;


@end
