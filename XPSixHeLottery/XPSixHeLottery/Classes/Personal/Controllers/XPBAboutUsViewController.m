//
//  XPBAboutUsViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/10/8.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBAboutUsViewController.h"
#import "XPBAboutUsTableViewCell.h"
#import "LCAboutViewController.h"

@interface XPBAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation XPBAboutUsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GlobalLightGreyColor;
    _titleArr = @[@"评分支持",@"功能介绍",@"投诉"];
    [self setupTableView];
     self.title = @"关于我们";
    
    [self setupUI];
    
}

-(void)setupUI{
    
    UILabel *tipInfor2 = [UILabel new];
    [self.view addSubview:tipInfor2];
    [tipInfor2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
    }];
    tipInfor2.textColor = [UIColor grayColor];
    tipInfor2.font = [UIFont systemFontOfSize:12];
    tipInfor2.text = @"Copyright © 1396开奖版权所有 Reserved";
    tipInfor2.numberOfLines = 2;
    
    UILabel *tipInfor1 = [UILabel new];
    [self.view addSubview:tipInfor1];
    [tipInfor1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(tipInfor2.mas_top).mas_offset(-5);
    }];
    tipInfor1.textColor = [UIColor grayColor];
    tipInfor1.font = [UIFont systemFontOfSize:12];
    tipInfor1.text = @"政府博彩执照监察局所授权和监督";
    
    UILabel *tipInfor = [UILabel new];
    [self.view addSubview:tipInfor];
    [tipInfor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(tipInfor1.mas_top).mas_offset(-5);
    }];
    tipInfor.textColor = [UIColor grayColor];
    tipInfor.font = [UIFont systemFontOfSize:12];
    tipInfor.text = @"1396开奖所提供的娱乐产品和服务皆由澳门特别行政区";
    
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = 50;
    [tableView registerClass:[XPBAboutUsTableViewCell class] forCellReuseIdentifier:@"generalCell"];
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = [self setupHeader];
    
}

-(UIView *)setupHeader{
    
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, 150);
    
    UIImageView *iconView = [UIImageView new];
    [header addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(30);
    }];
    iconView.image = [UIImage imageNamed:@"AppLogo"];
    iconView.clipsToBounds = YES;
    iconView.layer.cornerRadius = 10;
    
    
    UILabel *versionLab = [UILabel new];
    [header addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(iconView.mas_bottom).mas_offset(15);
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    versionLab.text = [NSString stringWithFormat:@"1396开奖 版本:v%@",appCurVersion];//@"v1.0";
    versionLab.textColor = [UIColor grayColor];
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.font = [UIFont systemFontOfSize:13];
    
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        [MBProgressHUD showSuccess:@"上架后才可以评分"];
    }else if (indexPath.row == 1){
        LCAboutViewController *aboutInforVC = [LCAboutViewController new];
        [self.navigationController pushViewController:aboutInforVC animated:YES];
    }else if(indexPath.row == 2){
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPBAboutUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generalCell" forIndexPath:indexPath];
    cell.titleLabel.text = _titleArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


@end
