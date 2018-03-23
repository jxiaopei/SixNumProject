//
//  BPNetworkServiceInforModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/13.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPNetworkServiceInforModel : NSObject

@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *domain;
@property(nonatomic,assign)NSInteger removed;
@property(nonatomic,copy)NSString *domainState;
@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,copy)NSString *createUser;
@property(nonatomic,copy)NSString *lastModifyTime;
@property(nonatomic,copy)NSString *operatorUser;
@property(nonatomic,copy)NSString *systemCode;
@property(nonatomic,copy)NSString *privateKey;

@end
