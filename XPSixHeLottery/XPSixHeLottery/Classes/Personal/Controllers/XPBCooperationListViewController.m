//
//  XPBCooperationListViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBCooperationListViewController.h"
#import "LCPartnerTableViewCell.h"
#import "LCRecommendItem.h"
#import "XPBActionDataModel.h"
#import "XPBActionCollectionViewCell.h"

@interface XPBCooperationListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <LCRecommendItem *>*dataArr;

@end

@implementation XPBCooperationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self getData];
}

-(void)getData{
    
    NSString *url = nil;
    if(_listType){
        url = RecommendedList;
    }else{
        url = UserPartnerList;
    }
    NSLog(@"%@",BaseUrl(url));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":url,
                           @"paramData":@{}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(url) parameters:dict success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_listType){
                _dataArr = [LCRecommendItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"recommend_list"]];
            }else{
                _dataArr = [LCRecommendItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"partner_list"]];
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPartnerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCPartnerTableViewCell"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.section].image_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
    cell.titleLabel.text = self.dataArr[indexPath.section].title;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    BPBaseWebViewController *partnerVC = [BPBaseWebViewController new];
    partnerVC.title = self.dataArr[indexPath.section].title;
    partnerVC.urlString = [NSString stringWithFormat:@"https://%@",self.dataArr[indexPath.section].link_url];
    [self.navigationController pushViewController:partnerVC animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = GlobalLightGreyColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 5;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
         [_tableView registerClass:[LCPartnerTableViewCell class] forCellReuseIdentifier:@"LCPartnerTableViewCell"];
    }
    return _tableView;
}

@end
