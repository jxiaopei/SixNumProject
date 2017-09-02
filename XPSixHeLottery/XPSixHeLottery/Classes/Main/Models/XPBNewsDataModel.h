//
//  XPBNewsDataModel.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/17.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPBNewsDataModel : NSObject

@property (nonatomic, copy) NSString *data_type;
@property (nonatomic, copy) NSString *news_link_url;
@property (nonatomic, copy) NSString *news_title;
@property (nonatomic, copy) NSString *news_id;
@property (nonatomic, copy) NSString *news_content;

@end
