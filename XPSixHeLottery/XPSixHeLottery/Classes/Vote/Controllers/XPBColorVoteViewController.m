//
//  XPBColorVoteViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/21.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBColorVoteViewController.h"
#import "XPBColorVoteCell.h"
#import "XPBColorVoteModel.h"
#import "XPBLoginViewController.h"

@interface XPBColorVoteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *voteCollectionView;
@property(nonatomic,strong)NSArray<XPBColorVoteModel *>*colorVoteArr;//数据数组
@property(nonatomic,strong)NSMutableArray *voteCountArr;             //票数数组
@property(nonatomic,strong)NSMutableArray *voteColorArr;             //bar颜色数组
@property(nonatomic,strong)PNBarChart *barChart;
@property(nonatomic,copy)NSString *periodStr;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,copy)void(^didVoteGetData)(id responseObject);   //页面获得数据回调block
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation XPBColorVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"波色投票";
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
        paramData = @{@"prop_mode" : @"波色",
                      @"user_id"   : [BPUserModel shareModel].uid};
    }else{
        paramData = @{@"prop_mode" : @"波色"};
    }
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":VoteList,
                           @"paramData":paramData
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(VoteList) parameters:dict success:^(id responseObject) {
        [_scrollView.mj_header endRefreshing];
//        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            self.didVoteGetData(responseObject);
        }
    } fail:^(NSError *error) {
        [_scrollView.mj_header endRefreshing];
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
    
    barChart.barWidth = 70;
    
    //X坐标刻度的上边距
    
    barChart.labelMarginTop = 2.0;
    
    //是否显示坐标轴
    
    barChart.showChartBorder = YES;
    
    [barChart setXLabels:@[@"红",@"蓝",@"绿"]];
    
    [barChart setYValues:@[@0,@0,@0]];
    
    //每个柱子的颜色
    
//    [barChart setStrokeColors:@[GlobalRedBallColor,GlobalBlueBallColor,GlobalGreenBallColor]];
    
    //    barChart.strokeColor = [UIColor redColor];
    
    //是否立体效果
    
    barChart.isGradientShow = NO;
    
    //显示各条状图的数值
    
    barChart.isShowNumbers = YES;
    
    
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
    
    UIView *colorView = [UIView new];
    [self.scrollView addSubview:colorView];
    colorView.frame = CGRectMake(-10, 5, SCREENWIDTH/3 + 20, 30);
    colorView.layer.masksToBounds = YES;
    colorView.layer.cornerRadius = 5;
    
    UILabel *colorlabel = [UILabel new];
    [colorView addSubview:colorlabel];
    [colorlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(colorView.mas_centerY);
        make.right.mas_equalTo(-5);
    }];
    colorlabel.text = @"本期热门波色: 蓝";
    colorlabel.font = [UIFont systemFontOfSize:14];
    colorlabel.textColor = [UIColor whiteColor];
    
    UILabel *peroidLabel = [UILabel new];
    peroidLabel.backgroundColor = GlobalLightGreyColor;
    [self.scrollView addSubview:peroidLabel];
    [peroidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(colorView.mas_bottom).mas_offset(5);
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
    _voteCollectionView = voteCollectionView;
    voteCollectionView.pagingEnabled = YES;
    voteCollectionView.delegate = self;
    voteCollectionView.dataSource = self;
    [voteCollectionView registerClass:[XPBColorVoteCell class] forCellWithReuseIdentifier:@"voteColorCell"];
    
    __weak typeof(self) weakSelf = self;
    
    self.didVoteGetData = ^(id responseObject) {
        NSString *colorStr =  responseObject [@"data"][@"top_name"];
        if([colorStr isEqualToString:@"红波 "]){
            colorView.backgroundColor = GlobalRedBallColor;
            colorlabel.text = @"本期热门波色: 红";
        }else if ([colorStr isEqualToString:@"绿波 "]){
            colorView.backgroundColor = GlobalGreenBallColor;
            colorlabel.text = @"本期热门波色: 绿";
        }else if ([colorStr isEqualToString:@"蓝波 "]){
            colorView.backgroundColor = GlobalBlueBallColor;
            colorlabel.text = @"本期热门波色: 蓝";
        }else{
            colorView.backgroundColor = [UIColor blackColor];
            colorlabel.text = @"本期热门波色: 无";
        }
        
        weakSelf.periodStr =  responseObject [@"data"][@"periods_name"];
        peroidLabel.text = [NSString stringWithFormat:@"%@期",[weakSelf.periodStr substringFromIndex:4]];
        NSString *dateStr = responseObject [@"data"][@"open_date"];
        dateStr = [dateStr substringToIndex:8];
        dateLabel.text = [dateStr insertDateUnitWithCN];
        weakSelf.colorVoteArr =  [XPBColorVoteModel mj_objectArrayWithKeyValuesArray: responseObject [@"data"][@"voteList"]];
        [weakSelf.voteCollectionView reloadData];
        
        weakSelf.voteCountArr = [NSMutableArray array];
        weakSelf.voteColorArr = [NSMutableArray array];
        NSMutableArray *barColorArr = [NSMutableArray array];
        
        //之所以要遍历数据是因为获得数据排序不固定 所以需要根据数据来设定bar的颜色 和x轴label名称的数组
        for(int i = 0;i < weakSelf.colorVoteArr.count;i++)
        {
            XPBColorVoteModel *dataModel = weakSelf.colorVoteArr[i];
            [weakSelf.voteCountArr addObject:dataModel.prop_sum];
            [weakSelf.voteColorArr addObject:dataModel.prop_name];
            if([dataModel.prop_name isEqualToString:@"红波"]){
                [barColorArr addObject:GlobalRedBallColor];
            }else if ([dataModel.prop_name isEqualToString:@"绿波"]){
                [barColorArr addObject:GlobalGreenBallColor];
            }else if ([dataModel.prop_name isEqualToString:@"蓝波"]){
                [barColorArr addObject:GlobalBlueBallColor];
            }
        }
        [weakSelf.barChart setStrokeColors:barColorArr.copy];
        [weakSelf.barChart setXLabels:weakSelf.voteColorArr];
        [weakSelf.barChart updateChartData:weakSelf.voteCountArr.copy];
        [weakSelf.barChart strokeChart];

    };
}

