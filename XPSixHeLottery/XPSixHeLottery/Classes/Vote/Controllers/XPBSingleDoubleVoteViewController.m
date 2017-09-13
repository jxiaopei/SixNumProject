//
//  XPBSingleDoubleViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBSingleDoubleVoteViewController.h"
#import "XPBColorVoteCell.h"
#import "XPBColorVoteModel.h"
#import "XPBLoginViewController.h"

@interface XPBSingleDoubleVoteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *voteCollectionView;
@property(nonatomic,strong)NSMutableArray<XPBColorVoteModel *>*singleOrDoubleVoteArr;
@property(nonatomic,strong)NSMutableArray *voteCountArr;
@property(nonatomic,strong)PNBarChart *barChart;
@property(nonatomic,copy)NSString *periodStr;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,copy)void(^didVoteGetData)(id responseObject);
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation XPBSingleDoubleVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单双投票";
    [self setupUI];
    [self setupBarChart];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(VoteList));
    NSDictionary *paramData = nil;
    if([BPUserModel shareModel].isLogin)
    {
        paramData = @{@"prop_mode" : @"单双",
                      @"user_id"   : [BPUserModel shareModel].uid};
    }else{
        paramData = @{@"prop_mode" : @"单双"};
    }
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":VoteList,
                           @"paramData":paramData
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(VoteList) parameters:dict success:^(id responseObject) {
      
        [_scrollView.mj_header endRefreshing];
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            self.didVoteGetData(responseObject);
        }
    } fail:^(NSError *error) {
        [_scrollView.mj_header endRefreshing];
        NSLog(@"%@",error.description);
    }];

}

-(void)setupBarChart{
    
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, SCREENWIDTH/3 + 140, SCREENWIDTH, 250)];
    _barChart = barChart;
    barChart.backgroundColor = [UIColor whiteColor];
    
    //Y坐标label宽度(微调)
    
    barChart.yChartLabelWidth = 20.0;
    
    barChart.chartMarginLeft = 30.0;
    
    barChart.chartMarginRight = 10.0;
    
    barChart.chartMarginTop = 5.0;
    
    barChart.chartMarginBottom = 10.0;
    
    barChart.barWidth = (SCREENWIDTH - 120)/2;
    
    //X坐标刻度的上边距
    
    barChart.labelMarginTop = 2.0;
    
    //是否显示坐标轴
    
    barChart.showChartBorder = YES;
    
    [barChart setXLabels:@[@"单",@"双"]];
    
    [barChart setYValues:@[@0,@0]];
    
    //每个柱子的颜色
    
    [barChart setStrokeColors:@[GlobalSingleColor,GlobalDoubleColor]];
    
    //    barChart.strokeColor = [UIColor redColor];
    
    //是否立体效果
    
    barChart.isGradientShow = NO;
    
    //显示各条状图的数值
    
    barChart.isShowNumbers = YES;
    
    //开始绘图
    
    [barChart strokeChart];
    
    //    barChart.delegate = self;
    
    //Add
    
    [self.scrollView addSubview:barChart];
    
    
}

