//
//  XPBBBSDetailsDataModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPBBBSCommentsModel.h"

@interface XPBBBSDetailsDataModel : NSObject

@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,copy)NSString *reply_create_time;
@property(nonatomic,copy)NSString *reply_content;
@property(nonatomic,assign)NSInteger is_top;
@property(nonatomic,copy)NSString *main_time;
@property(nonatomic,assign)BOOL is_essene;
@property(nonatomic,copy)NSString *lottery_result_num;
@property(nonatomic,copy)NSString *post_type;
@property(nonatomic,copy)NSString *post_title;
@property(nonatomic,assign)NSInteger main_id;
@property(nonatomic,copy)NSString *main_user_name;
@property(nonatomic,assign)NSInteger reply_count;
@property(nonatomic,copy)NSString *reply_user_name;
@property(nonatomic,copy)NSString *post_content;
@property(nonatomic,strong)NSArray <XPBBBSCommentsModel *>*reply_list;
@property(nonatomic,copy)NSString *like_user_id;
@property(nonatomic,assign)NSInteger like_count;

@end