-(void)voteActionWithIndex:(NSInteger)index success:(void(^)())success failure:(void(^)(NSString *errorStr))failure{
    XPBColorVoteModel *dateModel = _colorVoteArr[index];
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
//        NSLog(@"%@",[responseObject mj_JSONString]);
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
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBColorVoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"voteColorCell" forIndexPath:indexPath];
    XPBColorVoteModel *dateModel = _colorVoteArr[indexPath.row];
    NSString *colorStr = [dateModel.prop_name substringToIndex:1];
    [cell.colorBtn setTitle:colorStr forState:UIControlStateNormal];
    if([dateModel.prop_name isEqualToString:@"红波"]){
        cell.colorBtn.backgroundColor = GlobalRedBallColor;
    }else if ([dateModel.prop_name isEqualToString:@"绿波"]){
        cell.colorBtn.backgroundColor = GlobalGreenBallColor;
    }else if ([dateModel.prop_name isEqualToString:@"蓝波"]){
        cell.colorBtn.backgroundColor = GlobalBlueBallColor;
    }

    cell.countLabel.text = [NSString stringWithFormat:@"%@票",dateModel.prop_sum];
    cell.voteBtn.selected = dateModel.isAttention;
    cell.voteBtn.backgroundColor = dateModel.isAttention ? [UIColor redColor] : [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
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
    return 0;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(NSArray <XPBColorVoteModel *>*)colorVoteArr
{
    if(_colorVoteArr == nil)
    {
        _colorVoteArr = [NSArray array];
    }
    return _colorVoteArr;
}


@end
