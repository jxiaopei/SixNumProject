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

@interface AppDelegate ()

@property(nonatomic,copy)void (^callBack)();

@property(nonatomic,copy)NSString *updateUrl;
@property(nonatomic,strong)BPBaseTabBarController *tabBarVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    BPBaseTabBarController *tabBarVC = [BPBaseTabBarController new];
    _tabBarVC = tabBarVC;
    [self.window setRootViewController:tabBarVC];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
    
    //友盟统计
    [self UMMobstatistics];
    
    //友盟推送
    [self addUMessage:launchOptions];
    
    [self setupAnimationImage];
    [LCCOllectionInfo getInfo];
//    [self init3DTouchShortcutItems];//3D touch
    return YES;
}

- (void)addUMessage:(NSDictionary *)launchOptions {
    
    //初始化
    [UMessage startWithAppkey:AppKey launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    NSString *verson = [UIDevice currentDevice].systemVersion;
    
    if(verson.doubleValue < 10.0)//通知在10.0之后做了调整
    {
        UIMutableUserNotificationAction *openAction = [UIMutableUserNotificationAction new];
        openAction.identifier = @"openId";
        openAction.title = @"打开应用";
        openAction.activationMode = UIUserNotificationActivationModeForeground;
        UIMutableUserNotificationAction *cancelAction = [UIMutableUserNotificationAction new];
        cancelAction.identifier = @"cancelId";
        cancelAction.title = @"忽略";
        cancelAction.activationMode = UIUserNotificationActivationModeBackground;
        cancelAction.authenticationRequired = YES; //解锁才能交互
        cancelAction.destructive = YES;
        UIMutableUserNotificationCategory *notificationCategory = [UIMutableUserNotificationCategory new];
        notificationCategory.identifier = @"notificationCategory";
        [notificationCategory setActions:@[openAction,cancelAction] forContext:UIUserNotificationActionContextDefault];
        NSSet *category = [NSSet setWithObjects:notificationCategory,nil];
        [UMessage registerForRemoteNotifications:category];
    }else{
        
        //iOS10必须加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //设置代理
        center.delegate=(id)self;
        //授权
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                
            } else {
                //点击不允许
            }
        }];
        
        //为通知添加按钮
        UNNotificationAction *openAct10 = [UNNotificationAction actionWithIdentifier:@"openAct10" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *cancelAct10 = [UNNotificationAction actionWithIdentifier:@"cancelAct10" title:@"忽略" options:UNNotificationActionOptionForeground];
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        
        UNNotificationCategory *notificationCategory10 = [UNNotificationCategory categoryWithIdentifier:@"notificationCategory10" actions:@[openAct10,cancelAct10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *category10 = [NSSet setWithObjects:notificationCategory10, nil];
        [center setNotificationCategories:category10];
        
    }
    
}

-(void)UMMobstatistics
{
    [MobClick setLogEnabled:YES];
    
    UMConfigInstance.appKey = AppKey;
    
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];
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


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenStr:\n%@",deviceTokenStr);
    
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:userInfo[@"aps"][@"alert"][@"title"] message:userInfo[@"aps"][@"alert"][@"body"]  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:confirmAction];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
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
    [self getUpdateInfor];
    [self getAppBaseInfors];
}

