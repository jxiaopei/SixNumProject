//
//  AppDelegate.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/4.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "AppDelegate.h"
#import "BPBaseTabBarController.h"
#import "LCIntroView.h"
#import "LCCOllectionInfo.h"

@interface AppDelegate ()

@property(nonatomic,copy)void (^callBack)();

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[BPBaseTabBarController new]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
    [self setupAnimationImage];
    [LCCOllectionInfo getInfo];
    return YES;
}

-(void)setupAnimationImage{
    __block UIImageView *igv = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    igv.image = [UIImage imageNamed:@"splash_2"];
    [self.window addSubview:igv];
    
    UIImageView *goldig = [[UIImageView alloc] initWithFrame:igv.bounds];
    goldig.image = [UIImage imageNamed:@"splash_1"];
    goldig.alpha = 0;
    [igv addSubview:goldig];
    
    UIImageView *caishen = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    caishen.image = [UIImage imageNamed:@"caishen"];
    [igv addSubview:caishen];
    
    CGFloat x = [UIScreen mainScreen].bounds.origin.x;
    CGFloat y = [UIScreen mainScreen].bounds.origin.y;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:1 animations:^{
        caishen.frame = CGRectMake(x, y+30, width, height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
           caishen.frame = CGRectMake(x, y, width, height);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    [UIView animateWithDuration:2 animations:^{
        goldig.alpha = 1;
    } completion:^(BOOL finished) {
    
        _callBack = ^{
            [igv removeFromSuperview];
            igv = nil;
            NSLog(@"%@",igv);
        };
        
        NSLog(@"%@",BaseUrl(OpenAPPAdvList));
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":OpenAPPAdvList,
                               @"paramData":@{}
                               };
        [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(OpenAPPAdvList) parameters:dict success:^(id responseObject) {
//            NSLog(@"%@",[responseObject mj_JSONString]);
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                if ([responseObject[@"data"] count] < 1) {
                    _callBack();
                    return ;
                }
                LCIntroView *introView = [[LCIntroView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                introView.images  = responseObject[@"data"];
                [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:introView];
                _callBack();
            }else{
                
            }
        } fail:^(NSError *error) {
            _callBack();
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (igv) {
            [igv removeFromSuperview];
            igv = nil;
        }
    });

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [BPUserModel shareModel].isLogin = NO;
    NSLog(@"程序被杀死");
}


@end