-(void)setupUI
{
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT -64);
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    
    _scrollView.mj_header = header;
    UIView *singleDoubleView = [UIView new];
    [self.scrollView addSubview:singleDoubleView];
    singleDoubleView.frame = CGRectMake(-10, 5, SCREENWIDTH/3 + 20, 30);
    singleDoubleView.backgroundColor = GlobalSingleColor;
    singleDoubleView.layer.masksToBounds = YES;
    singleDoubleView.layer.cornerRadius = 5;
    
    UILabel *singleOrDoublelabel = [UILabel new];
    [singleDoubleView addSubview:singleOrDoublelabel];
    [singleOrDoublelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(singleDoubleView.mas_centerY);
        make.right.mas_equalTo(-5);
    }];
    singleOrDoublelabel.text = @"本期热门单双: 单";
    singleOrDoublelabel.font = [UIFont systemFontOfSize:14];
    singleOrDoublelabel.textColor = [UIColor whiteColor];
    
    UILabel *peroidLabel = [UILabel new];
    peroidLabel.backgroundColor = GlobalLightGreyColor;
    [self.scrollView addSubview:peroidLabel];
    [peroidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singleDoubleView.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(SCREENWIDTH - 55);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    peroidLabel.layer.masksToBounds = YES;
    peroidLabel.layer.cornerRadius = 12.5;
    peroidLabel.textColor = [UIColor blackColor];
    peroidLabel.font = [UIFont systemFontOfSize:14];
    peroidLabel.textAlignment = NSTextAlignmentCenter;
    peroidLabel.text = @"093期";
    
    UILabel *dateLabel = [UILabel new];
    [self.scrollView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(peroidLabel.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(peroidLabel.mas_centerY);
    }];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.text = @"2017年08月10日";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH/3, SCREENWIDTH/3 + 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *voteCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70 , SCREENWIDTH, SCREENWIDTH/3 + 60) collectionViewLayout:layout];
    [self.scrollView addSubview:voteCollectionView];
    voteCollectionView.backgroundColor = [UIColor whiteColor];
    [voteCollectionView setContentInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    _voteCollectionView = voteCollectionView;
    voteCollectionView.delegate = self;
    voteCollectionView.dataSource = self;
    [voteCollectionView registerClass:[XPBColorVoteCell class] forCellWithReuseIdentifier:@"voteSingleOrDoubleCell"];
    
    __weak typeof(self) weakSelf = self;
    
    self.didVoteGetData = ^(id responseObject) {
        NSString *singleOrDoubleStr =  responseObject [@"data"][@"top_name"];
        singleOrDoublelabel.text = [NSString stringWithFormat:@"本期热门单双: %@",singleOrDoubleStr];
        singleDoubleView.backgroundColor = [singleOrDoubleStr isEqualToString:@"单"] ? GlobalSingleColor : GlobalDoubleColor;
        weakSelf.periodStr =  responseObject [@"data"][@"periods_name"];
        peroidLabel.text = [NSString stringWithFormat:@"%@期",[weakSelf.periodStr substringFromIndex:4]];
        NSString *dateStr = responseObject [@"data"][@"open_date"];
        dateStr = [dateStr substringToIndex:8];
        dateLabel.text = [dateStr insertDateUnitWithCN];
        NSMutableArray *arr = [NSMutableArray array];
        weakSelf.singleOrDoubleVoteArr = [XPBColorVoteModel mj_objectArrayWithKeyValuesArray: responseObject [@"data"][@"voteList"]];
        if([singleOrDoubleStr isEqualToString:@"双 "])
        {
            for(NSInteger i = weakSelf.singleOrDoubleVoteArr.count -1;i >= 0;i--)
            {
                XPBColorVoteModel *model = weakSelf.singleOrDoubleVoteArr[i];
                [arr addObject:model];
            }
            [weakSelf.singleOrDoubleVoteArr removeAllObjects];
            [weakSelf.singleOrDoubleVoteArr addObjectsFromArray: arr];
        }
        
        [weakSelf.voteCollectionView reloadData];
        
        weakSelf.voteCountArr = [NSMutableArray array];
        for(int i = 0;i < weakSelf.singleOrDoubleVoteArr.count;i++)
        {
            XPBColorVoteModel *dataModel = weakSelf.singleOrDoubleVoteArr[i];
            [weakSelf.voteCountArr addObject:dataModel.prop_sum];
        }
        
        [weakSelf.barChart updateChartData:weakSelf.voteCountArr.copy];
    };

}

-(void)voteActionWithIndex:(NSInteger)index success:(void(^)())success failure:(void(^)(NSString *errorStr))failure{
    XPBColorVoteModel *dateModel = _singleOrDoubleVoteArr[index];
    NSLog(@"%@",BaseUrl(VoteAction));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":VoteAction,
                           @"paramData":@{@"periods_name" : _periodStr,
                                          @"user_id"   : [BPUserModel shareModel].uid,
                                          @"id"        : dateModel.Id
                                          }
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(VoteAction) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            success();
        }else{
            failure(@"投票失败");
        }
    } fail:^(NSError *error) {
        failure(error.description);
    }];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBColorVoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"voteSingleOrDoubleCell" forIndexPath:indexPath];
    XPBColorVoteModel *dateModel = _singleOrDoubleVoteArr[indexPath.row];
    NSString *singleOrDoubleStr = [dateModel.prop_name substringToIndex:1];
    [cell.colorBtn setBackgroundImage:[UIImage imageNamed:singleOrDoubleStr] forState:UIControlStateNormal];
    
    cell.countLabel.text = [NSString stringWithFormat:@"%@票",dateModel.prop_sum];
    cell.backgroundColor = [UIColor whiteColor];
    cell.voteBtn.selected = dateModel.isAttention;
    cell.voteBtn.backgroundColor = dateModel.isAttention ? [UIColor redColor] : [UIColor whiteColor];
    
    __weak typeof(cell)weakCell = cell;
    cell.didClickVoteBtnBlock = ^{
        
        if(![BPUserModel shareModel].isLogin)
        {
            XPBLoginViewController *loginVC = [XPBLoginViewController new];
            loginVC.popVC = self;
            [self.navigationController pushViewController:loginVC animated:YES];
            return ;
        }
        
        [self voteActionWithIndex:indexPath.row success:^{
            
            weakCell.voteBtn.selected = !weakCell.voteBtn.selected;
            [MBProgressHUD showSuccess:@"投票成功"];
            weakCell.voteBtn.backgroundColor = [UIColor redColor];
            _count = [dateModel.prop_sum integerValue] + 1;
            weakCell.countLabel.text = [NSString stringWithFormat:@"%zd票",_count];
            _voteCountArr[indexPath.row] = [NSString stringWithFormat:@"%zd",_count];
            [_barChart updateChartData:_voteCountArr];
            [self getData];
        } failure:^(NSString *errorStr){
            [MBProgressHUD showSuccess:@"投票失败"];
            NSLog(@"%@",errorStr);
        }];
        
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/3, SCREENWIDTH/3 + 60);
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SCREENWIDTH/3 - 60;
}

-(NSMutableArray <XPBColorVoteModel *>*)singleOrDoubleVoteArr
{
    if(_singleOrDoubleVoteArr == nil)
    {
        _singleOrDoubleVoteArr = [NSMutableArray array];
    }
    return _singleOrDoubleVoteArr;
}


@end
