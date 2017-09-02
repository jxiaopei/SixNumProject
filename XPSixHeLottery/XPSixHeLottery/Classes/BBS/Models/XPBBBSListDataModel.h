//
//  XPBBBSListDataModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/25.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPBBBSListDataModel : NSObject

@property (nonatomic, copy) NSString *main_time;
@property (nonatomic, copy) NSString *post_type;
@property (nonatomic, copy) NSString *post_title;
@property (nonatomic, copy) NSString *lottery_result_num;
@property (nonatomic, copy) NSString *main_user_name;
@property (nonatomic, copy) NSString *post_content;
@property (nonatomic, assign) BOOL  is_top;
@property (nonatomic, assign) BOOL  is_essene;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, copy) NSString *like_user_id;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) CGFloat rowHeight;

@end
