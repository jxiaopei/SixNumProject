//
//  XPBStatisticsViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/4.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBStatisticsViewController.h"
#import "XPBStatisticsCell.h"
#import "XPBStatisticModel.h"
#import "XPBSixHeStatViewController.h"
#import "XPBAttributeReferenceController.h"
#import "XPBMantissaViewController.h"
#import "XPBSpecialCodeViewController.h"
#import "XPBStatisticsBarChartViewController.h"
#import "XPBStatSingleBarChartViewController.h"

@interface XPBStatisticsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *statisticsCollectionView;
@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,strong)NSMutableArray <XPBStatisticModel *>*dataSource;

@end

@implementation XPBStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"六合宝典";
    self.view.backgroundColor = GlobalLightGreyColor;
    [self setupCollectionView];
    
}

-(void)getData
{
    NSString *url =nil; //[NSString stringWithFormat:@"http://query-api.8win.com/command/execute?command=200001&lotteryType=1&matchId=%@",self.dataModel.matchId];
    [[BPNetRequest getInstance]getDataWithUrl:url parameters:nil success:^(id responseObject) {
        if([responseObject[@"code"]  integerValue] == 0)
        {
           self.dataSource = [XPBStatisticModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:layout];
    [self.view addSubview:collectView];
    _statisticsCollectionView = collectView;
    collectView.backgroundColor = GlobalLightGreyColor;
    collectView.showsVerticalScrollIndicator = NO;
    collectView.delegate = self;
    collectView.dataSource = self;
    [collectView registerClass:[XPBStatisticsCell class] forCellWithReuseIdentifier:@"statisticsCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0)
    {
        XPBSixHeStatViewController *sixHeStatVC = [XPBSixHeStatViewController new];
        [self.navigationController pushViewController:sixHeStatVC animated:YES];
    }else if (indexPath.item == 1){
        XPBAttributeReferenceController *attributeReferenceVC = [XPBAttributeReferenceController new];
        [self.navigationController pushViewController:attributeReferenceVC animated:YES];
    }else if(indexPath.item == 2){
        XPBSpecialCodeViewController *specialCodeVC = [XPBSpecialCodeViewController new];
        specialCodeVC.title = @"特码历史";
        specialCodeVC.statisticsType = StatisSpeHisType;
        [self.navigationController pushViewController:specialCodeVC animated:YES];
    }else if (indexPath.item == 3){
        XPBSpecialCodeViewController *specialCodeVC = [XPBSpecialCodeViewController new];
        specialCodeVC.title = @"正码历史";
        specialCodeVC.statisticsType = StatisNorHisType;
        [self.navigationController pushViewController:specialCodeVC animated:YES];
    }else if(indexPath.item == 4){
        XPBMantissaViewController *mantissaVC = [XPBMantissaViewController new];
        mantissaVC.statFormType = StatisMantissaType;
        mantissaVC.title = @"尾数大小";
        [self.navigationController pushViewController:mantissaVC animated:YES];
    }else if(indexPath.item == 5){
        XPBStatisticsBarChartViewController *barChartVC = [XPBStatisticsBarChartViewController new];
        barChartVC.statisticsType = StatisSpeZodiacType;
        barChartVC.title = @"生肖特码";
        [self.navigationController pushViewController:barChartVC animated:YES];
    }else if(indexPath.item == 6){
        XPBStatisticsBarChartViewController *barChartVC = [XPBStatisticsBarChartViewController new];
        barChartVC.statisticsType = StatisNorZodiacType;
        barChartVC.title = @"生肖正码";
        [self.navigationController pushViewController:barChartVC animated:YES];
    }else if(indexPath.item == 7){
        XPBStatisticsBarChartViewController *barChartVC = [XPBStatisticsBarChartViewController new];
        barChartVC.statisticsType = StatisSpeColorType;
        barChartVC.title = @"波色特码";
        [self.navigationController pushViewController:barChartVC animated:YES];
    }else if(indexPath.item == 8){
        XPBStatisticsBarChartViewController *barChartVC = [XPBStatisticsBarChartViewController new];
        barChartVC.statisticsType = StatisNorColorType;
        barChartVC.title = @"波色正码";
        [self.navigationController pushViewController:barChartVC animated:YES];
    }else if(indexPath.item == 9){
        XPBStatSingleBarChartViewController *singleBarChartVC = [XPBStatSingleBarChartViewController new];
        singleBarChartVC.statSingleBarType = StatisDoubleOrSingleType;
        singleBarChartVC.title = @"特码两面";
        [self.navigationController pushViewController:singleBarChartVC animated:YES];
    }else if(indexPath.item == 10){
        XPBStatisticsBarChartViewController *barChartVC = [XPBStatisticsBarChartViewController new];
        barChartVC.statisticsType = StatisSpeMantissType;
        barChartVC.title = @"正码尾数";
        [self.navigationController pushViewController:barChartVC animated:YES];
    }else if(indexPath.item == 11){
        XPBStatisticsBarChartViewController *barChartVC = [XPBStatisticsBarChartViewController new];
        barChartVC.statisticsType = StatisNorMantissType;
        barChartVC.title = @"特码尾数";
        [self.navigationController pushViewController:barChartVC animated:YES];
    }else if(indexPath.item == 12){
        XPBStatSingleBarChartViewController *singleBarChartVC = [XPBStatSingleBarChartViewController new];
        singleBarChartVC.statSingleBarType = StatisNorSumType;
        singleBarChartVC.title = @"正码总分";
        [self.navigationController pushViewController:singleBarChartVC animated:YES];
    }else if(indexPath.item == 13){
        XPBStatSingleBarChartViewController *singleBarChartVC = [XPBStatSingleBarChartViewController new];
        singleBarChartVC.statSingleBarType = StatisSpeNumHisType;
        singleBarChartVC.title = @"特码记录";
        [self.navigationController pushViewController:singleBarChartVC animated:YES];
    }else{
        XPBMantissaViewController *mantissaVC = [XPBMantissaViewController new];
        mantissaVC.statFormType = StatisAnimalType;
        mantissaVC.title = @"家禽野兽";
        [self.navigationController pushViewController:mantissaVC animated:YES];
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBStatisticsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"statisticsCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.iconView.image = [UIImage imageNamed:self.titleArr[indexPath.row]];
    cell.titleLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH - 2)/3,(SCREENWIDTH - 2)/3);
}

-(NSMutableArray <XPBStatisticModel *>*)dataSource
{
    if(_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)titleArr
{
    if(_titleArr == nil){
      _titleArr = [NSMutableArray arrayWithObjects:@"六合统计",@"属性参考",@"特码历史",@"正码历史",@"尾数大小",@"生肖特码",@"生肖正码",@"波色特码",@"波色正码",@"特码两面",@"特码尾数",@"正码尾数",@"正码总分",@"特码记录",@"家禽野兽" ,nil];
    }
    return _titleArr;
}


@end
