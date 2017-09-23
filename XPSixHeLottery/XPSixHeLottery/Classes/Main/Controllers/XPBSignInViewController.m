//
//  XPBSignInViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/30.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBSignInViewController.h"
#import "XPBSignInTableViewCell.h"
#import "XPBSignInCollectionViewCell.h"
#import "XPBSignInMissionModel.h"
#import "XPBIntegralDataModel.h"
#import "XPBAddPhoneNumViewController.h"
#import "XPBNewsListViewController.h"
#import "XPBBBSPublishViewController.h"
#import "XPBBBSViewController.h"

@interface XPBSignInViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UICollectionView *dateCollectionView;
@property(nonatomic,strong)NSMutableArray <XPBSignInMissionModel *>*dataArr;
@property(nonatomic,strong)NSMutableArray <XPBIntegralDataModel *>*signInDataArr;
@property(nonatomic,assign)NSInteger daysOfMonth;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)NSString *currentDayStr;
@property(nonatomic,assign)NSInteger weekday;
@property(nonatomic,strong)UIImageView *signInSuccessView;

@end

@implementation XPBSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到";
    [self setupTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(SignInList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":SignInList,
                           @"paramData":@{@"user_account" : [BPUserModel shareModel].userAccount,
                                          @"operation_type" : @"1"}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(SignInList) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"]){
            [_signInDataArr removeAllObjects];
            _signInDataArr = [XPBIntegralDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            _tipLabel.text = [NSString stringWithFormat:@"您本月已连续签到%zd天",_signInDataArr.count];
            [_dateCollectionView reloadData];
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
    NSLog(@"%@",BaseUrl(SignInDetail));
    NSDictionary *signDict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":SignInDetail,
                           @"paramData":@{@"user_account" : [BPUserModel shareModel].userAccount,
                                          @"operation_type" : @"1"}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(SignInDetail) parameters:signDict success:^(id responseObject) {
   
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            self.dataArr = [XPBSignInMissionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XPBSignInTableViewCell class] forCellReuseIdentifier:@"signInMissionCell"];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = [self setupHeader];
    
}

-(UIView *)setupHeader{
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, (SCREENWIDTH/7 + 5)*3 + 140);
    header.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [UIView new];
    [header addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    titleLabel.font = [UIFont fontWithName:@"ArialMT"size:18];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *dateStr = [formatter stringFromDate:date];
    titleLabel.text = dateStr;
    titleLabel.textColor = [UIColor blackColor];
    
    NSString *firstDateStr = [NSString stringWithFormat:@"%@01日",dateStr];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *firstDate = [formatter dateFromString:firstDateStr];
    //获取当前星期几
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay fromDate:firstDate];//kCFCalendarUnitWeekOfYear  | NSCalendarUnitWeekday |
    
    // 本月初得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    _weekday = [comps weekday];
    
    [formatter setDateFormat:@"MM"];
    NSString *monthStr = [formatter stringFromDate:date];
    NSInteger month = monthStr.integerValue;
    
     [formatter setDateFormat:@"dd"];
    _currentDayStr = [formatter stringFromDate:date];
    
    
    dateStr = [dateStr  substringToIndex:3];
    NSInteger year = dateStr.integerValue;
    
    NSInteger daysOfMonth = 0;
    
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            daysOfMonth = 31;
            break;
        case 2:
            if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
                daysOfMonth = 29;
            }else{
                daysOfMonth = 28;
            }
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            daysOfMonth = 30;
            break;
    }
    _daysOfMonth = daysOfMonth;
    
    NSArray *weekDayStrArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    UIView *weekView = [UIView new];
    [header addSubview:weekView];
    [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(titleView.mas_bottom);
    }];
    weekView.backgroundColor = GlobalLightGreyColor;
    
    for(int i = 0;i < weekDayStrArr.count;i++){
        
        UILabel *weekdayLab = [UILabel new];
        [weekView addSubview:weekdayLab];
        weekdayLab.frame = CGRectMake(SCREENWIDTH/7 * i, 0, SCREENWIDTH/7, 30);
        weekdayLab.text = weekDayStrArr[i];
        weekdayLab.font = [UIFont systemFontOfSize:13];
        weekdayLab.textColor = [UIColor grayColor];
        weekdayLab.textAlignment = NSTextAlignmentCenter;
        
    }
    
    NSInteger rowNum = (_weekday+_daysOfMonth) % 7 ? (_daysOfMonth + _weekday)/7  + 1: (_daysOfMonth + _weekday)/7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREENWIDTH)/7, 60);
    UICollectionView *dateCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70 , SCREENWIDTH, 60 * rowNum -5) collectionViewLayout:layout];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [header addSubview:dateCollectionView];
    dateCollectionView.backgroundColor = [UIColor whiteColor];
    _dateCollectionView = dateCollectionView;
    dateCollectionView.pagingEnabled = YES;
    dateCollectionView.delegate = self;
    dateCollectionView.dataSource = self;
    dateCollectionView.scrollEnabled = NO;
    [dateCollectionView registerClass:[XPBSignInCollectionViewCell class] forCellWithReuseIdentifier:@"signInDateCell"];
    
    UIView *lineView = [UIView new];
    [header addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(dateCollectionView.mas_bottom);
    }];
    lineView.backgroundColor = GlobalLightGreyColor;
    
    UILabel *tipLabel = [UILabel new];
    [header addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(dateCollectionView.mas_bottom).mas_offset(15);
    }];
    tipLabel.text = @"您本月已连续签到xx天";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor blackColor];
    _tipLabel = tipLabel;
    
    UIButton *signInBtn = [UIButton new];
    [header addSubview:signInBtn];
    [signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    [signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInBtn setTitle:@"签 到" forState:UIControlStateNormal];
    signInBtn.backgroundColor = GlobalOrangeColor;
    signInBtn.layer.masksToBounds = YES;
    signInBtn.layer.cornerRadius = 10;
    [signInBtn addTarget:self action:@selector(didClickSignInBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *horView = [UIView new];
    [header addSubview:horView];
    [horView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    horView.backgroundColor = GlobalLightGreyColor;
    
    header.frame = CGRectMake(0, 0, SCREENWIDTH, 60 * rowNum + 150 -5);
    
    return header;
}

-(void)didClickSignInBtn:(UIButton *)sender{
    NSLog(@"%@",BaseUrl(SignInAction));
    NSString *missionId = nil;
    for(XPBSignInMissionModel *model in  _dataArr)
    {
        if([model.mission_name isEqualToString:@"签到"]){
            missionId = model.Id;
        }
    }
    
    for(XPBIntegralDataModel *model in _signInDataArr)
    {
        NSString *signInStr = [model.create_time substringWithRange:NSMakeRange(8, 2)];
        if(_currentDayStr.integerValue == signInStr.integerValue)
        {
            [MBProgressHUD showError:@"您今天已经签到过了"];
            
            return;
        }
    }
    
    if([missionId isNotNil]){
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":SignInAction,
                               @"paramData":@{@"user_account" : [BPUserModel shareModel].userAccount,
                                              @"mission_id" : missionId,
                                              }
                               };
        [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(SignInAction) parameters:dict success:^(id responseObject) {
            
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
//              [MBProgressHUD showSuccess:@"签到成功"];
                [self showSuccessView];
                
                [self getData];

            }else{
                [MBProgressHUD showError:@"签到失败"];
            }
        } fail:^(NSError *error) {
            NSLog(@"%@",error.description);
            [MBProgressHUD showError:@"网络错误"];
        }];
    }
    
}

-(void)showSuccessView{
    UIImageView *signInSuccessView = [UIImageView new];
    signInSuccessView.image = [UIImage imageNamed:@"签到成功显示"];
    [self.view addSubview:signInSuccessView];
    signInSuccessView.frame = CGRectMake(-SCREENWIDTH/2, -SCREENHEIGHT/2, SCREENWIDTH * 2, SCREENHEIGHT * 2);
    signInSuccessView.alpha = 0;
    _signInSuccessView = signInSuccessView;
    signInSuccessView.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSignInSuccessViewByAnimation)];
    [signInSuccessView addGestureRecognizer:tap];
    signInSuccessView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        signInSuccessView.alpha = 1.0;
        signInSuccessView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    }];
}

-(void)removeSignInSuccessViewByAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        _signInSuccessView.alpha = 0.0;
        _signInSuccessView.frame = CGRectMake(-SCREENWIDTH/2, -SCREENHEIGHT/2, SCREENWIDTH * 2, SCREENHEIGHT * 2);;
    }completion:^(BOOL finished) {
        [_signInSuccessView removeFromSuperview];
    }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBSignInCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"signInDateCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *dateStr = nil;
    if(indexPath.row < _weekday - 1){
       dateStr = @"";
    }else{
       dateStr = [NSString stringWithFormat:@"%zd",indexPath.row - _weekday + 2];
    }
    [cell.btn setTitle:dateStr forState:UIControlStateNormal];
    cell.btn.selected = NO;
    for(XPBIntegralDataModel *model in _signInDataArr)
    {
        NSString *signInStr = [model.create_time substringWithRange:NSMakeRange(8, 2)];
        if(dateStr.integerValue == signInStr.integerValue)
        {
            cell.btn.selected = YES;
        }
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _daysOfMonth + _weekday;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/7, 60);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBSignInMissionModel *missionModel = _dataArr[indexPath.row];
    if([missionModel.Id isEqualToString:@"13"]){
        XPBAddPhoneNumViewController *addPhoneNumVC = [XPBAddPhoneNumViewController new];
        [self.navigationController pushViewController:addPhoneNumVC animated:YES];
    }else if ([missionModel.Id isEqualToString:@"15"]){
        XPBNewsListViewController *newListVC = [XPBNewsListViewController new];
        [self.navigationController pushViewController:newListVC animated:YES];
    }else if ([missionModel.Id isEqualToString:@"16"]){
        XPBBBSPublishViewController *bbsPublishVC = [XPBBBSPublishViewController new];
        [self.navigationController pushViewController:bbsPublishVC animated:YES];
    }else if ([missionModel.Id isEqualToString:@"17"]){
        XPBBBSViewController *bbsVC = [XPBBBSViewController new];
        [self.navigationController pushViewController:bbsVC animated:YES];
        }else if ([missionModel.Id isEqualToString:@"12"]){
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBSignInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signInMissionCell" forIndexPath:indexPath];
    cell.dataModel = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSMutableArray <XPBSignInMissionModel *>*)dataArr{
    if(_dataArr == nil)
    {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