-(void)getUpdateInfor{
    
    [[BPNetRequest getInstance].sharedManager POST:AppUpdateUrl parameters:AppUpdatePeramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        
        NSString *str = [responseObject mj_JSONString];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if([dictData[@"entity"][@"downloadUrl"] isKindOfClass:[NSDictionary class]]){
        self.updateUrl=[NSString stringWithFormat:@"itms-services:///?action=download-manifest&url=%@",dictData[@"entity"][@"downloadUrl"][@"manifest"]];
        }
        NSInteger isbool=[responseObject[@"entity"][@"versionType"] integerValue];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        if (![appVersion isEqualToString:responseObject[@"entity"][@"version"]]) {
            if (isbool==3) {
                
                [self showUpdateAlertVCWithUpdateMsg:responseObject[@"entity"][@"version"]];
                
            }else if (isbool==4){
                
                [self forcedUpdate];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)forcedUpdate{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有重要新版本更新" message:@"为了给您更好的体验/n请更新到最新版本" preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
    [NSThread sleepForTimeInterval:3.0];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.updateUrl]];
}

-(void)showUpdateAlertVCWithUpdateMsg:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有新版本更新" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.updateUrl]];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃更新" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

-(void)getAppBaseInfors{
    
    NSArray *urlArr = COMPANYURLARR;
    
    for(NSString *urlStr in urlArr){
        [[BPNetRequest getInstance].sharedManager POST:urlStr parameters:COMPANYPARA progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject
                &&responseObject[@"data"]&&[responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self checAppBeingIntercept:responseObject[@"data"][@"url"]];
            }else {
//                [MBProgressHUD showError:@"服务配置出错！"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [MBProgressHUD showError:@"域名初始化请求失败"];
        }];
    }
    
    
}

- (void)checAppBeingIntercept:(NSString *)hostString {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",hostString,AppBeingIntercept]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *time = [NSString stringWithFormat:@"%ul", (int)[[NSDate date] timeIntervalSince1970]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:time forKey:@"time"];
    [dict setObject:@"123" forKey:@"token"];
    [dict setObject:@"1" forKey:@"version"];
    [dict setObject:@"xxx" forKey:@"code"];
    
    NSString *bodyString = [NSString stringWithFormat:@"time=%@&token=123&version=1&code=xxx&signature=%@",time,[dict getMD5]];
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || ![data isKindOfClass:[NSData class]] || data == nil) {
            return ;
        }else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *validate = json[@"data"][@"validate"];
            
            NSMutableString *mstring = [[NSMutableString alloc] init];
            for (int i = 0; i < validate.length; i++) {
                if (i%2 == 0) {
                    NSString *str = [validate substringWithRange:NSMakeRange(i, 1)];
                    [mstring appendString:str];
                }
            }
            if ([mstring isEqualToString:[@"xxx" md5HexDigest]]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    YYCache *cache = [YYCache cacheWithName:CacheKey];
                    [cache setObject:hostString forKey:@"ServerSite"];
                    if (![[self getCurrentVC] isKindOfClass:[UITabBarController class]]) {
                        BPBaseTabBarController *tab=[[BPBaseTabBarController alloc]init];
                        self.window.rootViewController = tab;
                        [self.window makeKeyAndVisible];
                    }
                });
                
            }
        }
    }];
    [dataTask resume];
}

//- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
//    
//    //这里可以获的shortcutItem对象的唯一标识符
//    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
//    NSLog(@"name:%@\ntype:%@", shortcutItem.localizedTitle, shortcutItem.type);
//    NSString *shortcutType = shortcutItem.type;
//    if([shortcutType isEqualToString:@"Search"]){
//        [_tabBarVC setSelectedIndex:1];
//        [UIApplication sharedApplication].keyWindow.rootViewController = [XPBLotteryViewController new];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没错!这就是3D Touch" message:@"惊不惊喜,意不意外?" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"惊喜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.updateUrl]];
//            
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"意外" style:UIAlertActionStyleCancel handler:nil];
//        
//        [alert addAction:confirmAction];
//        [alert addAction:cancelAction];
//        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//    }
//    
//    
//}

//- (void)init3DTouchShortcutItems {
//    
////    if ([UIApplication sharedApplication].shortcutItems.count >= 4)
////    {
////       return;
////    }
//    
//    
//    NSMutableArray *arrShortcutItem = (NSMutableArray *)[UIApplication sharedApplication].shortcutItems;
//    
//    
//    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"Search" localizedTitle:@"被" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeMessage] userInfo:nil];
//    [arrShortcutItem addObject:shoreItem1];
//    
//    
//    
//
//    
//    [UIApplication sharedApplication].shortcutItems = arrShortcutItem;
//    
//    NSLog(@"%lu", [UIApplication sharedApplication].shortcutItems.count);
//}


- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [BPUserModel shareModel].isLogin = NO;
    NSLog(@"程序被杀死");
}


@end
