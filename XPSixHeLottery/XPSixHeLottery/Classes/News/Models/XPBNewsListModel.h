//
//  XPBNewsListModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/18.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPBNewsListModel : NSObject

@property (nonatomic, strong) NSString *data_content;
@property (nonatomic, strong) NSString *data_type;
@property (nonatomic, strong) NSString *news_id;//
@property (nonatomic, strong) NSString *news_describe_id;//
@property (nonatomic, strong) NSString *news_title;//
@property (nonatomic, strong) NSString *create_time;

@end
