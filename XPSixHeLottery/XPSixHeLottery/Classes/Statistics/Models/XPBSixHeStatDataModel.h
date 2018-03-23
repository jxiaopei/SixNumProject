//
//  XPBSixHeStatDataModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/7.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPBSixHeStatDataModel : NSObject

@property(nonatomic,copy)NSString *number;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,assign)NSInteger prop_count;
@property(nonatomic,copy)NSString *prop_name;
@property(nonatomic,copy)NSString *periods;

@end
