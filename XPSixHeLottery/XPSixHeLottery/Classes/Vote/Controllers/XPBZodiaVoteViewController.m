//
//  XPBZodiaViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBZodiaVoteViewController.h"
#import "XPBZodiaVoteCell.h"
#import "XPBColorVoteModel.h"
#import "XPBLoginViewController.h"

@interface XPBZodiaVoteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UICollectionView *voteCollectionView;
@property(nonatomic,strong)NSArray<XPBColorVoteModel *>*zodiaVoteArr;
@property(nonatomic,strong)NSMutableArray *voteCountArr;
@property(nonatomic,strong)NSMutableArray *voteZodiaArr;
@property(nonatomic,strong)PNBarChart *barChart;
@property(nonatomic,copy)NSString *periodStr;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,copy)void(^didVoteGetData)(id responseObject);

@end

@implementation XPBZodiaVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生肖投票";
    [self customBackBtn];
    _voteZodiaArr = [NSMutableArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪", nil];
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
        paramData = @{@"prop_mode" : @"生肖",
                      @"user_id"   : [BPUserModel shareModel].uid};
    }else{
        paramData = @{@"prop_mode" : @"生肖"};
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
    }];
    
}

-(void)setupBarChart{
    
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, (SCREENWIDTH/4 + 50)*3 + 70 +10, SCREENWIDTH, 250)];
    _barChart = barChart;
    barChart.backgroundColor = [UIColor whiteColor];
    
    //Y坐标label宽度(微调)
    
    barChart.yChartLabelWidth = 20.0;
    
    barChart.chartMarginLeft = 30.0;
    
    barChart.chartMarginRight = 10.0;
    
    barChart.chartMarginTop = 5.0;
    
    barChart.chartMarginBottom = 10.0;
    
    barChart.barWidth = (SCREENWIDTH - 40)/12 -5;
    
    //X坐标刻度的上边距
    
    barChart.labelMarginTop = 2.0;
    
    //是否显示坐标轴
    
    barChart.showChartBorder = YES;
    
    [barChart setXLabels:_voteZodiaArr];
    
