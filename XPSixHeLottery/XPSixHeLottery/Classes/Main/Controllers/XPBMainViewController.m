//
//  XPBMainViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/4.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBMainViewController.h"
#import "BPBannerViewCell.h"
#import "BPBannerModel.h"
#import "BPBaseWebViewController.h"
#import "XPBNewsListViewController.h"
#import "XPBNewsDetailViewController.h"
#import "XPBNewsViewController.h"
#import "XPBLotteryHistroyViewController.h"
#import "XPBVoteViewController.h"
#import "XPBBBSViewController.h"
#import "XPBStatisticsViewController.h"
#import "XPBFreeInforListViewController.h"
#import "XPBCooperationListViewController.h"
#import "XPBLoginViewController.h"
#import "XPBSignInViewController.h"
#import "XPBActionViewController.h"
#import "XPBNewsDataModel.h"
#import "LCMarqueView.h"
#import "XPBMarkSixLotteryModel.h"
#import "XPBCooperationPartnerModel.h"
#import "XPBMainPageCollectionViewCell.h"
#import "XPBMainpageNewsTableViewCell.h"
#import "BPBaseNetworkServiceTool.h"

@interface XPBMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,copy)NSString *lotteryUrl;
//轮播
@property(nonatomic,strong)UICollectionView *bannerView;
@property(nonatomic,strong)LCMarqueView *mar;
@property(nonatomic,strong)NSMutableArray <BPBannerModel *>*bannerArr;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger page;
//开奖内容
@property(nonatomic,copy)void(^lotteryViewGetDataBlock)(XPBMarkSixLotteryModel *lotteryDataModel);
@property(nonatomic,strong)XPBMarkSixLotteryModel *lotteryDataModel;
//图标
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *titleArr;
//中间广告
@property(nonatomic,strong)UICollectionView *advertimentsView;
@property(nonatomic,strong)NSMutableArray <BPBannerModel *>*advArr;
@property(nonatomic,assign)NSInteger advPage;
//资料
@property(nonatomic,strong)UICollectionView *inforView;
@property(nonatomic,strong)NSMutableArray *inforTitleArr;
//新闻
@property(nonatomic,strong)NSMutableArray <XPBNewsDataModel *>*newsArr;
@property(nonatomic,strong)UIView *newsView;
@property(nonatomic,strong)UITableView *newsTableView;
@property(nonatomic,copy)void(^newsViewGetDataBlock)(XPBNewsDataModel *newsDataModel);
@property(nonatomic,assign)BOOL isScrolling;
@property(nonatomic,assign)NSInteger newsIndex;
//合作伙伴
@property(nonatomic,strong)NSMutableArray <XPBCooperationPartnerModel *> *partnerArr;
@property(nonatomic,copy)void(^partnerViewGetDataBlock)(NSMutableArray <XPBCooperationPartnerModel *> *partnerArr);

@end

@implementation XPBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightBtn];
    [self setupLeftBtn];
    [self setupNavigationTitleView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLoginSuccessed) name:@"loginSuccessed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLogoutSuccessed) name:@"logoutSuccessed" object:nil];
    _titleArr = [NSMutableArray arrayWithObjects:@"直播",@"图库",@"投票",@"论坛",@"竞彩",@"活动", nil];
    _inforTitleArr = [NSMutableArray arrayWithObjects:@"免费资料",@"六合宝典",@"敬请期待", nil];
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    _scrollview = scrollView;
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, 1015);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    _scrollview.mj_header = header;
    
    [self setupBannerView];
    [self setupNewsView];
    [self setupLotteryView];
    [self setupCollectionView];
    [self setupAdvertimentsView];
    [self setupInforView];
    [self setupCooperationPartnerView];
    [self getData];
    self.page = 0;
    [self setupTimer];
}

