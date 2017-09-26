//
//  XPBServiceViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/15.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBServiceViewController.h"

@interface XPBServiceViewController ()

@end

@implementation XPBServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服";
    
    
}

-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    NSString *url = (NSString *)[[YYCache cacheWithName:CacheKey] objectForKey:@"serviceUrl"];
    self.urlString = [url isNotNil]?url : @"";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}







@end
