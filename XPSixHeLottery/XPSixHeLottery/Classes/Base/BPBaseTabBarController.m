//
//  BPBaseTabBarController.m
//  baseProgram
//
//  Created by iMac on 2017/7/24.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseTabBarController.h"
#import "BPBaseNavigationController.h"
#import "XPBMainViewController.h"
#import "XPBPersonalViewController.h"
#import "XPBServiceViewController.h"
#import "XPBLotteryViewController.h"


@interface BPBaseTabBarController ()

@property(nonatomic,assign)NSInteger indexFlag;

@end

@implementation BPBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupViewControllers];
    
}

-(void)setupViewControllers
{
    XPBMainViewController *mainVC = [XPBMainViewController new];
    BPBaseNavigationController *nav = [[BPBaseNavigationController alloc]initWithRootViewController:mainVC];
    UIImage *homeNorImage = [[UIImage imageNamed:@"homeSelected" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *homeSelImage = [[UIImage imageNamed:@"home-1" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"首页" image:homeNorImage selectedImage:homeSelImage];
    
    XPBLotteryViewController *lotteryVC = [XPBLotteryViewController new];
    BPBaseNavigationController *nav1 = [[BPBaseNavigationController alloc]initWithRootViewController:lotteryVC ];
    UIImage *newsNorImage = [[UIImage imageNamed:@"news" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *newsSelImage = [[UIImage imageNamed:@"newsSelected" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"开奖" image:newsNorImage selectedImage:newsSelImage];
    
    XPBServiceViewController *serviceVC = [XPBServiceViewController new];
    BPBaseNavigationController *nav2 = [[BPBaseNavigationController alloc]initWithRootViewController:serviceVC];
    UIImage *staNorImage =  [[UIImage imageNamed:@"hm" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *staSelImage = [[UIImage imageNamed:@"hm_selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"客服" image:staNorImage selectedImage:staSelImage];
    
    XPBPersonalViewController *personalVC = [XPBPersonalViewController new];
    BPBaseNavigationController *nav3 = [[BPBaseNavigationController alloc]initWithRootViewController:personalVC];
    UIImage *personalNorImage = [[UIImage imageNamed:@"personalSelected" ] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *personalSelImage = [[UIImage imageNamed:@"personal"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:personalNorImage selectedImage:personalSelImage];
    

    
    self.viewControllers = @[nav,nav1,nav2,nav3];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor blackColor];
    self.selectedIndex = 0;
    self.indexFlag = 0;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//    
//    if (self.indexFlag != index) {
//        [self animationWithIndex:index];
//    }
//    
}


// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    
    self.indexFlag = index;
    
}



@end
