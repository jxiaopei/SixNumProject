//
//  XPBLotteryViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/15.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBLotteryViewController.h"
#import "XPBLotteryTableViewCell.h"
#import "XPBMarkSixLotteryListModel.h"
//#import "XPBMarkSixListModel.h"

@interface XPBLotteryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *lotteryTableView;
@property(nonatomic,strong)NSMutableArray *lotteriesArr;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)XPBMarkSixLotteryListModel *dataModel;
@property(nonatomic,copy) void(^lotteryGetDataBlock)(XPBMarkSixLotteryListModel *dataModel);
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger seconds;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *headerView;

@end

@implementation XPBLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开奖";
    _pageNum = 1;
    [self setupHeaderView];
    [self setupTableView];
    [self getData];

}

-(void)getData{
    NSLog(@"%@",BaseUrl(LotteryHistory));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":LotteryHistory,
                           @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                           @"pageSize":@5 }
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(LotteryHistory) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            self.dataModel = [XPBMarkSixLotteryListModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            self.lotteryGetDataBlock(self.dataModel);
            
            if(_pageNum == 1)
            {
                [_lotteryTableView.mj_header endRefreshing];
                [_lotteryTableView.mj_footer endRefreshing];
                self.lotteriesArr =  self.dataModel.lottery_list.rows;
                [self.lotteriesArr removeObjectAtIndex:0];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  self.dataModel.lottery_list.rows;
                if(!mutableArr.count)
                {
                    [_lotteryTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_lotteryTableView.mj_footer endRefreshing];
                    [self.lotteriesArr addObjectsFromArray:mutableArr];
                }
            }
            
            [self.lotteryTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(UIView *)setupHeaderView{
    
    UIView *lotteryView = [UIView new];
    lotteryView.backgroundColor = GlobalLightGreyColor;
    lotteryView.frame = CGRectMake(0, 0, SCREENWIDTH, 190);
    UIImageView *backgroundImage = [UIImageView new];
    [lotteryView addSubview:backgroundImage];
    
    UILabel *peroidLabel = [UILabel new];
    [lotteryView addSubview:peroidLabel];
    [peroidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lotteryView.mas_centerX);
        make.top.mas_equalTo(15);
    }];
    peroidLabel.font = [UIFont systemFontOfSize:18];
    peroidLabel.textColor = [UIColor blackColor];
    peroidLabel.text = @"第089期开奖结果";
    
    NSMutableArray *btnArr = [NSMutableArray new];
    NSMutableArray *labelArr = [NSMutableArray new];
    
    CGFloat btnW = 38;
    CGFloat margant = (SCREENWIDTH - btnW *7 -20 - 25)/7;
    for(int i= 0; i< 6;i++)
    {
        UIButton *btn = [UIButton new];
        [lotteryView addSubview:btn];
        
        btn.frame = CGRectMake(10 + (margant + btnW) * i, 45, btnW, btnW);
        [btn setBackgroundImage:[UIImage imageNamed:@"红波"] forState:UIControlStateNormal];
        [btn setTitle:@"13" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i;
        UILabel *zodiaLabel = [UILabel new];
        [lotteryView addSubview:zodiaLabel];
        zodiaLabel.frame = CGRectMake(10 + (margant + btnW) * i, 45 + btnW, btnW, 30);
        zodiaLabel.textColor = [UIColor blackColor];
        zodiaLabel.textAlignment = NSTextAlignmentCenter;
        zodiaLabel.font = [UIFont systemFontOfSize:18];
        zodiaLabel.text = @"猴";
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
    [spcNumBtn setTitle:@"45" forState:UIControlStateNormal];
    [spcNumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    [spcNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UILabel *spcZodiaLabel = [UILabel new];
    [lotteryView addSubview:spcZodiaLabel];
    spcZodiaLabel.frame = CGRectMake(10 + (margant + btnW) * 6 + margant +25, 45 + btnW, btnW, 30);
    spcZodiaLabel.textColor = [UIColor blackColor];
    spcZodiaLabel.font = [UIFont systemFontOfSize:18];
    spcZodiaLabel.textAlignment = NSTextAlignmentCenter;
    spcZodiaLabel.text = @"虎";
    
    [btnArr addObject:spcNumBtn];
    [labelArr addObject:spcZodiaLabel];
    
    UIView *nextView = [UIView new];
    [lotteryView addSubview:nextView];
    nextView.frame = CGRectMake(0, 55 + 30 + btnW, SCREENWIDTH, 60);
    nextView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nextPeroidLabel = [UILabel new];
    [nextView addSubview:nextPeroidLabel];
    [nextPeroidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(nextView.mas_centerX);
    }];
    nextPeroidLabel.font = [UIFont systemFontOfSize:16];
    nextPeroidLabel.text = @"下期开奖时间 0000年00月00日 00:00";
    
    UILabel *dateLabel = [UILabel new];
    [nextView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.centerX.mas_equalTo(nextView.mas_centerX);
    }];
    dateLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size: 26];
    dateLabel.text = @"XX:XX:XX";
    _timeLabel = dateLabel;
    
    __weak typeof(self)weakSelf = self;
    self.lotteryGetDataBlock = ^(XPBMarkSixLotteryListModel *dataModel) {
        
        if(_pageNum!=1){
            return ;
        }
        _seconds = [dataModel.remanin_time integerValue];
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",_seconds/3600];//时
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_seconds%3600)/60];//分
        NSString *str_second = [NSString stringWithFormat:@"%02ld",_seconds%60];//秒
        NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        NSLog(@"time:%@",format_time);
         dateLabel.text = format_time;
        if(![format_time isEqualToString:@"00:00:00"]){
            [weakSelf setupTimer];
        }
        
        NSString *publishStr = [dataModel.next_date insertStandardTimeFormatWithCN];
        nextPeroidLabel.text = [NSString stringWithFormat:@"下期开奖时间  %@",publishStr];
        
        
        XPBMarkSixLotteryDataModel *lotteryDataModel = dataModel.lottery_list.rows[0];
        NSString *periodStr = [lotteryDataModel.lottery_nper substringFromIndex:4];
        peroidLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",periodStr];
        for(int i =0; i < lotteryDataModel.lottery_result.count;i++)
        {
            XPBLotteryModel *dataModel = lotteryDataModel.lottery_result[i];
            UIButton *btn = btnArr[i];
            [btn setBackgroundImage:[UIImage imageNamed:dataModel.colour] forState:UIControlStateNormal];
            [btn setTitle:dataModel.number forState:UIControlStateNormal];
            UILabel *label = labelArr[i];
            label.text = dataModel.name;
        }
        
    };
    
    return lotteryView;
}

-(void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void) countDownAction{
    //倒计时-1
    _seconds--;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
    self.timeLabel.text= format_time;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_seconds==0 ){
        [_timer invalidate];
    }
}


-(void)setupTableView{
    
    UITableView *lotteroyTableView = [UITableView new];
    [self.view addSubview:lotteroyTableView];
    lotteroyTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64-49);
    lotteroyTableView.delegate = self;
    lotteroyTableView.dataSource = self;
    [lotteroyTableView registerClass:[XPBLotteryTableViewCell class] forCellReuseIdentifier:@"lotteryTableViewCell"];
    _lotteryTableView = lotteroyTableView;
    lotteroyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self.timer invalidate];
        self.timer = nil;
        [self getData];
    }];
    lotteroyTableView.mj_header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        _pageNum++;
       
        [self getData];
    }];
    lotteroyTableView.mj_footer = footer;
    lotteroyTableView.tableFooterView = [UIView new];
    lotteroyTableView.tableHeaderView = [self setupHeaderView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lotteriesArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBLotteryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lotteryTableViewCell" forIndexPath:indexPath];
    cell.dataModel = self.lotteriesArr[indexPath.row ];
    cell.backgroundColor = indexPath.row%2?GlobalLightGreyColor :[UIColor whiteColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
