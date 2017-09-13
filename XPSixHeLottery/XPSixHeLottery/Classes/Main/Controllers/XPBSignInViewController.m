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
    header.frame = CGRectMake(0, 0, SCREENWIDTH, (SCREENWIDTH/11 + 5)*3 + 140);
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *signInTitle = [UILabel new];
    [header addSubview:signInTitle];
    [signInTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    signInTitle.text = @"签到表";
    signInTitle.textColor = GlobalOrangeColor;
    signInTitle.font = [UIFont systemFontOfSize:20];
    
    UIView *titleView = [UIView new];
    [header addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.mas_equalTo(0);
        make.top.mas_equalTo(signInTitle.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(40);
    }];
    titleView.backgroundColor = GlobalOrangeColor;
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 10;
    
    UILabel *titleLabel = [UILabel new];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(5);
    }];
    titleLabel.font = [UIFont fontWithName:@"ArialMT"size:18];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *dateStr = [formatter stringFromDate:date];
    titleLabel.text = [NSString stringWithFormat:@"签到表 %@",dateStr];
    titleLabel.textColor = [UIColor blackColor];
    
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREENWIDTH- 4)/11, SCREENWIDTH/11 + 5);
    UICollectionView *dateCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70 , SCREENWIDTH, (SCREENWIDTH/11 + 5)*3) collectionViewLayout:layout];
    [header addSubview:dateCollectionView];
    dateCollectionView.backgroundColor = [UIColor whiteColor];
    [dateCollectionView setContentInset:UIEdgeInsetsMake(5, 2, 0,2)];
    _dateCollectionView = dateCollectionView;
    dateCollectionView.pagingEnabled = YES;
    dateCollectionView.delegate = self;
    dateCollectionView.dataSource = self;
    dateCollectionView.scrollEnabled = NO;
    [dateCollectionView registerClass:[XPBSignInCollectionViewCell class] forCellWithReuseIdentifier:@"signInDateCell"];
    
    UIView *lineView = [UIView new];
    [header addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(dateCollectionView.mas_bottom);
    }];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.6;
    
    UILabel *tipLabel = [UILabel new];
    [header addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(dateCollectionView.mas_bottom).mas_offset(5);
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
                [MBProgressHUD showSuccess:@"签到成功"];
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

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBSignInCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"signInDateCell" forIndexPath:indexPath];
    NSString *dateStr = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
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
    return _daysOfMonth;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH- 4)/11, SCREENWIDTH/11 + 5);
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
