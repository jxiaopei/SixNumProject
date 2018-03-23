//
//  BPBaseNetworkServiceTool.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/13.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPBaseNetworkServiceTool : NSObject

+(BPBaseNetworkServiceTool *)shareServiceTool;

//-(void)setNetWorkService;

-(void)getAppBaseInfors;

-(void)httpDNSActionWithCompleteBlock:(void(^)())completeBlock failureBlock:(void(^)())failureBlock;

-(void)getUpdateInfor;

@end
