//
//  XPBSpecialCodeViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBSpecialCodeViewController.h"
#import "XPBSixHeStatDataModel.h"

@interface XPBSpecialCodeViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSMutableArray *coldTitleArr;
@property(nonatomic,strong)NSMutableArray *coldDataSource;
@property(nonatomic,strong)PNBarChart *coldBarChart;

@property(nonatomic,strong)NSMutableArray *hotTitleArr;
@property(nonatomic,strong)NSMutableArray *hotDataSource;
@property(nonatomic,strong)PNBarChart *hotBarChart;

@property(nonatomic,strong)NSArray *tipArr;
@property(nonatomic,strong)NSArray *urlArr;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIView *markView;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,strong)NSArray *periodsArr;
@property(nonatomic,strong)UIButton *rightBtn;


@end

@implementation XPBSpecialCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    _tipArr = @[@[@"特码历史热图(出现的次数)",@"特码历史冷图(遗漏的次数)"],@[@"正码历史热图(出现的次数)",@"正码历史冷图(遗漏的次数)"]];
    _urlArr = @[StatisSpeHis,StatisNorHis];
    
    UIScrollView *mainScrollVIew = [UIScrollView new];
    [self.view addSubview:mainScrollVIew];
    mainScrollVIew.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
//    [mainScrollVIew setContentSize:CGSizeMake(SCREENWIDTH, 1020)];
    _mainScrollView = mainScrollVIew;
    
    _periodsArr = @[@"50",@"100",@"200",@"500",@"1000"];
    [self setupRightBtn];
    [self setupHotBarChart];
    [self setupColdBarChart];
    [self getDataWithPeriods:@"100"];
}

-(void)setupRightBtn{
    UIButton *resignBtn = [UIButton new];
    _rightBtn = resignBtn;
    resignBtn.frame = CGRectMake(0, 0, 60, 25);
    [resignBtn setTitle:@"100" forState:UIControlStateNormal];
    [resignBtn setTitleColor:GlobalOrangeColor forState:UIControlStateNormal];
    resignBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    resignBtn.layer.masksToBounds = YES;
    resignBtn.layer.cornerRadius = 5;
    resignBtn.layer.borderWidth = 0.5;
    resignBtn.backgroundColor = [UIColor whiteColor];
    [resignBtn addTarget:self action:@selector(didClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:resignBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)didClickRightBtn:(UIButton *)sender
{
    UIView *markView = [UIView new];
    _markView = markView;
    markView.backgroundColor = GlobalMarkViewColor;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickCancelBtn:)];
    [markView addGestureRecognizer:tap];
    [self.view addSubview:markView];
    markView.frame = self.view.bounds;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT -240 , SCREENWIDTH, 240)];
    titleView.backgroundColor = [UIColor whiteColor];
    [markView addSubview:titleView];
    
    UIPickerView *datePick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    datePick.backgroundColor = [UIColor whiteColor];
    datePick.delegate = self;
    datePick.dataSource = self;
    [titleView addSubview:datePick];
    
    UIButton *cancelBtn = [UIButton new];
    [titleView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    [cancelBtn setTitle:@"取消" forState: UIControlStateNormal];
    [cancelBtn setTitleColor:GlobalOrangeColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *comfirmBtn = [UIButton new];
    [titleView addSubview:comfirmBtn];
    [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);;
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    [comfirmBtn setTitle:@"确定" forState: UIControlStateNormal];
    [comfirmBtn setTitleColor:GlobalOrangeColor forState:UIControlStateNormal];
    [comfirmBtn addTarget:self action:@selector(didClickComfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didClickCancelBtn:(UIButton *)sender{
    [_markView removeFromSuperview];
}

-(void)didClickComfirmBtn:(UIButton *)sender{
    NSLog(@"%zd",_selectedIndex);
    [_rightBtn setTitle:_periodsArr[_selectedIndex] forState:UIControlStateNormal];
    [self getDataWithPeriods:_periodsArr[_selectedIndex]];
    [_markView removeFromSuperview];
}

-(void)getDataWithPeriods:(NSString *)period{

    NSLog(@"%@",BaseUrl(_urlArr[_statisticsType]));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":_urlArr[_statisticsType],
                           @"paramData":@{@"periods":[NSNumber numberWithInteger:period.integerValue]}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(_urlArr[_statisticsType]) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [self.hotTitleArr removeAllObjects];
            [self.hotDataSource removeAllObjects];
            
            NSArray <XPBSixHeStatDataModel *>*hotArr = [XPBSixHeStatDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"hot_list"]];
            if(hotArr.count > 0){
                for(XPBSixHeStatDataModel *dataModel in hotArr){
                    
                    [self.hotTitleArr addObject:dataModel.number];
                    
                    [self.hotDataSource addObject:[NSString stringWithFormat:@"%zd",dataModel.count]];
                }
                if(_hotBarChart){
                    UIView *superView = _hotBarChart.superview;
                    [_hotBarChart removeFromSuperview];
                    [superView addSubview:self.hotBarChart];
                    [_hotBarChart setXLabels:self.hotTitleArr];
                    [_hotBarChart setYValues:self.hotDataSource];
                    [_hotBarChart strokeChart];
                    
                }
                
            }
            [self.coldTitleArr removeAllObjects];
            [self.coldDataSource removeAllObjects];
            NSArray <XPBSixHeStatDataModel *>*coldArr = [XPBSixHeStatDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"cold_list"]];
            if(coldArr.count > 0){
                for(XPBSixHeStatDataModel *dataModel in coldArr){
                    
                    [self.coldTitleArr addObject:dataModel.number];
                    
                    [self.coldDataSource addObject:[NSString stringWithFormat:@"%zd",dataModel.count]];
                }
                
                if(_coldBarChart){
                    UIView *superView = _coldBarChart.superview;
                    [_coldBarChart removeFromSuperview];
                    [superView addSubview:self.coldBarChart];
                    [_coldBarChart setXLabels:self.coldTitleArr];
                    [_coldBarChart setYValues:self.coldDataSource];
                    [_coldBarChart strokeChart];
                }
            }
            
        }else{
            
        }
    } fail:^(NSError *error) {
       
    }];
    
}

