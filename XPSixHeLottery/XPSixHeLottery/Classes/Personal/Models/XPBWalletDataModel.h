//
//  XPBWalletDataModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/10/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPBWalletDataModel : NSObject

@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *task_type_name;
@property(nonatomic,copy)NSString *user_account;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,assign)NSInteger task_type;
@property(nonatomic,assign)NSInteger user_id;

@end
