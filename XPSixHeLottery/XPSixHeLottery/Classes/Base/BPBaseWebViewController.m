//
//  BPBaseWebViewController.m
//  baseProgram
//
//  Created by iMac on 2017/7/29.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseWebViewController.h"
//#import "BPLotteryViewController.h"

@interface BPBaseWebViewController ()<UIWebViewDelegate>



@end

@implementation BPBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupWebView];
}

-(void)setupWebView
{
    self.webView = [UIWebView new];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.mas_equalTo(0);
    }];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [self.webView loadRequest:request];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSURL *URL = request.URL;
//    NSString *scheme = [URL scheme];

    return YES;
}


//-(void)webViewDidStartLoad:(UIWebView *)webView{
////    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
//}
//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
////    [MBProgressHUD hideHUDForView:self.view];
//    
//}
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
////    [MBProgressHUD hideHUDForView:self.view];
//}


@end