-(void)setupHotBarChart{
    
    UILabel *titleLabel = [UILabel new];
    [_mainScrollView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(10, 10, SCREENWIDTH - 20, 15);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text =  _tipArr[_statisticsType][0];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 30, SCREENWIDTH, (SCREENHEIGHT - 124)/2);
    scrollView.contentSize = CGSizeMake(40 + ((SCREENWIDTH - 40)/12 +5) * 49, (SCREENHEIGHT - 124)/2);
    [_mainScrollView addSubview:scrollView];

    [scrollView addSubview:self.hotBarChart];
}

-(void)setupColdBarChart{
    
    UILabel *titleLabel = [UILabel new];
    [_mainScrollView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(10, 40 + (SCREENHEIGHT - 124)/2, SCREENWIDTH - 20, 15);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text =  _tipArr[_statisticsType][1];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 60 + (SCREENHEIGHT - 124)/2, SCREENWIDTH, (SCREENHEIGHT - 124)/2);
    scrollView.contentSize = CGSizeMake(40 + ((SCREENWIDTH - 40)/12 +5) * 49, (SCREENHEIGHT - 124)/2);
    [_mainScrollView addSubview:scrollView];
    
    [scrollView addSubview:self.coldBarChart];

    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  _periodsArr[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _periodsArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectedIndex = row;
}


-(NSMutableArray *)coldTitleArr
{
    if(_coldTitleArr == nil)
    {
        _coldTitleArr = [NSMutableArray new];
    }
    return _coldTitleArr;
}

-(NSMutableArray *)coldDataSource
{
    if(_coldDataSource == nil)
    {
        _coldDataSource = [NSMutableArray new];
    }
    return _coldDataSource;
}

-(NSMutableArray *)hotTitleArr
{
    if(_hotTitleArr == nil)
    {
        _hotTitleArr = [NSMutableArray new];
    }
    return _hotTitleArr;
}

-(NSMutableArray *)hotDataSource
{
    if(_hotDataSource == nil)
    {
        _hotDataSource = [NSMutableArray new];
    }
    return _hotDataSource;
}

-(PNBarChart *)hotBarChart{
    if(_hotBarChart == nil)
    {
        PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 40 + ((SCREENWIDTH - 40)/12 +5) * 49, (SCREENHEIGHT - 124)/2)];
        _hotBarChart = barChart;
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
        
        barChart.strokeColor = GlobalOrangeColor;
        
        //是否立体效果
        
        barChart.isGradientShow = NO;
        
        //显示各条状图的数值
        
        barChart.isShowNumbers = YES;
        
        
        barChart.yLabelSum = 10;
        
        //    barChart.delegate = self;
        
        //Add
    }
    return  _hotBarChart;
}

-(PNBarChart *)coldBarChart{
    if(_coldBarChart == nil){
        PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 40 + ((SCREENWIDTH - 40)/12 +5) * 49, (SCREENHEIGHT - 124)/2)];
        _coldBarChart = barChart;
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
        
        barChart.strokeColor = GlobalOrangeColor;
        
        //是否立体效果
        
        barChart.isGradientShow = NO;
        
        //显示各条状图的数值
        
        barChart.isShowNumbers = YES;
        
        
        barChart.yLabelSum = 10;
        //    barChart.delegate = self;
        
        //Add
        
    }
    return _coldBarChart;
}



@end
