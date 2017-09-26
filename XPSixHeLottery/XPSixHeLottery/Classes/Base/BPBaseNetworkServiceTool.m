//
//  BPBaseNetworkServiceTool.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/13.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "BPBaseNetworkServiceTool.h"
#import "BPNetworkServiceInforModel.h"
#import "BPBaseTabBarController.h"

@interface BPBaseNetworkServiceTool()

//@property(nonatomic,strong)NSArray <BPNetworkServiceInforModel *>*serviceInforArr;
@property(nonatomic,strong)NSMutableArray <BPNetworkServiceInforModel *>*invalidUrlArr;


@end

@implementation BPBaseNetworkServiceTool

+(BPBaseNetworkServiceTool *)shareServiceTool
{
    static BPBaseNetworkServiceTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [self new];
    });
    return tool;
}

-(void)setNetWorkService{
    
    NSDictionary *paramers = @{@"paramData":@{@"code":@"lhc"},
                               @"uri":@"/getDomainMapper",
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef"};
    [[BPNetRequest getInstance]postJsonDataWithUrl:AppNetwork parameters:paramers success:^(id responseObject) {
        if([responseObject[@"stat"] integerValue] == 0){
            NSArray <BPNetworkServiceInforModel *>*serviceInforArr = [BPNetworkServiceInforModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            if(serviceInforArr.count){
                //请求回来若干个域名进行轮询
                for(int i = 0;i < serviceInforArr.count;i++){
                    BPNetworkServiceInforModel *inforModel = serviceInforArr[i];
                    [self checAppBeingIntercept:inforModel success:^{
                        //测试域名成功 上传失效域名
                        [self updateInvalidURLs];
                        YYCache *cache = [YYCache cacheWithName:CacheKey];
                        [cache setObject:inforModel.domain forKey:@"serviceHost"];
                        
                        [[UIApplication sharedApplication] keyWindow].rootViewController = [BPBaseTabBarController new]; //成功则指向tabBarController 失败则保留在空白页
                        return ;
                    }callback:^{
                        [self.invalidUrlArr addObject:inforModel];
                        if(i == serviceInforArr.count - 1){
                            //测试域名全部失败 上传失效域名
                            [self updateInvalidURLs];
                        }
                    }];
                }
            }
        }else{
        
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}

-(void)getAppBaseInfors{
    
    NSLog(@"%@",BaseUrl(AppInitialize));
    
    NSDictionary *paramers = @{@"paramData":@{@"app_type":@1},
                               @"uri":AppInitialize,
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef"};
    
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(AppInitialize) parameters:paramers success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            YYCache *cache = [YYCache cacheWithName:CacheKey];
            NSString *signInStatus = nil;
            
            if([responseObject[@"data"][@"signInStatus"][0][@"mission_status"] integerValue] == 0){
                signInStatus = @"Yes";
                [cache setObject:signInStatus forKey:@"signInStatus"];
            }else{
                signInStatus = @"No";
                [cache setObject:signInStatus forKey:@"signInStatus"];
            }
            NSString *serviceUrl = responseObject[@"data"][@"service"][@"customer_server_url"];
            if([serviceUrl isNotNil]){
                [cache setObject:serviceUrl forKey:@"serviceUrl"];
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)updateInvalidURLs{
    NSMutableArray *muArr = [NSMutableArray array];
     if( !_invalidUrlArr || self.invalidUrlArr.count == 0)
    {
        return;
    }
    for(BPNetworkServiceInforModel *inforModel in _invalidUrlArr){
        
        NSDictionary *dict = @{@"id":[NSString stringWithFormat:@"%zd",inforModel.Id],
                               @"domainState":@1,
                               @"systemCode":@"lhc",
                               @"domain":inforModel.domain,};
        [muArr addObject:dict];
    }
    
    if(muArr.count == 0)
    {
        return;
    }
    
    NSDictionary *paramers = @{@"paramData":@{@"changes":muArr.copy},
                               @"uri":AppUpdateInvalidUrl,
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef"};
    [[BPNetRequest getInstance]postJsonDataWithUrl:AppUpdateInvalidUrl parameters:paramers success:^(id responseObject) {
        if([responseObject[@"stat"]  integerValue] == 0){
           
            
        }else{
            
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}


- (void)checAppBeingIntercept:(BPNetworkServiceInforModel *)inforModel success:(void(^)())success callback:(void(^)())callback{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dayStr = [dateStr substringFromIndex:dateStr.length - 2];
    NSString *key = inforModel.privateKey;
    if(![inforModel.privateKey isNotNil]){
       key = @"";
    }
    NSString *md5string = [NSString stringWithFormat:@"lhc%@%@%@",dateStr,dayStr,[NSString md5:key]];
    NSString *md5Str = [NSString md5:md5string];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",inforModel.domain,AppCheckHostAvailable];
    NSDictionary *paramers = @{@"paramData":@{@"date":dateStr,
                                              @"check_dn" :md5Str,
                                              @"host":@"lhc"},
                               @"uri":AppCheckHostAvailable,
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef"};
    
    [[BPNetRequest getInstance]postJsonWithUrl:url parameters:paramers success:^(id responseObject) {
        
        if([responseObject[@"stat"] integerValue] == 0){

            NSInteger dayNum = [dayStr integerValue] * 2;
            NSString *newDateStr = [NSString stringWithFormat:@"%@%02zd",[dateStr substringToIndex:dateStr.length-2],dayNum];
            NSString *mathStr = [NSString stringWithFormat:@"%@%@lhc%@",dayStr,newDateStr,[NSString md5:key]];
            NSLog(@"key === %@",mathStr);
            NSString *newMd5Str = [NSString md5:mathStr];
            if([newMd5Str isEqualToString:responseObject[@"data"][@"check_dn"] ]){
                success();
            }else{
                callback();
            }
            
        }else{
            callback();
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error.description);
//        callback();
    }];
   
}


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

-(NSMutableArray <BPNetworkServiceInforModel *>*)invalidUrlArr{
    if(_invalidUrlArr == nil){
        _invalidUrlArr = [NSMutableArray new];
    }
    return _invalidUrlArr;
}

@end