-(void)didLogoutSuccessed{
   [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
}

-(void)didLoginSuccessed{
    [_loginBtn setTitle:[BPUserModel shareModel].userName forState:UIControlStateNormal ];
}

-(void)setupNavigationTitleView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0 , 0, 96, 44);
    UIImageView *imageview = [ UIImageView new];
    imageview.frame = CGRectMake(0 , 0, 96, 44);
    [view addSubview:imageview];
    imageview.image = [UIImage imageNamed:@"titleViewLogo"];
    self.navigationItem.titleView = view;
}

-(void)setupRightBtn{
    UIButton *loginBtn = [UIButton new];
    loginBtn.frame = CGRectMake(0, 0, 100, 25);
    _loginBtn = loginBtn;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    loginBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(didClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:loginBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)setupLeftBtn{
//    if(![[YYCache cacheWithName:CacheKey] objectForKey:@"signInStatus"] ){
//        return;
//    }
    UIButton *signInBtn = [UIButton new];
    signInBtn.frame = CGRectMake(0, 0, 40, 25);
    [signInBtn setTitle:@"签到" forState:UIControlStateNormal];
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    signInBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    signInBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInBtn addTarget:self action:@selector(didClickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:signInBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)didClickLeftBtn:(UIButton *)sender{
    if(![BPUserModel shareModel].isLogin){
        XPBLoginViewController *loginVC = [XPBLoginViewController new];
        loginVC.popVC = self;
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        XPBSignInViewController *signInVC = [XPBSignInViewController new];
        [self.navigationController pushViewController:signInVC animated:YES];
    }
}

-(void)didClickRightBtn:(UIButton *)sender{
    
    if(![BPUserModel shareModel].isLogin){
        XPBLoginViewController *loginVC = [XPBLoginViewController new];
        loginVC.popVC = self;
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        [self.tabBarController setSelectedIndex:3];
    }
}

-(void)getData
{
    NSLog(@"%@",BaseUrl(HomepageUrl));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":HomepageUrl,
                           @"paramData":@{}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(HomepageUrl) parameters:dict success:^(id responseObject) {
        [_scrollview.mj_header endRefreshing];
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [self.bannerArr removeAllObjects];
            [self.advArr removeAllObjects];
            self.bannerArr = [BPBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"banner"]];
            self.advArr = [BPBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"bannerCenter"]];
            _mar.runString = responseObject[@"data"][@"marque"];
            [self.bannerView reloadData];
            [self.advertimentsView reloadData];
            self.lotteryUrl = responseObject[@"data"][@"biddingUrl"][@"lottery_url"];

            //暂时屏蔽新闻模块
//            self.newsArr = [XPBNewsDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"news"]];
            if(self.newsArr.count == 0)
            {
                _newsView.hidden = YES;
                _bottomView.frame = CGRectMake(0, 180, SCREENWIDTH, 630);
                _scrollview.contentSize = CGSizeMake(SCREENWIDTH, 820);
            }else{
                _newsView.hidden = NO;
                _bottomView.frame = CGRectMake(0, 300, SCREENWIDTH, 630);
                _scrollview.contentSize = CGSizeMake(SCREENWIDTH, 940);
                [_newsTableView reloadData];
                [self beginScrollTheNewsView];
            }
            
            _lotteryDataModel = [XPBMarkSixLotteryModel mj_objectWithKeyValues:responseObject[@"data"][@"lottery_result"]];
            self.lotteryViewGetDataBlock(_lotteryDataModel);
            
            self.partnerArr = [XPBCooperationPartnerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"partner_list"]];
            self.partnerViewGetDataBlock(self.partnerArr);
        }
        
    } fail:^(NSError *error) {
        [_scrollview.mj_header endRefreshing];
    }];
}

-(void)beginScrollTheNewsView{
    if(_isScrolling){
        return;
    }
    if(_newsArr.count <=1){
        return;
    }
    [self scrollNews];
}

