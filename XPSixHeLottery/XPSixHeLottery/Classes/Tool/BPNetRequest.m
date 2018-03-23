//
//  BPNetRequest.m
//  
//
//  Created by 金晓沛 on 4/8/17.
//  Copyright © 2017 YYQG. All rights reserved.
//

#import "BPNetRequest.h"
#import "AppDelegate.h"
#import "LCNetDataParsing.h"

@interface BPNetRequest ()

@property (nonatomic, assign) MDYNetworkMethod wRequestType;

@end

@implementation BPNetRequest

+ (BPNetRequest *)getInstance{
    static BPNetRequest *netRequest = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netRequest = [[self alloc] init];
    });
    return netRequest;
}

- (AFHTTPSessionManager *)sharedManager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript",nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
    });
    return manager;
}

- (AFHTTPSessionManager *)sharedJsonManager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/html",@"text/javascript",nil];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer  = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
    });
    return manager;
}


/**
 *  Get形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)getJsonWithUrl:(NSString *)urlString
            parameters:(id)parameters
               success:(NetRequestSuccessBlock)success
                  fail:(NetRequestFailedBlock)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 15;
    
    NSMutableDictionary *baseParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    NSMutableString *url = [urlString mutableCopy];
//    [self resetURL:url Parameters:baseParameters];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [Helper hideLoading];
        if (success) {
            NSString *dataStr = [responseObject mj_JSONString];
            NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            success(dict);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Helper hideLoading];
//        [Helper showTip:error.localizedDescription];
        
        if (fail) {
            fail(error);
        }
    }];
}


/**
 *  Post形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postJsonWithUrl:(NSString *)urlString
             parameters:(id)parameters
                success:(NetRequestSuccessBlock)success
                   fail:(NetRequestFailedBlock)fail
{

    AFHTTPSessionManager *manager =  [self sharedManager];
    
    [manager POST:urlString parameters:[LCNetDataParsing inputParsing:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([LCNetDataParsing outputParsing:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (fail) {
            fail(error);
        }
    }];
}

/**
 *  Post形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postJsonDataWithUrl:(NSString *)urlString
             parameters:(id)parameters
                success:(NetRequestSuccessBlock)success
                   fail:(NetRequestFailedBlock)fail
{
    
    AFHTTPSessionManager *manager =  [self sharedJsonManager];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            fail(error);
        }
    }];
}

-(void)postDataWithUrl:(NSString *)urlString parameters:(id)parameters success:(NetRequestSuccessBlock)success fail:(NetRequestFailedBlock)fail
{
    
    AFHTTPSessionManager *manager =  [self sharedManager];
    [manager POST:urlString parameters:[LCNetDataParsing inputParsing:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success([LCNetDataParsing outputImageParsing:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            fail(error);
        }
    }];

}


@end
