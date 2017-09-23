//
//  XPBVoteViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/21.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBVoteViewController.h"
#import "XPBVoteTableViewCell.h"
#import "XPBColorVoteViewController.h"
#import "XPBZodiaVoteViewController.h"
#import "XPBSingleDoubleVoteViewController.h"

@interface XPBVoteViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArr;

@end

@implementation XPBVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"投票";
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
    tableView.bounces = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[XPBVoteTableViewCell class] forCellReuseIdentifier:@"voteCell"];
    tableView.tableFooterView = [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        XPBColorVoteViewController *colorVoteVC = [XPBColorVoteViewController new];
        [self.navigationController pushViewController:colorVoteVC animated:YES];
    }else if (indexPath.row == 1){
        XPBZodiaVoteViewController *zodiaVoteVC = [XPBZodiaVoteViewController new];
        [self.navigationController pushViewController:zodiaVoteVC animated:YES];
    }else if (indexPath.row == 2){
        XPBSingleDoubleVoteViewController *singleDoubleVoteVC = [XPBSingleDoubleVoteViewController new];
        [self.navigationController pushViewController:singleDoubleVoteVC animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voteCell" forIndexPath:indexPath];
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
        _titleArr = @[@"波色投票",@"生肖投票",@"单双投票"];
    }
    return _titleArr;
}

@end
