//
//  XPBLotteryHistroyViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/19.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBLotteryHistroyViewController.h"
#import "XPBLotteryTableViewCell.h"
#import "XPBMarkSixLotteryListModel.h"

@interface XPBLotteryHistroyViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UITableView *lotteryTableView;
@property(nonatomic,strong)NSMutableArray *lotteriesArr;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)XPBMarkSixLotteryListModel *dataModel;
@property(nonatomic,strong)UIView *markView;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,strong)NSMutableArray *yearArr;
@property(nonatomic,strong)UIButton *rightBtn;

@end

@implementation XPBLotteryHistroyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开奖历史";
    _selectedIndex = 0;
    _pageNum = 1;
    
    //打开页面获得当前年份 然后再往前推十年 生成右按钮的年份选择列表
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSInteger yearNum = dateStr.integerValue;
    _yearArr = [NSMutableArray array];
    for(int i = 0; i < 10;i++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%zd",yearNum - i];
        [_yearArr addObject:yearStr];
    }
    
    [self setupRightBtn];
    [self setupTableView];
    [self getDataWIthYear:nil];
    
}

-(void)setupRightBtn{
    UIButton *resignBtn = [UIButton new];
    _rightBtn = resignBtn;
    resignBtn.frame = CGRectMake(0, 0, 60, 25);
    [resignBtn setTitle:@"2017" forState:UIControlStateNormal];
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
    [_rightBtn setTitle:_yearArr[_selectedIndex] forState:UIControlStateNormal];
    _pageNum = 1;
    [self getDataWIthYear:_yearArr[_selectedIndex]];
    [_markView removeFromSuperview];
}



-(void)getDataWIthYear:(NSString *)year{
    NSLog(@"%@",BaseUrl(LotteryHistory));
    NSDictionary *dict =  nil;
    if(year.length)
    {
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":LotteryHistory,
                 @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                 @"pageSize":@5 ,
                                 @"year_type" : year }
                 };
    }else{
        dict = @{
                 @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                 @"uri":LotteryHistory,
                 @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                 @"pageSize":@5 }
                 };
    }
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(LotteryHistory) parameters:dict success:^(id responseObject) {
        //        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            self.dataModel = [XPBMarkSixLotteryListModel mj_objectWithKeyValues:responseObject[@"data"]];
            if(_pageNum == 1)
            {
                [_lotteryTableView.mj_header endRefreshing];
                [_lotteryTableView.mj_footer endRefreshing];
                self.lotteriesArr =  self.dataModel.lottery_list.rows;
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

-(void)setupTableView{
    
    UITableView *lotteroyTableView = [UITableView new];
    [self.view addSubview:lotteroyTableView];
    lotteroyTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64);
    lotteroyTableView.delegate = self;
    lotteroyTableView.dataSource = self;
    [lotteroyTableView registerClass:[XPBLotteryTableViewCell class] forCellReuseIdentifier:@"lotteryHistoryCell"];
    _lotteryTableView = lotteroyTableView;
    lotteroyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getDataWIthYear:_yearArr[_selectedIndex]];
    }];
    lotteroyTableView.mj_header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        _pageNum++;
        
        [self getDataWIthYear:_yearArr[_selectedIndex]];
    }];
    lotteroyTableView.mj_footer = footer;
    lotteroyTableView.tableFooterView = [UIView new];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lotteriesArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBLotteryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lotteryHistoryCell" forIndexPath:indexPath];
    cell.dataModel = self.lotteriesArr[indexPath.row ];
    cell.backgroundColor = indexPath.row%2?GlobalLightGreyColor :[UIColor whiteColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  _yearArr[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _yearArr.count;
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

@end