-(void)scrollNews{
    _isScrolling = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 animations:^{
            [_newsTableView setContentOffset:CGPointMake(0, 85 * _newsIndex++)];
        } completion:^(BOOL finished) {
            if (_newsIndex == _newsArr.count) {
                _newsIndex = 0;
                [_newsTableView  setContentOffset:CGPointMake(0, 0)];
            }
        }];
        [self scrollNews];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[BPBaseNetworkServiceTool shareServiceTool] getAppBaseInfors];
    [_mar startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mar stopAnimation];
}

-(void)setupBannerView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH, 180);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *bannerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180) collectionViewLayout:layout];
    [self.scrollview addSubview:bannerView];
    bannerView.tag = 100;
    bannerView.backgroundColor = [UIColor whiteColor];
    _bannerView = bannerView;
    bannerView.pagingEnabled = YES;
    bannerView.delegate = self;
    bannerView.dataSource = self;
    [bannerView registerClass:[BPBannerViewCell class] forCellWithReuseIdentifier:@"bannerViewCell"];
    _mar = [[LCMarqueView alloc]initWithFrame:CGRectMake(0, 155, SCREENWIDTH, 25)];
    [self.scrollview addSubview:_mar];
}

-(void)setupNewsView{
    _newsIndex = 0;
    _isScrolling = NO;
    UIView *newsView = [UIView new];
    _newsView = newsView;
    [self.scrollview addSubview:newsView];
    newsView.frame = CGRectMake(0, 180, SCREENWIDTH, 120);
    UIView *titleView = [UIView new];
    [newsView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView *rightImage = [UIImageView new];
    [titleView addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.mas_equalTo(titleView.mas_centerY);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(8);
    }];
    rightImage.image = [UIImage imageNamed:@"arrow_right"];
    
    UIButton *titleBtn = [UIButton new];
    [titleView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(titleView);
    }];
    [titleBtn addTarget:self action:@selector(didClickNewsShowMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *redView = [UIView new];
    [titleView addSubview:redView];
    redView.backgroundColor = [UIColor redColor];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(4);
    }];
    
    UITableView *tableView = [UITableView new];
    [newsView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(85);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = YES;
    [tableView registerClass:[XPBMainpageNewsTableViewCell class] forCellReuseIdentifier:@"mainpageNewsCell"];
    _newsTableView = tableView;
    
    
    UILabel *newsLabel = [UILabel new];
    [newsView addSubview:newsLabel];
    [newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.left.mas_equalTo(redView.mas_right).mas_offset(5);
    }];
    newsLabel.font = [UIFont systemFontOfSize:18];
    newsLabel.textColor = [UIColor blackColor];
    newsLabel.text = @"热门新闻";
    
    UIView *lineView = [UIView new];
    [titleView addSubview:lineView];
    lineView.backgroundColor = GlobalLightGreyColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    

    UIView *lineView1 = [UIView new];
    [newsView addSubview:lineView1];
    lineView1.backgroundColor = GlobalLightGreyColor;
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    
}

-(void)didClickNewsShowMoreBtn:(UIButton *)sender
{
    XPBNewsListViewController *newsListVC = [XPBNewsListViewController new];
    [self.navigationController pushViewController:newsListVC animated:YES];
}

