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
@property(nonatomic,assign)NSInteger counts;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *headerView;

@end

@implementation XPBLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开奖";
    _pageNum = 1;
    _counts = 0;
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
    lotteryView.backgroundColor = [UIColor whiteColor];
    lotteryView.frame = CGRectMake(0, 0, SCREENWIDTH, 215);
    UIImageView *backgroundImage = [UIImageView new];
    [lotteryView addSubview:backgroundImage];
    
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
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(verView.mas_centerY);
    }];
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.text = @"0000.00.00 00:00";
    dateLabel.textColor = [UIColor grayColor];
    
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
        [btn setTitle:@"0" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = i;
        UILabel *zodiaLabel = [UILabel new];
        [lotteryView addSubview:zodiaLabel];
        zodiaLabel.frame = CGRectMake(10 + (margant + btnW) * i, 50 + btnW, btnW, 30);
        zodiaLabel.textColor = [UIColor blackColor];
        zodiaLabel.textAlignment = NSTextAlignmentCenter;
        zodiaLabel.font = [UIFont systemFontOfSize:13];
        zodiaLabel.adjustsFontSizeToFitWidth = YES;
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
    [spcNumBtn setTitle:@"0" forState:UIControlStateNormal];
    [spcNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    spcNumBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UILabel *spcZodiaLabel = [UILabel new];
    [lotteryView addSubview:spcZodiaLabel];
    spcZodiaLabel.frame = CGRectMake(10 + (margant + btnW) * 6 + margant +25, 50 + btnW, btnW, 30);
    spcZodiaLabel.textColor = [UIColor blackColor];
    spcZodiaLabel.font = [UIFont systemFontOfSize:13];
    spcZodiaLabel.textAlignment = NSTextAlignmentCenter;
    spcZodiaLabel.adjustsFontSizeToFitWidth = YES;
    spcZodiaLabel.text = @"虎";
    
    [btnArr addObject:spcNumBtn];
    [labelArr addObject:spcZodiaLabel];
    
    UIView *nextView = [UIView new];
    [lotteryView addSubview:nextView];
    nextView.frame = CGRectMake(0, 60 + 30 + btnW, SCREENWIDTH, 60);
    nextView.backgroundColor = GlobalLightGreyColor;
    
    UILabel *nextPeroidLabel = [UILabel new];
    [nextView addSubview:nextPeroidLabel];
    [nextPeroidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(nextView.mas_centerX);
    }];
    nextPeroidLabel.font = [UIFont systemFontOfSize:16];
    nextPeroidLabel.text = @"下期开奖时间 0000年00月00日 00:00";
    
    UILabel *timeLabel = [UILabel new];
    [nextView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.centerX.mas_equalTo(nextView.mas_centerX);
    }];
    timeLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size: 26];
    timeLabel.text = @"XX:XX:XX";
    _timeLabel = timeLabel;
    
    UIView *redView = [UIView new];
    [lotteryView addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(15);
    }];
    redView.backgroundColor = [UIColor redColor];
    
    UILabel *tipLabel = [UILabel new];
    [lotteryView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(redView.mas_centerY);
        make.left.mas_equalTo(redView.mas_right).mas_offset(5);
    }];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.text = @"近期开奖结果";
    
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
        timeLabel.text = format_time;
        if(![format_time isEqualToString:@"00:00:00"]){
            [weakSelf setupTimer];
        }
        
        NSString *publishStr = [dataModel.next_date insertStandardTimeFormatWithCN];
        nextPeroidLabel.text = [NSString stringWithFormat:@"下期开奖时间  %@",publishStr];
        
        
        XPBMarkSixLotteryDataModel *lotteryDataModel = dataModel.lottery_list.rows[0];
        NSString *periodStr = [lotteryDataModel.lottery_nper substringFromIndex:4];
        peroidLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",periodStr];
        dateLabel.text = [lotteryDataModel.open_time insertStandardTimeFormatWithCN];
        for(int i =0; i < lotteryDataModel.lottery_result.count;i++)
        {
            XPBLotteryModel *dataModel = lotteryDataModel.lottery_result[i];
            UIButton *btn = btnArr[i];
            [btn setBackgroundImage:[UIImage imageNamed:dataModel.colour] forState:UIControlStateNormal];
            [btn setTitle:dataModel.number forState:UIControlStateNormal];
            UILabel *label = labelArr[i];
            label.text = [NSString stringWithFormat:@"%@/%@", dataModel.name,dataModel.fiveElement];
        }
        
    };
    
    return lotteryView;
}

-(void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void) countDownAction{
    //倒计时-1
    if(_seconds != 0){
       _seconds--;
    }
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
    self.timeLabel.text= format_time;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_seconds== 0 ){
//        [_timer invalidate];
        _counts++;
        if(_counts == 8){
            [self getData];
            _counts = 0;
        }
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
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
