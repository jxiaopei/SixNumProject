//
//  Network.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/16.
//  Copyright © 2017年 eirc. All rights reserved.
//

#ifndef Network_h
#define Network_h

#define NETWORK_STATE 0  //1是正式环境 0是测试环境

#define AppKey @"5981ba3cc62dca68bd0019b5" //友盟appKey
#define AppSecret @" rqyibszrse2zevbi9erxwknhxztpdyx0"  //友盟app 秘钥
#define COMPANYURL @"http://169.56.130.9/index/index/" //公司判断审核开关
#define COMPANYPARA @{@"app_id":@"1258070698"}  //appID
#define CacheKey  @"myCacheKey"
#define LoginUserPassword @"userPassword"
#define UserID        @"UserID"
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH   [UIScreen mainScreen].bounds.size.width
#define StringFormat(string, args...)       [NSString stringWithFormat:string, args]


#define BaseHttpUrl   NETWORK_STATE ? @"http://169.56.130.24:8088" : @"http://172.16.5.237:8088"//@"http://172.16.5.237:8088"//@"http://172.16.3.200:8080"
#define BaseUrl(url)  [NSString stringWithFormat:@"%@%@",BaseHttpUrl,url]

#define HomepageUrl      @"/user/homepage/getIndex"                            //首页
#define LotteryHistory   @"/user/lottery/getAppLotteryHistoryList"             //开奖历史
#define OpenAPPAdvList   @"/user/homepage/queryAdvertisementList"              //引导页
#define ActionsList      @"/app/activity/AppQueryActData"                      //活动列表
//签到
#define SignInDetail     @"/user/integral/queryIntegralTasklList"              //签到任务
#define SignInList       @"/user/integral/querySignInList"                    //签到列表
#define SignInAction     @"/user/integral/insertSignIn"                        //签到
//新闻
#define NewsListPage     @"/user/news/getNewsListPage"                         //新闻
#define NewsDetail       @"/user/news/getNewsDetail"                           //新闻详情
//投票
#define VoteList         @"/user/vote/getVoteList"                             //投票详情
#define VoteAction       @"/user/vote/addVoteData"                             //投票动作
//图库
#define ImagesList       @"/user/image/selectImgerData"                        //图库列表
#define ImageAttention   @"/user/image/addCollectData"                         //图库收藏
#define ImageCancelAtt   @"/user/image/cancelImger"                            //图片取消收藏
#define ImageAttenList   @"/user/image/selectImgerByUserId"                    //图库收藏列表
#define ImageDetail      @"/user/image/selectImgerDetails"                     //图片详情
//个人页面
#define UserPartnerList  @"/user/mobile/userPartner"                           //合作伙伴列表
#define IntegralDetail   @"/user/integral/queryIntegralList"                   //积分详情
#define UserRegist       @"/user/mobile/registerApp"                           //注册
#define UserLogin        @"/user/mobile/loginApp"                              //登录
//论坛
#define BBSList          @"/user/exchange/queryForumList"                      //论坛列表
#define BBSDetail        @"/user/exchange/queryForumDetailList"                //帖子详情
#define BBSComment       @"/user/exchange/insertReplyInfo"                     //评论帖子
#define BBSPublish       @"/user/exchange/insertMainInfo"                      //发表新帖
#define BBSAppreciates   @"/user/exchange/insertMainLikeInfo"                 //点赞帖子
//免费资料
#define FreeInforList    @"/user/datum/queryForumList"                         //免费资料
#define FreeInforDetail  @"/user/datum/queryFreeDatumDetailList"               //免费资料详情
//六合宝典
#define StatisticDetail  @"/user/statistics/lotteryCountData"                  //六合统计
#define StatisReference  @"/user/statistics/queryProperty"                     //属性参考
#define StatisSpeHis     @"/user/statistics/temaHistory"                       //特码历史
#define StatisNorHis     @"/user/statistics/queryEspeciallyNumberHistory"      //正码历史
#define StatisMantHis    @"/user/statistics/queryMantissaHistory"              //尾数大小
#define StatisZodSpe     @"/user/statistics/queryAnimalsEspeciallyNumber"      //生肖特码
#define StatisZodNor     @"/user/statistics/queryAnimalsNormalNumber"          //生肖正码
#define StatisColSpe     @"/user/statistics/queryColorEspeciallyNumber"        //波色特码
#define StatisColNor     @"/user/statistics/queryColorAnimalsNormal"           //波色正码
#define StatisSpeSOD     @"/user/statistics/queryEspeciallyNumberDouble"       //特码两面
#define StatisSpeMant    @"/user/statistics/queryEspeciallyNumberMantissa"     //特码尾数
#define StatisNorMant    @"/user/statistics/queryNormalNumberMantissa"         //正码尾数
#define StatisNorTotal   @"/user/statistics/queryNormalNumberTotal"            //正码总分
#define StatisNumber     @"/user/statistics/queryNumberColor"                  //号码波段
#define StatisAnimal     @"/user/statistics/querySavageHistory"                //家禽野兽

#define CustomerService  @"https://chat6.livechatvalue.com/chat/chatClient/chatbox.jsp?companyID=17779&configID=48708&jid=&s=1"                                   //客服页面

#endif /* Network_h */
