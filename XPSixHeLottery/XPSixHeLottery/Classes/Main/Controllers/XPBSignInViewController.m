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

@interface XPBSignInViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UICollectionView *dateCollectionView;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation XPBSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到";
    [self setupTableView];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(StatisSpeHis));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":StatisSpeHis,
                           @"paramData":@{}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(StatisSpeHis) parameters:dict success:^(id responseObject) {
        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            
            
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
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
    titleLabel.text = @"签到表 xxxx年xx月";
    titleLabel.textColor = [UIColor blackColor];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH/11, SCREENWIDTH/11 + 5);
    UICollectionView *dateCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70 , SCREENWIDTH, (SCREENWIDTH/11 + 5)*3) collectionViewLayout:layout];
    [header addSubview:dateCollectionView];
    dateCollectionView.backgroundColor = [UIColor whiteColor];
    _dateCollectionView = dateCollectionView;
    dateCollectionView.pagingEnabled = YES;
    dateCollectionView.delegate = self;
    dateCollectionView.dataSource = self;
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
    
    return header;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBSignInCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"signInDateCell" forIndexPath:indexPath];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 31;
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
    return CGSizeMake(SCREENWIDTH/11, SCREENWIDTH/11 + 5);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBSignInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signInMissionCell" forIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


@end
