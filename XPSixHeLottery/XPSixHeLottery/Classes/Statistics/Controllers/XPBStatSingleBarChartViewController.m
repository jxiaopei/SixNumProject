//
//  XPBStatSingleBarChartViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/31.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBStatSingleBarChartViewController.h"
#import "XPBSixHeStatDataModel.h"

@interface XPBStatSingleBarChartViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)PNBarChart *barChart;

@property(nonatomic,strong)NSArray *tipArr;
@property(nonatomic,strong)NSArray *urlArr;

@property(nonatomic,strong)UIView *markView;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,strong)NSArray *periodsArr;
@property(nonatomic,strong)UIButton *rightBtn;

@end

@implementation XPBStatSingleBarChartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tipArr = @[@"特码两面分析图",@"正码总分历史图",@"特码历史图"];
    _urlArr = @[StatisSpeSOD,StatisNorTotal,StatisNumber];
    
    _periodsArr = @[@"50",@"100",@"200",@"500",@"1000"];
    if(_statSingleBarType != StatisSpeNumHisType)
    {
        [self setupRightBtn];
    }
    [self setupBarChart];
    if(_statSingleBarType == StatisSpeNumHisType){
        [self getDataWithPeriods:@"50"];
    }else{
        [self getDataWithPeriods:@"100"];
    }
    
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
    
    NSLog(@"%@",BaseUrl(_urlArr[_statSingleBarType]));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":_urlArr[_statSingleBarType],
                           @"paramData":@{@"periods":[NSNumber numberWithInteger:period.integerValue]},
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(_urlArr[_statSingleBarType]) parameters:dict success:^(id responseObject) {
//        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [self.titleArr removeAllObjects];
            [self.dataSource removeAllObjects];
            NSArray <XPBSixHeStatDataModel *>*hotArr = nil;
            if(_statSingleBarType == StatisSpeNumHisType){
              hotArr  = [XPBSixHeStatDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"chart"]];
            }else{
              hotArr  = [XPBSixHeStatDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            }
           
            if(hotArr.count > 0){
                for(XPBSixHeStatDataModel *dataModel in hotArr){
                   if(_statSingleBarType == StatisSpeNumHisType){
                       [self.titleArr addObject:dataModel.periods];
                       
                       [self.dataSource addObject:dataModel.number];
                   }else{
                       [self.titleArr addObject:dataModel.prop_name];
                       
                       [self.dataSource addObject:[NSString stringWithFormat:@"%zd",dataModel.prop_count]];
                   }
                    
                }
                if(_barChart){
                    UIView *superView = _barChart.superview;
                    [_barChart removeFromSuperview];
                    [superView addSubview:self.barChart];
                    [_barChart setXLabels:self.titleArr];
                    [_barChart setYValues:self.dataSource];
                    [_barChart strokeChart];
                    
                }
                
            }
            
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)setupBarChart{
    
    UILabel *titleLabel = [UILabel new];
    [self.view addSubview:titleLabel];
    titleLabel.frame = CGRectMake(10, 10, SCREENWIDTH - 20, 15);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text =  _tipArr[_statSingleBarType];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 30, SCREENWIDTH, (SCREENHEIGHT - 124)/2);
    scrollView.contentSize = _statSingleBarType != StatisSpeNumHisType ?  CGSizeMake(SCREENWIDTH, (SCREENHEIGHT - 124)/2) : CGSizeMake(40 + ((SCREENWIDTH - 40)/12 +5) * 50, (SCREENHEIGHT - 124)/2);
    
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:self.barChart];
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

-(NSMutableArray *)titleArr
{
    if(_titleArr == nil)
    {
        _titleArr = [NSMutableArray new];
    }
    return _titleArr;
}

-(NSMutableArray *)dataSource
{
    if(_dataSource == nil)
    {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(PNBarChart *)barChart{
    if(_barChart == nil)
    {
        PNBarChart *barChart = _statSingleBarType != StatisSpeNumHisType ? [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, (SCREENHEIGHT - 124)/2)] : [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 40 + ((SCREENWIDTH - 40)/12 +5) * 50, (SCREENHEIGHT - 124)/2)];
        _barChart = barChart;
        barChart.backgroundColor = [UIColor whiteColor];
        
        //Y坐标label宽度(微调)
        
        barChart.yChartLabelWidth = 20.0;
        
        barChart.chartMarginLeft = 30.0;
        
        barChart.chartMarginRight = 10.0;
        
        barChart.chartMarginTop = 5.0;
        
        barChart.chartMarginBottom = 20.0;
        
        barChart.barWidth = (SCREENWIDTH - 40)/12 -5;
        
        //X坐标刻度的上边距
        
        barChart.labelMarginTop = -10;
        
        //是否显示坐标轴
        
        barChart.showChartBorder = YES;
        
        barChart.strokeColor = GlobalOrangeColor;
        
        //是否立体效果
        
        barChart.isGradientShow = NO;
        
        //显示各条状图的数值
        
        barChart.isShowNumbers = YES;
        
        barChart.rotateForXAxisText = _statSingleBarType == StatisSpeNumHisType;
        
        
        barChart.yLabelSum = 10;
        //    barChart.delegate = self;
        
        //Add
    }
    return  _barChart;
}


@end
