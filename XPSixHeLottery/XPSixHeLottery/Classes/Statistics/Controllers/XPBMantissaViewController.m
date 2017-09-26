//
//  XPBMantissaViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBMantissaViewController.h"
#import "XPBMantissaTableViewCell.h"
#import "XPBMantissaDataModel.h"


@interface XPBMantissaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)NSMutableArray <XPBMantissaDataModel *>*dataArr;

@end

@implementation XPBMantissaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;

    [self setupTitleView];
    [self setupTableView];
    [self getData];
}

-(void)getData{
    
    NSString *url =  _statFormType ?  StatisAnimal : StatisMantHis;
    NSLog(@"%@",BaseUrl(url));
    NSDictionary *paramData = nil;
    if(!_statFormType){
        paramData = @{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                      @"pageSize":@30};
    }else{
        paramData = @{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                      @"pageSize":@30,
                      @"prop_mode":@"生肖",
                      @"year_type":@"2017",};
    }
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":url,
                           @"paramData":paramData
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(url) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1){
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
               self.dataArr = [XPBMantissaDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lottery_list"][@"rows"]]; 
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  [XPBMantissaDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lottery_list"][@"rows"]]; ;
                if(!mutableArr.count)
                {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                    [self.dataArr addObjectsFromArray:mutableArr];
                }
            }
        
        [self.tableView reloadData];
        
            
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)setupTitleView
{
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    titleView.backgroundColor = GlobalRoseRedColor;
    NSArray *titleArr = @[@"年份/期数",@"一",@"二",@"三",@"四",@"五",@"六",@"特码"];
    for(int i = 0 ; i < titleArr.count;i++)
    {
        UIButton *btn = [UIButton new];
        [titleView addSubview:btn];
        CGFloat margant = (SCREENWIDTH - 60 - 20 - 30 * 7 - 5)/6;
        if(i == 0)
        {
            btn.frame =  CGRectMake(10, 2, 60, 20);
        }else{
            btn.frame = CGRectMake(75 + (i - 1) *(margant + 30), 2, 30, 20);
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.right.bottom.mas_equalTo(0);
    }];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate =self;
    [tableView registerClass:[XPBMantissaTableViewCell class] forCellReuseIdentifier:@"mantissaCell"];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getData];
    }];
    tableView.mj_header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        _pageNum++;
        
        [self getData];
    }];
    tableView.mj_footer = footer;
    tableView.tableFooterView = [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBMantissaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mantissaCell" forIndexPath:indexPath];
    cell.dataModel = _dataArr[indexPath.row];
    cell.backgroundColor = indexPath.row % 2 ? GlobalLightGreyColor : [UIColor whiteColor] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

@end