-(void)setupLotteryView
{
    UIView *bottomView = [UIView new];
    [self.scrollview addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, 300, SCREENWIDTH, 630);
    _bottomView = bottomView;
    
    UIView *lotteryView = [UIView new];
    [_bottomView addSubview:lotteryView];
    lotteryView.frame = CGRectMake(0, 0, SCREENWIDTH, 125);

    UIView *verView = [UIView new];
    [lotteryView addSubview:verView];
    [verView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(15);
    }];
    verView.backgroundColor = [UIColor redColor];
    
    UILabel *peroidLabel = [UILabel new];
    [lotteryView addSubview:peroidLabel];
    [peroidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(verView.mas_centerY);
        make.left.mas_equalTo(verView.mas_right).mas_offset(5);
    }];
    peroidLabel.font = [UIFont systemFontOfSize:16];
    peroidLabel.textColor = [UIColor blackColor];
    peroidLabel.text = @"第000期开奖结果";
    
    UILabel *dateLabel = [UILabel new];
    [lotteryView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(peroidLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(verView.mas_centerY);
    }];
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.text = @"0000.00.00 00:00";
    dateLabel.textColor = [UIColor grayColor];
    
    UIButton *historyBtn = [UIButton new];
    [lotteryView addSubview:historyBtn];
    [historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(verView.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [historyBtn setTitle:@"历史 》" forState:UIControlStateNormal];
    [historyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    historyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [historyBtn addTarget:self action:@selector(didClickHistoryBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *btnArr = [NSMutableArray new];
    NSMutableArray *labelArr = [NSMutableArray new];
    
    CGFloat btnW = 30;
    CGFloat margant = (SCREENWIDTH - btnW *7 -20 - 25)/7;
    for(int i= 0; i< 6;i++)
    {
        UIButton *btn = [UIButton new];
        [lotteryView addSubview:btn];
        
        btn.frame = CGRectMake(10 + (margant + btnW) * i, 45, btnW, btnW);
        [btn setBackgroundImage:[UIImage imageNamed:@"红波"] forState:UIControlStateNormal];
        [btn setTitle:@"00" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = i;
        UILabel *zodiaLabel = [UILabel new];
        [lotteryView addSubview:zodiaLabel];
        zodiaLabel.frame = CGRectMake(10 + (margant + btnW) * i,50 + btnW, btnW, 30);
        zodiaLabel.textColor = [UIColor blackColor];
        zodiaLabel.textAlignment = NSTextAlignmentCenter;
        zodiaLabel.font = [UIFont systemFontOfSize:13];
        zodiaLabel.text = @"龙";
        [btnArr addObject:btn];
        [labelArr addObject:zodiaLabel];
    }
    
    UIButton *plusBtn = [UIButton new];
    [lotteryView addSubview:plusBtn];
    plusBtn.frame = CGRectMake(10 + (margant + btnW) * 6,45, 25, btnW);
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    [plusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    plusBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    
    UIButton *spcNumBtn = [UIButton new];
    [lotteryView addSubview:spcNumBtn];
    spcNumBtn.frame = CGRectMake(10 + (margant + btnW) * 6 + margant +25, 45, btnW, btnW);
    [spcNumBtn setBackgroundImage:[UIImage imageNamed:@"绿波"] forState:UIControlStateNormal];
    [spcNumBtn setTitle:@"00" forState:UIControlStateNormal];
    [spcNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    spcNumBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UILabel *spcZodiaLabel = [UILabel new];
    [lotteryView addSubview:spcZodiaLabel];
    spcZodiaLabel.frame = CGRectMake(10 + (margant + btnW) * 6 + margant +25, 50 + btnW, btnW, 30);
    spcZodiaLabel.textColor = [UIColor blackColor];
    spcZodiaLabel.font = [UIFont systemFontOfSize:13];
    spcZodiaLabel.textAlignment = NSTextAlignmentCenter;
    spcZodiaLabel.text = @"龙";
    
    [btnArr addObject:spcNumBtn];
    [labelArr addObject:spcZodiaLabel];
    
    self.lotteryViewGetDataBlock = ^(XPBMarkSixLotteryModel *lotteryDataModel) {
        
        NSString *dateStr = [lotteryDataModel.next_date insertStandardTimeFormatWithIntegral];
        dateLabel.text = [NSString stringWithFormat:@"%@",[dateStr substringToIndex:dateStr.length-2]];
        XPBMarkSixLotteryDataModel * lotteryModel = lotteryDataModel.lottery_list;
        peroidLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",[lotteryModel.lottery_nper substringFromIndex:4] ];
        for(int i =0; i < lotteryModel.lottery_result.count;i++){
            XPBLotteryModel *dataModel = lotteryModel.lottery_result[i];
            UIButton *btn = btnArr[i];
            [btn setBackgroundImage:[UIImage imageNamed:dataModel.colour] forState:UIControlStateNormal];
            [btn setTitle:dataModel.number forState:UIControlStateNormal];
            UILabel *label = labelArr[i];
            label.text = dataModel.name;
        }
    };
}

-(void)didClickHistoryBtn:(UIButton *)sender{
    
    XPBLotteryHistroyViewController *histroyVC = [XPBLotteryHistroyViewController new];
    [self.navigationController pushViewController:histroyVC animated:YES];
}

-(void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREENWIDTH -2*2)/3, 85);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 125, SCREENWIDTH, 190) collectionViewLayout:layout];
    [_bottomView addSubview:collectionView];
    collectionView.tag = 200;
    collectionView.backgroundColor = GlobalLightGreyColor;
    _collectionView = collectionView;
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setContentInset:UIEdgeInsetsMake(10,0,10,0)];
    [collectionView registerClass:[XPBMainPageCollectionViewCell class] forCellWithReuseIdentifier:@"mainPageCell"];
}

-(void)setupAdvertimentsView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH, 100);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *advertimentsView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 315, SCREENWIDTH, 100) collectionViewLayout:layout];
    [self.bottomView addSubview:advertimentsView];
    advertimentsView.tag = 300;
    advertimentsView.backgroundColor = [UIColor whiteColor];
    _advertimentsView = advertimentsView;
    advertimentsView.pagingEnabled = YES;
    advertimentsView.delegate = self;
    advertimentsView.dataSource = self;
    [advertimentsView registerClass:[BPBannerViewCell class] forCellWithReuseIdentifier:@"advertimentsViewCell"];
}

