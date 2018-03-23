//
//  XPBNewsViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/4.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBNewsViewController.h"
#import "XPBNewsTableViewCell.h"
#import "XPBBAndWPicViewController.h"
#import "XPBNewsListViewController.h"

@interface XPBNewsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArr;

@end

@implementation XPBNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"图库";
    [self setupTableView];
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
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[XPBNewsTableViewCell class] forCellReuseIdentifier:@"newsCell"];
    tableView.tableFooterView = [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        XPBBAndWPicViewController *bAndWPicVC = [XPBBAndWPicViewController new];
        bAndWPicVC.title = @"黑白图库";
        bAndWPicVC.picType = @"1";
        [self.navigationController pushViewController:bAndWPicVC animated:YES];
    }else if( indexPath.row == 1){
        XPBBAndWPicViewController *bAndWPicVC = [XPBBAndWPicViewController new];
        bAndWPicVC.title = @"彩色图库";
        bAndWPicVC.picType = @"2";
        [self.navigationController pushViewController:bAndWPicVC animated:YES];
//    }else if(indexPath.row == 2){
//        XPBBAndWPicViewController *bAndWPicVC = [XPBBAndWPicViewController new];
//        bAndWPicVC.title = @"幽默图库";
//        bAndWPicVC.picType = @"3";
//        [self.navigationController pushViewController:bAndWPicVC animated:YES];
    }else{
        XPBNewsListViewController *newsListVC = [XPBNewsListViewController new];
        [self.navigationController pushViewController:newsListVC animated:YES];
    }
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_titleArr[indexPath.row]] ;
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSArray *)titleArr
{
    if(_titleArr == nil)
    {
        _titleArr = @[@"黑白图库",@"彩色图库",@"新闻资讯"];//,@"幽默图库"
    }
    return _titleArr;
}

@end