//    [barChart setYValues:@[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0]];
    
    //每个柱子的颜色
    
    [barChart setStrokeColor:GlobalOrangeColor];
    
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
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, (SCREENWIDTH/4 + 50)*3 + 70 +10 + 250);
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    
    _scrollView.mj_header = header;
    
    UIView *zodiaView = [UIView new];
    [self.scrollView addSubview:zodiaView];
    zodiaView.frame = CGRectMake(-10, 15, SCREENWIDTH/3 + 60, 30);
    zodiaView.backgroundColor = GlobalOrangeColor;
    zodiaView.layer.masksToBounds = YES;
    zodiaView.layer.cornerRadius = 5;
    
    UILabel *zodialabel = [UILabel new];
    [zodiaView addSubview:zodialabel];
    [zodialabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(zodiaView.mas_centerY);
        make.right.mas_equalTo(-5);
    }];
    zodialabel.text = @"本期热门生肖: 鼠 牛 虎";
    zodialabel.font = [UIFont systemFontOfSize:14];
    zodialabel.textColor = [UIColor whiteColor];
    
    UILabel *peroidLabel = [UILabel new];
    peroidLabel.backgroundColor = GlobalLightGreyColor;
    [self.scrollView addSubview:peroidLabel];
    peroidLabel.frame = CGRectMake(SCREENWIDTH - 55, 17.5, 50, 25);
    peroidLabel.layer.masksToBounds = YES;
    peroidLabel.layer.cornerRadius = 12.5;
    peroidLabel.textColor = [UIColor blackColor];
    peroidLabel.font = [UIFont systemFontOfSize:14];
    peroidLabel.textAlignment = NSTextAlignmentCenter;
    peroidLabel.text = @"093期";
    
    UILabel *dateLabel = [UILabel new];
    [self.scrollView addSubview:dateLabel];
    dateLabel.frame = CGRectMake(SCREENWIDTH - 160, 17.5, 120, 25);
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.text = @"2017年08月10日";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH/4, SCREENWIDTH/4 + 50);
    UICollectionView *voteCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70 , SCREENWIDTH, (SCREENWIDTH/4 + 50)*3) collectionViewLayout:layout];
    [self.scrollView addSubview:voteCollectionView];
    voteCollectionView.backgroundColor = [UIColor whiteColor];
    _voteCollectionView = voteCollectionView;
    voteCollectionView.pagingEnabled = YES;
    voteCollectionView.delegate = self;
    voteCollectionView.dataSource = self;
    [voteCollectionView registerClass:[XPBZodiaVoteCell class] forCellWithReuseIdentifier:@"votezodiaCell"];
    
    __weak typeof(self) weakSelf = self;
    
    self.didVoteGetData = ^(id responseObject) {
        NSString *zodiaStr =  responseObject [@"data"][@"top_name"];
        zodialabel.text = [NSString stringWithFormat:@"本期热门生肖: %@",zodiaStr];
        
        weakSelf.periodStr =  responseObject [@"data"][@"periods_name"];
        peroidLabel.text = [NSString stringWithFormat:@"%@期",[weakSelf.periodStr substringFromIndex:4]];
        NSString *dateStr = responseObject [@"data"][@"open_date"];
        dateStr = [dateStr substringToIndex:8];
        dateLabel.text = [dateStr insertDateUnitWithCN];
        weakSelf.zodiaVoteArr =  [XPBColorVoteModel mj_objectArrayWithKeyValuesArray: responseObject [@"data"][@"voteList"]];
        [weakSelf.voteCollectionView reloadData];
        
        weakSelf.voteCountArr = [NSMutableArray array];
        [weakSelf.voteZodiaArr removeAllObjects];
        for(int i = 0;i < weakSelf.zodiaVoteArr.count;i++)
        {
            XPBColorVoteModel *dataModel = weakSelf.zodiaVoteArr[i];
            [weakSelf.voteCountArr addObject:dataModel.prop_sum];
            [weakSelf.voteZodiaArr addObject:dataModel.prop_name];
        }
        [weakSelf.barChart setXLabels:weakSelf.voteZodiaArr];
        [weakSelf.barChart updateChartData:weakSelf.voteCountArr.copy];
    };
    
}

-(void)voteActionWithIndex:(NSInteger)index success:(void(^)())success failure:(void(^)(NSString *errorStr))failure{
    XPBColorVoteModel *dateModel = _zodiaVoteArr[index];
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
    return _voteCountArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBZodiaVoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"votezodiaCell" forIndexPath:indexPath];
    XPBColorVoteModel *dateModel = _zodiaVoteArr[indexPath.row];
    NSString *zodiaStr = [dateModel.prop_name substringToIndex:1];
    [cell.colorBtn setTitle:zodiaStr forState:UIControlStateNormal];
    [cell.colorBtn setImage:[UIImage imageNamed:dateModel.prop_name] forState:UIControlStateNormal];
    NSString *contentStr = [NSString stringWithFormat:@"%@:%@票",dateModel.prop_name,dateModel.prop_sum];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:GlobalOrangeColor range:NSMakeRange(0, 2)];
    cell.countLabel.attributedText = str;
    cell.backgroundColor = [UIColor whiteColor];
    cell.voteBtn.selected = dateModel.isAttention;
    cell.voteBtn.backgroundColor = dateModel.isAttention ? GlobalOrangeColor : [UIColor whiteColor];
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
            weakCell.voteBtn.backgroundColor = GlobalOrangeColor;
            _count = [dateModel.prop_sum integerValue] + 1;
            NSString *contentStr = [NSString stringWithFormat:@"%@:%zd票",dateModel.prop_name,_count];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
            //设置：在0-3个单位长度内的内容显示成红色
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
          
            weakCell.countLabel.attributedText = str;
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
    return CGSizeMake(SCREENWIDTH/4,SCREENWIDTH/4 + 50);
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(NSArray <XPBColorVoteModel *>*)zodiaVoteArr
{
    if(_zodiaVoteArr == nil)
    {
        _zodiaVoteArr = [NSArray array];
    }
    return _zodiaVoteArr;
}

@end
