//
//  LCAboutViewController.m
//  LotteryClient
//
//  Created by Dick on 2017/7/14.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "LCAboutViewController.h"

@interface LCAboutViewController ()

@property (nonatomic, strong) UILabel *copyrightLabel;

@end

@implementation LCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";

    UIImageView *iconView = [UIImageView new];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(90);
        make.top.mas_equalTo(20);
    }];
    iconView.image = [UIImage imageNamed:@"AppLogo"];
    iconView.clipsToBounds = YES;
    iconView.layer.cornerRadius = 10;
    
    
    UILabel *versionLab = [UILabel new];
    [self.view addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(iconView.mas_bottom).mas_offset(5);
    }];
                           
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    versionLab.text = [NSString stringWithFormat:@"v%@",appCurVersion];//@"v1.0";
    versionLab.textColor = [UIColor blackColor];
    versionLab.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *updateLabel = [UILabel new];
    [self.view addSubview:updateLabel];
    [updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(versionLab.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    updateLabel.text = @"此版本更新点: 增加去评分功能,增加功能介绍,增加投诉功能.";
    updateLabel.font = [UIFont systemFontOfSize:14];
    updateLabel.numberOfLines = 0;
    updateLabel.textColor = [UIColor grayColor];
    
    _copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 50 - 64, SCREENWIDTH, 40)];
    _copyrightLabel.backgroundColor = [UIColor clearColor];
    _copyrightLabel.font = [UIFont systemFontOfSize:12.0f];
    _copyrightLabel.textAlignment = NSTextAlignmentCenter;
    _copyrightLabel.textColor = [UIColor grayColor];
    _copyrightLabel.text = @"Copyright © 2010-2017.\nAll Rights Reserved.";
    _copyrightLabel.numberOfLines = 0;
    [self.view addSubview:_copyrightLabel];
}



@end
