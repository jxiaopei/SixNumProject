//
//  XPBPersonalViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/4.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBPersonalViewController.h"
#import "XPBNewsTableViewCell.h"
#import "XPBMainPageCollectionViewCell.h"
#import "XPBPersonalEixtTableViewCell.h"
#import "LCAboutViewController.h"
#import "XPBCooperationListViewController.h"
#import "XPBIntegralViewController.h"
#import "XPBLoginViewController.h"

@interface XPBPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSMutableArray *headTitleArr;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,strong)UIButton *loginBtn;

@end

@implementation XPBPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GlobalLightGreyColor;
    self.title = @"我的";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLoginSuccessed) name:@"loginSuccessed" object:nil];
    [self setupTableView];
    
}

-(void)didLoginSuccessed{
    [_loginBtn setTitle:@"退出登录" forState:UIControlStateNormal ];
    _statusLabel.text = [BPUserModel shareModel].userName;
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[XPBNewsTableViewCell class] forCellReuseIdentifier:@"personalCell"];
    [tableView registerClass:[XPBPersonalEixtTableViewCell class] forCellReuseIdentifier:@"personalExitCell"];
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = [self setHeadView];
}

-(UIView *)setHeadView{
    
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, 250);
    header.backgroundColor = [UIColor grayColor];
    
    UIImageView *personalView = [UIImageView new];
    [header addSubview:personalView];
    [personalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    personalView.image = [UIImage imageNamed:@"个人中心背景"];
    
    UIImageView *iconView = [UIImageView new];
    [personalView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.centerY.mas_equalTo(0);
        make.height.width.mas_equalTo(60);
    }];
    iconView.image = [UIImage imageNamed:@"默认头像 (1)"];
    
    UILabel *statusLabel = [UILabel new];
    [personalView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView.mas_right).mas_offset(30);
        make.centerY.mas_equalTo(iconView.mas_centerY);
    }];
    statusLabel.font = [UIFont systemFontOfSize:18];
    statusLabel.textColor = [UIColor whiteColor];
    if([BPUserModel shareModel].isLoginOtherView)
    {
        statusLabel.text = [BPUserModel shareModel].userName;
    }else{
        statusLabel.text =  @"登录/注册";
    }
    _statusLabel = statusLabel;
    
    UIButton *loginBtn = [UIButton new];
    [header addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *titleView = [UIView new];
    [header addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    titleView.backgroundColor = GlobalLightGreyColor;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH/3, 80);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10 , SCREENWIDTH, 80) collectionViewLayout:layout];
    [titleView addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[XPBMainPageCollectionViewCell class] forCellWithReuseIdentifier:@"personalCollectionCViewell"];

    return header;
}

-(void)didClickLoginBtn:(UIButton *)sender
{
    if([BPUserModel shareModel].isLogin)
    {
        return;
    }
    XPBLoginViewController *loginVC = [XPBLoginViewController new];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0)
    {
        if(![BPUserModel shareModel].isLogin)
        {
            XPBLoginViewController *loginVC = [XPBLoginViewController new];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            XPBIntegralViewController *integralVC =[XPBIntegralViewController new];
            [self.navigationController pushViewController:integralVC animated:YES];
        }
        
    }else if (indexPath.item == 1){
        BPBaseWebViewController *recommendVC = [BPBaseWebViewController new];
        recommendVC.title = @"推荐";
        recommendVC.urlString = @"https://www.whhbet.com/";
        [self.navigationController pushViewController:recommendVC animated:YES];
        
    }else if (indexPath.item == 2){
        XPBCooperationListViewController *cooperationVC = [XPBCooperationListViewController new];
        [self.navigationController pushViewController:cooperationVC animated:YES];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    XPBMainPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"personalCollectionCViewell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.iconView.image = [UIImage imageNamed:_headTitleArr[indexPath.row]] ;
    cell.title.text = _headTitleArr[indexPath.row];
    return cell;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.headTitleArr.count;
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
   return CGSizeMake(SCREENWIDTH/3,80);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [MBProgressHUD showSuccess:@"敬请期待"];
    }else if( indexPath.row == 1){
       
       [self.tabBarController setSelectedIndex:2];
        
    }else if(indexPath.row == 2){
        LCAboutViewController *aboutVC = [LCAboutViewController new];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.titleArr.count)
    {
        XPBPersonalEixtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalExitCell" forIndexPath:indexPath];
        _loginBtn =  cell.loginBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([BPUserModel shareModel].isLoginOtherView)
        {
            [_loginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//            [BPUserModel shareModel].isLoginOtherView = NO;
        }
        cell.didClickExitBtnBlock = ^{
            if([BPUserModel shareModel].isLogin)
            {
                BPUserModel *userModel = [BPUserModel shareModel];
                userModel.userName = nil;
                userModel.userAccount = nil;
                userModel.phoneNumber = nil;
                userModel.currentToken = nil;
                userModel.uid = nil;
                userModel.isLogin = NO;
                userModel.isLoginOtherView = NO;
                YYCache *cache = [YYCache cacheWithName:CacheKey];
                [cache setObject:userModel forKey:UserID];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutSuccessed" object:nil];
                _statusLabel.text = @"登录/注册";
                [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            }else{
                XPBLoginViewController *loginVC = [XPBLoginViewController new];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        };
        return cell;
    }else{
        XPBNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:self.titleArr[indexPath.row]];
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.titleArr.count)
    {
        return 110;
    }
    return 45;
}
-(NSArray *)titleArr
{
    if(_titleArr == nil)
    {
        _titleArr = @[@"邀请好友",@"联系客服",@"关于我们"];
    }
    return _titleArr;
}

-(NSMutableArray *)headTitleArr
{
    if(_headTitleArr == nil)
    {
        _headTitleArr = [NSMutableArray arrayWithArray:@[@"积分",@"推荐",@"合作伙伴"]];
    }
    return _headTitleArr;
}

@end
