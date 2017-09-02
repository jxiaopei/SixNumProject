//
//  YYQNetRequest.h
//
//
//  Created by 金晓沛 on 4/8/17.
//  Copyright © 2017 YYQG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef NS_ENUM(NSUInteger, MDYNetworkMethod) {
    MDYNetworkMethodGet = 0,
    MDYNetworkMethodPost,
    MDYNetworkMethodPut,
    MDYNetworkMethodDelete
};

//typedef NS_ENUM(NSUInteger, MDYRequestCachePolicy) {
//    MDYReturnCacheDataThenLoad = 0,///< 有缓存就先返回缓存，同步请求数据
//    MDYReloadIgnoringLocalCacheData, ///< 忽略缓存，重新请求
//    MDYReturnCacheDataElseLoad,///< 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
//    MDYReturnCacheDataDontLoad,///< 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
//};

typedef void (^NetRequestSuccessBlock)(id responseObject);//成功Block
typedef void (^NetRequestFailedBlock)(NSError *error);//失败Block
//typedef void (^NetRequestProgressBlock)(float);//进度Block
//typedef void (^MDYResponseCache)(id responseObject);//缓存Block

@interface BPNetRequest : NSObject

/**
 *  单例
 */
+(BPNetRequest *)getInstance;

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
                  fail:(NetRequestFailedBlock)fail;

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
                   fail:(NetRequestFailedBlock)fail;


/**
 *  Post形式提交数据(拦截接口数据用)
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postDataWithUrl:(NSString *)urlString
             parameters:(id)parameters
                success:(NetRequestSuccessBlock)success
                   fail:(NetRequestFailedBlock)fail;
/**
 *  Get形式提交数据(拦截接口数据用)
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
-(void)getDataWithUrl:(NSString *)urlString parameters:(id)parameters success:(NetRequestSuccessBlock)success fail:(NetRequestFailedBlock)fail;

-(void)postListDataWithUrl:(NSString *)urlString parameters:(id)parameters success:(NetRequestSuccessBlock)success fail:(NetRequestFailedBlock)fail;

-(void)getListDataWithUrl:(NSString *)urlString parameters:(id)parameters success:(NetRequestSuccessBlock)success fail:(NetRequestFailedBlock)fail;

@end