-(void)setupInforView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREENWIDTH -2*2)/3, 85);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 415, SCREENWIDTH, 105) collectionViewLayout:layout];
    [_bottomView addSubview:collectionView];
    collectionView.tag = 400;
    collectionView.backgroundColor = GlobalLightGreyColor;
    _inforView = collectionView;
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setContentInset:UIEdgeInsetsMake(10,0,10,0)];
    [collectionView registerClass:[XPBMainPageCollectionViewCell class] forCellWithReuseIdentifier:@"inforViewCell"];
    
}

-(void)setupCooperationPartnerView{
    
    UIView *cooperationView = [UIView new];
    [self.bottomView addSubview:cooperationView];
    cooperationView.frame = CGRectMake(0, 520, SCREENWIDTH, 100);
    UIView *titleView = [UIView new];
    [cooperationView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    UIView *verView = [UIView new];
    [titleView addSubview:verView];
    [verView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(titleView.mas_centerY);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(15);
    }];
    verView.backgroundColor = [UIColor redColor];
    
    UILabel *cooperationLabel = [UILabel new];
    [titleView addSubview:cooperationLabel];
    [cooperationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.left.mas_equalTo(verView.mas_right).mas_offset(5);
    }];
    cooperationLabel.font = [UIFont systemFontOfSize:15];
    cooperationLabel.textColor = [UIColor blackColor];
    cooperationLabel.text = @"合作伙伴";
    
    UIView *lineView = [UIView new];
    [titleView addSubview:lineView];
    lineView.backgroundColor = GlobalLightGreyColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *lineViewTop = [UIView new];
    [titleView addSubview:lineViewTop];
    lineViewTop.backgroundColor = GlobalLightGreyColor;
    [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *moreLabel = [UILabel new];
    [titleView addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    moreLabel.text = @"更多 》";
    moreLabel.font = [UIFont systemFontOfSize:13];

    
    UIButton *showMoreBtn = [UIButton new];
    [titleView addSubview:showMoreBtn];
    [showMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(0);
    }];
    [showMoreBtn addTarget:self action:@selector(didClickShowMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *partView = [UIView new];
    [cooperationView addSubview:partView];
    partView.frame = CGRectMake(0, 38, SCREENWIDTH, 100 - 38);
    CGFloat imageW = 60;
    CGFloat margant = (SCREENWIDTH - 60 - 60 * 3)/2;
    NSMutableArray *labelarr = [NSMutableArray new];
    NSMutableArray *imgViewArr = [NSMutableArray new];
    for(int i = 0; i < 3; i++)
    {
        UIImageView *cooperationIcon = [UIImageView new];
        [partView addSubview:cooperationIcon];
        cooperationIcon.frame = CGRectMake(30+(imageW + margant)*i, 0, imageW, imageW);
        [cooperationIcon sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"占位图"]];
        [imgViewArr addObject:cooperationIcon];
        UILabel *cooperationLab = [UILabel new];
        [partView addSubview:cooperationLab];
        [cooperationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cooperationIcon.mas_bottom).mas_offset(5);
            make.centerX.mas_equalTo(cooperationIcon.mas_centerX);
            make.width.mas_equalTo(100);
        }];
        cooperationLab.font = [UIFont systemFontOfSize:13];
        cooperationLab.textColor = [UIColor blackColor];
        cooperationLab.textAlignment = NSTextAlignmentCenter;
        cooperationLab.adjustsFontSizeToFitWidth = YES;
        cooperationLab.text = @"合作伙伴";
        [labelarr addObject:cooperationLab];
        
        UIButton *btn = [UIButton new];
        [partView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(cooperationLab.mas_left);
            make.right.mas_equalTo(cooperationLab.mas_right);
        }];
        [btn addTarget:self action:@selector(didClickCooperationBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
    }
    
    self.partnerViewGetDataBlock = ^(NSMutableArray<XPBCooperationPartnerModel *> *partnerArr) {
        for(int i = 0;i<3; i++){
            UILabel *cooperationLab = labelarr[i];
            UIImageView *cooperationIcon = imgViewArr[i];
            XPBCooperationPartnerModel * partnerModel = partnerArr[i];
            cooperationLab.text = partnerModel.title;
            [cooperationIcon sd_setImageWithURL:[NSURL URLWithString:partnerModel.image_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
        }
    };
    
}

-(void)didClickShowMoreBtn:(UIButton *)sender{
    
    XPBCooperationListViewController *cooperationVC = [XPBCooperationListViewController new];
    cooperationVC.listType = CooperationType;
    cooperationVC.title = @"合作伙伴";
    [self.navigationController pushViewController:cooperationVC animated:YES];
}

-(void)didClickCooperationBtn:(UIButton *)sender
{
    BPBaseWebViewController *cooperationVC = [BPBaseWebViewController new];
    XPBCooperationPartnerModel *partnerModel = _partnerArr [sender.tag];
    cooperationVC.urlString = [NSString stringWithFormat:@"http://%@",partnerModel.link_url];
    cooperationVC.title = partnerModel.title;
    [self.navigationController pushViewController:cooperationVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBMainpageNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainpageNewsCell" forIndexPath:indexPath];
    cell.model = self.newsArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBNewsDataModel *newsDataModel = self.newsArr[indexPath.row];
    XPBNewsDetailViewController *newsDetailVC = [XPBNewsDetailViewController new];
    newsDetailVC.newsID = newsDataModel.news_id;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 100 ||collectionView .tag == 300){
        BPBannerModel *bannerModel = _bannerArr[indexPath.row];
        BPBaseWebViewController *webVC = [BPBaseWebViewController new];
        webVC.urlString = bannerModel.banner_link_url;
        webVC.title = bannerModel.banner_title;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else if(collectionView.tag == 400){
        if(indexPath.item == 0){
            XPBFreeInforListViewController *freeInforVC =[XPBFreeInforListViewController new];
            [self.navigationController pushViewController:freeInforVC animated:YES];
        }else if (indexPath.item == 1){
            XPBStatisticsViewController *statisticsVC = [XPBStatisticsViewController new];
            [self.navigationController pushViewController:statisticsVC animated:YES];
        }else if (indexPath.item == 2){
            [MBProgressHUD showSuccess:@"敬请期待"];
        }
        
    }else{
      if(indexPath.item == 0){
          [self.tabBarController setSelectedIndex:1];
      }else if (indexPath.item == 1){
          XPBNewsViewController *newsVC = [XPBNewsViewController new];
          [self.navigationController pushViewController:newsVC animated:YES];
      }else if (indexPath.item == 2){
          XPBVoteViewController *voteVC = [XPBVoteViewController new];
          [self.navigationController pushViewController:voteVC animated:YES];
      }else if (indexPath.item == 3){
          XPBBBSViewController *bbsVC = [XPBBBSViewController new];
          [self.navigationController pushViewController:bbsVC animated:YES];
      }else if (indexPath.item == 4){
          BPBaseWebViewController *playLotteryVC = [BPBaseWebViewController new];
          playLotteryVC.urlString = self.lotteryUrl ? self.lotteryUrl : @"";
          playLotteryVC.title = @"竞彩";
          [self.navigationController pushViewController:playLotteryVC animated:YES];
      }else if (indexPath.item == 5){
          XPBActionViewController *actionVC = [XPBActionViewController new];
          actionVC.title = @"活动";
          [self.navigationController pushViewController:actionVC animated:YES];
      }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(collectionView.tag == 100){
        return CGSizeMake(SCREENWIDTH,180);
    }else if(collectionView.tag == 200 || collectionView.tag == 400){
        return CGSizeMake((SCREENWIDTH -2*2)/3, 85);
    }else{
        return CGSizeMake(SCREENWIDTH,100);
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 100 ){
        return self.bannerArr.count;
    }else if(collectionView.tag == 300){
        return self.advArr.count;
    }else if(collectionView.tag == 400){
        return 3;
    }else{
        return  6;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 100){
    
        BPBannerModel *bannerModel = _bannerArr[indexPath.row];
        BPBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerViewCell" forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.banner_image_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
        return cell;
        
    }else if (collectionView.tag == 300){
        BPBannerModel *bannerModel = _advArr[indexPath.row];
        BPBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"advertimentsViewCell" forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.banner_image_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
        return cell;
    }else if(collectionView.tag == 400){
        XPBMainPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inforViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.iconView.image = [UIImage imageNamed:_inforTitleArr[indexPath.row]] ;
        cell.title.text = _inforTitleArr[indexPath.row];
        return cell;
        
    }else{
        XPBMainPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainPageCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.iconView.image = [UIImage imageNamed:_titleArr[indexPath.row]] ;
        cell.title.text = _titleArr[indexPath.row];
        return cell;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView.tag == 100 || scrollView.tag == 300){
        //停止定时器
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.tag == 100 || scrollView.tag == 300){
        [self setupTimer];
    }
}

-(void)setupTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage{
    if (_page >= self.bannerArr.count - 1) {
        _page = 0;
    }else{
        _page++;
    }
    CGFloat offsetX = _page * SCREENWIDTH;
    [self.bannerView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    if (_advPage >= self.advArr.count - 1) {
        _advPage = 0;
    }else{
        _advPage++;
    }
    CGFloat advOffsetX = _advPage * SCREENWIDTH;
    [self.advertimentsView setContentOffset:CGPointMake(advOffsetX, 0) animated:YES];
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginSuccessed" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"logoutSuccessed" object:nil];
}

-(NSMutableArray <XPBCooperationPartnerModel *> *)partnerArr{
    if(_partnerArr == nil){
        _partnerArr = [NSMutableArray array];
    }
    return _partnerArr;
}

-(NSMutableArray <XPBNewsDataModel *> *)newsArr{
    if(_newsArr == nil){
        _newsArr = [NSMutableArray array];
    }
    return _newsArr;
}

-(NSMutableArray <BPBannerModel *>*)bannerArr{
    if(_bannerArr == nil){
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

-(NSMutableArray <BPBannerModel *>*)advArr{
    if(_advArr == nil){
        _advArr = [NSMutableArray array];
    }
    return _advArr;
}

@end
