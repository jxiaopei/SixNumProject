//
//  BPBaseViewController.m
//  baseProgram
//
//  Created by iMac on 2017/7/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseViewController.h"

@interface BPBaseViewController ()

@end

@implementation BPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)customBackBtn
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [button setImage:[UIImage imageNamed:@"nav_back_pub_white"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
