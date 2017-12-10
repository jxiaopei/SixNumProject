//
//  XPBIntegralViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBIntegralViewController.h"
#import "XPBIntegralDataModel.h"
#import "XPBIntegralTableViewCell.h"

@interface XPBIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UILabel *integralLabel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <XPBIntegralDataModel *>*dataSource;
@property(nonatomic,assign)NSInteger pageNum;

@end

@implementation XPBIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的积分";
    [self customBackBtn];
    [self setupTableView];
    [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(IntegralDetail));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":IntegralDetail,
                           @"paramData":@{@"user_account" : [BPUserModel shareModel].userAccount}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(IntegralDetail) parameters:dict success:^(id responseObject) {
       
        [self.tableView.mj_header endRefreshing];
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            self.dataSource = [XPBIntegralDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"sige_history"]];
            NSArray *strArr = responseObject[@"data"][@"integral_balance"];
            if(strArr.count){
                NSString *tempString = [NSString stringWithFormat:@"可用积分:%@分",strArr[0][@"user_amount"]];
                NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:tempString];
                [colorString addAttribute:NSForegroundColorAttributeName value:GlobalOrangeColor range:NSMakeRange(5, tempString.length-6)];
                _integralLabel.attributedText = colorString;
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

-(UIView *)setupHeader{
    
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, 130);
    header.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [UIView new];
    [header addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(200);
    }];
    
    UIImageView *imageView = [UIImageView new];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(60);
    }];
    imageView.image = [UIImage imageNamed:@"积分详情"];
    
    UILabel *integralLabel = [UILabel new];
    [headerView addSubview:integralLabel];
    _integralLabel = integralLabel;
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_offset(5);
        make.top.mas_equalTo(5);
    }];
    integralLabel.font = [UIFont systemFontOfSize:17];
    NSInteger colorStrCount = 1;
    NSString *tempString = [NSString stringWithFormat:@"我的总积分:0分"];
    NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:tempString];
    [colorString addAttribute:NSForegroundColorAttributeName value:GlobalOrangeColor range:NSMakeRange(5, colorStrCount)];
    integralLabel.attributedText = colorString;
    
    UILabel *tipLabel = [UILabel new];
    [headerView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_offset(5);
        make.bottom.mas_equalTo(-5);
    }];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.text = @"完成任务,赚取更多积分";
    
    UIView *horView = [UIView new];
    [header addSubview:horView];
    [horView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    horView.backgroundColor = GlobalLightGreyColor;
    
    return header;
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
    tableView.showsVerticalScrollIndicator = NO;
//    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[XPBIntegralTableViewCell class] forCellReuseIdentifier:@"integralCell"];
    tableView.tableFooterView = [UIView new];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    tableView.mj_header = header;
    
    tableView.tableHeaderView = [self setupHeader];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPBIntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"integralCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataModel = self.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSMutableArray <XPBIntegralDataModel *>*)dataSource{
    
    if(_dataSource == nil){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
