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
#import "XPBLotteryViewController.h"
#import "BPBaseNetworkServiceTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    NSDictionary *dict = @{
//                           @"code_id" : @"160cdab4842f449a7b79c93920ff06a1",
//                           };
//    [[BPNetRequest getInstance] getJsonWithUrl:@"http://47.89.36.37:8088/config/generator-code" parameters:dict success:^(id responseObject) {
//
//        NSLog(@"%@",[responseObject mj_JSONString]);
//
//    } fail:^(NSError *error) {
//
//        NSLog(@"%@",error.description);
// }];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    BPBaseTabBarController *tabBarVC = [BPBaseTabBarController new];
//    _tabBarVC = tabBarVC;
    [self.window setRootViewController:[BPBaseViewController new]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
    
    //友盟统计
//    [self UMMobstatistics];
    //友盟推送
//    [self addUMessage:launchOptions];
    [LCCOllectionInfo getInfo];

    [[YYCache cacheWithName:CacheKey] setObject:@"Yes" forKey:@"signInStatus"];
    
//    [[BPBaseNetworkServiceTool shareServiceTool] httpDNSActionWithCompleteBlock:^{
        [self.window setRootViewController:tabBarVC];
        [[BPBaseNetworkServiceTool shareServiceTool] getUpdateInfor];
//    } failureBlock:^{
//        [self.window setRootViewController:[BPBaseViewController new]];
//        [self exitAction];
//        [[BPBaseNetworkServiceTool shareServiceTool] getUpdateInfor];
//    }];
    
    return YES;
}

-(void)exitAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误,请重新打开app"  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    
    [alert addAction:confirmAction];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


//- (void)addUMessage:(NSDictionary *)launchOptions {
//
//    //初始化
//    [UMessage startWithAppkey:AppKey launchOptions:launchOptions];
//    //注册通知
//    [UMessage registerForRemoteNotifications];
//    NSString *verson = [UIDevice currentDevice].systemVersion;
//
//    if(verson.doubleValue < 10.0)//通知在10.0之后做了调整
//    {
//        UIMutableUserNotificationAction *openAction = [UIMutableUserNotificationAction new];
//        openAction.identifier = @"openId";
//        openAction.title = @"打开应用";
//        openAction.activationMode = UIUserNotificationActivationModeForeground;
//        UIMutableUserNotificationAction *cancelAction = [UIMutableUserNotificationAction new];
//        cancelAction.identifier = @"cancelId";
//        cancelAction.title = @"忽略";
//        cancelAction.activationMode = UIUserNotificationActivationModeBackground;
//        cancelAction.authenticationRequired = YES; //解锁才能交互
//        cancelAction.destructive = YES;
//        UIMutableUserNotificationCategory *notificationCategory = [UIMutableUserNotificationCategory new];
//        notificationCategory.identifier = @"notificationCategory";
//        [notificationCategory setActions:@[openAction,cancelAction] forContext:UIUserNotificationActionContextDefault];
//        NSSet *category = [NSSet setWithObjects:notificationCategory,nil];
//        [UMessage registerForRemoteNotifications:category];
//    }else{
//
//        //iOS10必须加下面这段代码。
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        //设置代理
//        center.delegate=(id)self;
//        //授权
//        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
//        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted) {
//                //点击允许
//
//            } else {
//                //点击不允许
//            }
//        }];
//
//        //为通知添加按钮
//        UNNotificationAction *openAct10 = [UNNotificationAction actionWithIdentifier:@"openAct10" title:@"打开应用" options:UNNotificationActionOptionForeground];
//        UNNotificationAction *cancelAct10 = [UNNotificationAction actionWithIdentifier:@"cancelAct10" title:@"忽略" options:UNNotificationActionOptionForeground];
//        //UNNotificationCategoryOptionNone
//        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
//
//        UNNotificationCategory *notificationCategory10 = [UNNotificationCategory categoryWithIdentifier:@"notificationCategory10" actions:@[openAct10,cancelAct10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
//        NSSet *category10 = [NSSet setWithObjects:notificationCategory10, nil];
//        [center setNotificationCategories:category10];
//
//    }
//
//}

//-(void)UMMobstatistics
//{
//    [MobClick setLogEnabled:YES];
//
//    UMConfigInstance.appKey = AppKey;
//
//    UMConfigInstance.channelId = @"App Store";
//
//    [MobClick startWithConfigure:UMConfigInstance];
//}

-(void)setupAnimationImage{
    
    __block UIImageView *igv = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    igv.image = [UIImage imageNamed:@"launch"];
    [self.window addSubview:igv];
//
//    UIImageView *goldig = [[UIImageView alloc] initWithFrame:igv.bounds];
//    goldig.image = [UIImage imageNamed:@"splash_1"];
//    goldig.alpha = 0;
//    [igv addSubview:goldig];
//    
//    UIImageView *caishen = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    caishen.image = [UIImage imageNamed:@"caishen"];
//    [igv addSubview:caishen];
//    
//    CGFloat x = [UIScreen mainScreen].bounds.origin.x;
//    CGFloat y = [UIScreen mainScreen].bounds.origin.y;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    
//    [UIView animateWithDuration:1 animations:^{
//        caishen.frame = CGRectMake(x, y+30, width, height);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1 animations:^{
//           caishen.frame = CGRectMake(x, y, width, height);
//        } completion:^(BOOL finished) {
//            
//        }];
//    }];
//    
//    [UIView animateWithDuration:2 animations:^{
//        goldig.alpha = 1;
//    } completion:^(BOOL finished) {
//    
//        _callBack = ^{
////            [igv removeFromSuperview];
////            igv = nil;
////            NSLog(@"%@",igv);
//        };
//    
//        NSLog(@"%@",BaseUrl(OpenAPPAdvList));
//        NSDictionary *dict = @{
//                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
//                               @"uri":OpenAPPAdvList,
//                               @"paramData":@{}
//                               };
//        [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(OpenAPPAdvList) parameters:dict success:^(id responseObject) {
//            if([responseObject[@"code"] isEqualToString:@"0000"])
//            {
//                if ([responseObject[@"data"] count] < 1) {
//                    _callBack();
//                    return ;
//                }
//                LCIntroView *introView = [[LCIntroView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                introView.images  = responseObject[@"data"];
//                [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:introView];
//                _callBack();
//            }else{
//                
//            }
//        } fail:^(NSError *error) {
//            _callBack();
//        }];
//    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (igv) {
            [igv removeFromSuperview];
            igv = nil;
        }
    });

}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenStr:\n%@",deviceTokenStr);
    
}



//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    //关闭友盟自带的弹出框
//    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
//
//    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:userInfo[@"aps"][@"alert"][@"title"] message:userInfo[@"aps"][@"alert"][@"body"]  preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
//        [alert addAction:confirmAction];
//
//        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//
//    }
//
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
//
//}

////iOS10新增：处理前台收到通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [UMessage setAutoAlert:NO];
//        //应用处于前台时的远程推送接受
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
//
//    }else{
//        //应用处于前台时的本地推送接受
//    }
//    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
//}

////iOS10新增：处理后台点击通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //应用处于后台时的远程推送接受
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
//
//    }else{
//        //应用处于后台时的本地推送接受
//    }
//
//}


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
    [[BPBaseNetworkServiceTool shareServiceTool] getUpdateInfor];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [BPUserModel shareModel].isLogin = NO;
    NSLog(@"程序被杀死");
}


@end
