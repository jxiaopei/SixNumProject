//
//  LCCOllectionInfo.m
//  LotteryClient
//
//  Created by Dick on 2017/8/5.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "LCCOllectionInfo.h"
//#import "LCCollectUserInformationModel.h"
#import "NSString+Utility.h"

#import "sys/utsname.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static NSString * const LCLoginUserAccount  = @"LCLoginUserName";

@implementation LCCOllectionInfo

+ (void)getInfo {
    //    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //    NSLog(@"设备唯一标识符:%@",identifierStr);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    //    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    //    NSString* deviceName = [[UIDevice currentDevice] systemName];
    //    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    //    NSLog(@"手机系统版本: %@", systemVersion);
    //手机型号
    NSString * deviceVersion =  [self deviceVersion];
    //    NSLog(@"手机型号:%@",deviceVersion);
    //地方型号  （国际化区域名称）
    //    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    //    NSLog(@"国际化区域名称: %@",localPhoneModel );
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    //    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    //    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    //    NSLog(@"物理尺寸:%.0f × %.0f",width,height); 
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    //    NSLog(@"分辨率是:%.0f × %.0f",width*scale_screen ,height*scale_screen);
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    //    NSLog(@"运营商:%@", carrier.carrierName);
    //    NSLog(@"IP:%@",[self getIPAddress:YES]);
    //    NSLog(@"Wi-FiIP：%@",[self getCurreWiFiSsid]);
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:LCLoginUserAccount];
    
    NSString *md5String = [[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                            @"user_account",account?account:@"",
                            @"phone_name",userPhoneName,
                            @"phone_model",deviceVersion,
                            @"phone_brand",[self GetNetWorkType],
                            @"phone_system_version",systemVersion,
                            @"app_version",appCurVersion,
                            @"phone_resolution",[NSString stringWithFormat:@"%.0f × %.0f",width*scale_screen ,height*scale_screen],
                            @"phone_operator",carrier.carrierName?carrier.carrierName:@"",
                            @"plat_from",@"iOS",
                            @"screen_size",[NSString stringWithFormat:@"%.0f × %.0f",width,height],
                            @"app_list",@{@"":@""}
                            ] mdf_md5];
    
    NSDictionary *dict = @{@"user_account":account?account:@"",
                           @"phone_name":userPhoneName,
                           @"phone_model":deviceVersion,
                           @"phone_brand":@"Apple",
                           @"phone_system_version":systemVersion,
                           @"app_version":appCurVersion,
                           @"phone_resolution":[NSString stringWithFormat:@"%.0f × %.0f",width*scale_screen ,height*scale_screen],
                           @"phone_operator":carrier.carrierName?carrier.carrierName:@"",
                           @"plat_from":@"iOS",
                           @"net_type":[self GetNetWorkType],
                           @"screen_size":[NSString stringWithFormat:@"%.0f × %.0f",width,height],
                           @"app_list":@{@"":@""}};
    
