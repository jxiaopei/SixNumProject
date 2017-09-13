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
    self.title = @"我的积分";
    [self setupUI];
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
                NSString *tempString = [NSString stringWithFormat:@"可用积分:%@",strArr[0][@"user_amount"]];
                NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:tempString];
                [colorString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, tempString.length-5)];
                _integralLabel.attributedText = colorString;
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)setupUI{
    
    UIImageView *imageView = [UIImageView new];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.width.height.mas_equalTo(SCREENWIDTH/3);
    }];
    imageView.image = [UIImage imageNamed:@"积分详情"];
    
    UILabel *integralLabel = [UILabel new];
    [self.view addSubview:integralLabel];
    _integralLabel = integralLabel;
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(10);
    }];
    integralLabel.font = [UIFont systemFontOfSize:17];
    NSInteger colorStrCount = 1;
    NSString *tempString = [NSString stringWithFormat:@"可用积分:0"];
    NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:tempString];
    [colorString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, colorStrCount)];
    integralLabel.attributedText = colorString;
    
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(integralLabel.mas_bottom).mas_offset(23);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    titleView.backgroundColor = GlobalLightGreyColor;
    NSArray *titleArr = @[@"日期",@"积分变化",@"说明"];
    for(int i = 0 ; i < titleArr.count;i++)
    {
        UIButton *btn = [UIButton new];
        [titleView addSubview:btn];
        if(i == 0)
        {
            btn.frame =  CGRectMake(50, 6, 40, 20);
        }else if(i == 1){
            btn.frame = CGRectMake(SCREENWIDTH/2-45, 6, 120, 20);
        }else{
            btn.frame = CGRectMake(SCREENWIDTH -80, 6, 40, 20);
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREENWIDTH/3 + 104);
        make.left.right.bottom.mas_equalTo(0);
    }];
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[XPBIntegralTableViewCell class] forCellReuseIdentifier:@"integralCell"];
    tableView.tableFooterView = [UIView new];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    tableView.mj_header = header;
    
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
    return 30;
}

-(NSMutableArray <XPBIntegralDataModel *>*)dataSource{
    
    if(_dataSource == nil){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