//    [LCCollectUserInformationModel loadCollectUserInformationWithParams:@{@"MD5":md5String} success:^(id responseObject) {
//        if ([responseObject[@"data"] longValue] == 0) {
//            [LCCollectUserInformationModel loadCollectUserInformationWithParams:@{@"info":dict,@"MD5":md5String} success:^(id responseObject) {
////                NSLog(@"二次%@",responseObject);
//            } failed:^(id error) {
//                
//            }];
//        }
//        
//    } failed:^(id error) {
//        NSLog(@"%@",error);
//    }];
//    
//    [LCCollectUserInformationModel loadDynamicConfigurationWithParams:@{@"app_type":@"0"} success:^(id responseObject) {
//        if (responseObject) {
//            [LCInfoManager sharedInstance].serviceUrl = responseObject[@"customer_server_url"];
//            if ([responseObject[@"app_sign_switch"] isEqualToString:@"1"]) {
//                [LCInfoManager sharedInstance].showIntegral = YES;
//                [[NSNotificationCenter defaultCenter]postNotificationName:LCIsShowSignNotification object:nil];
//            }
//        }
//    } failed:^(id error) {
//        
//    }];
//    
//    [LCCollectUserInformationModel loadVersionMessageSuccess:^(id responseObject) {
//        NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
//        NSString *netVersion = responseObject[@"entity"][@"version"];
//        if ([netVersion isKindOfClass:[NSNull class]]) {
//            return ;
//        }
//        if (![version isEqualToString:netVersion] && [netVersion isNotNil]) {
//            [UIAlertView mdf_showWithTitle:@"提示" message:@"发现新版本，请前去更新哦" buttonsAndOnDismiss:@"确定", ^(UIAlertView *alertView, NSInteger index){
//                NSString *urlStr;
//                if ([responseObject[@"entity"][@"downloadUrl"] isKindOfClass:[NSDictionary class]] && responseObject[@"entity"][@"downloadUrl"][@"manifest"]) {
//                    urlStr = [NSString stringWithFormat:@"itms-services:///?action=download-manifest&url=%@",responseObject[@"entity"][@"downloadUrl"][@"manifest"]];
//                }
//                if (![urlStr containsString:@"https"])
//                    urlStr = @"itms-services:///?action=download-manifest&url=https://app.027051.com/acp/manifest.plist";
//                
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//            }];
//        }
//    } failed:^(id error) {
//        
//    }];
}

+ (NSString*)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}

//- (NSString *)getIPAddress
//{
//    NSString *address = @"error";
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    // retrieve the current interfaces - returns 0 on success
//    success = getifaddrs(&interfaces);
//    if (success == 0)
//    {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while(temp_addr != NULL)
//        {
//            if(temp_addr->ifa_addr->sa_family == AF_INET)
//            {
//                // Check if interface is en0 which is the wifi connection on the iPhone
//                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
//                {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                }
//            }
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    // Free memory
//    freeifaddrs(interfaces);
//    return address;
//}

- (nullable NSString *)getCurreWiFiSsid {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    //    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        //        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [(NSDictionary*)info objectForKey:@"BSSID"];
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
//    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSString *)GetNetWorkType
{
    NSString *strNetworkType = @"";
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability =SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return strNetworkType;
    }
    
    //没有网络
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        return @"";
    }
    
    if ((flags &kSCNetworkReachabilityFlagsConnectionRequired) ==0)
    {
        // if target host is reachable and no connection is required
        // then we'll assume (for now) that your on Wi-Fi
        strNetworkType = @"WIFI";
    }
    
    if (
        ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) !=0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) !=0
        )
    {
        // ... and the connection is on-demand (or on-traffic) if the
        // calling application is using the CFSocketStream or higher APIs
        if ((flags &kSCNetworkReachabilityFlagsInterventionRequired) ==0)
        {
            // ... and no [user] intervention is needed
            strNetworkType = @"WIFI";
        }
    }
    
    if ((flags &kSCNetworkReachabilityFlagsIsWWAN) ==kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >=7.0)
        {
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    strNetworkType =  @"4G";
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    strNetworkType =  @"2G";
                }
                else
                {
                    strNetworkType =  @"3G";
                }
            }
        }
        else
        {
            if((flags &kSCNetworkReachabilityFlagsReachable) ==kSCNetworkReachabilityFlagsReachable)
            {
                if ((flags &kSCNetworkReachabilityFlagsTransientConnection) ==kSCNetworkReachabilityFlagsTransientConnection)
                {
                    if((flags &kSCNetworkReachabilityFlagsConnectionRequired) ==kSCNetworkReachabilityFlagsConnectionRequired)
                    {
                        strNetworkType = @"2G";
                    }
                    else
                    {
                        strNetworkType = @"3G";
                    }
                }
            }
        }
    }
    
    
    if ([strNetworkType isEqualToString:@""]) {
        strNetworkType = @"WWAN";
    }
    
//    NSLog(@"GetNetWorkType() strNetworkType :  %@", strNetworkType);
    
    return strNetworkType;
}

@end
