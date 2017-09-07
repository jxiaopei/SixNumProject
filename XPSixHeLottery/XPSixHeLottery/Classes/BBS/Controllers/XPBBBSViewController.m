//
//  XPSBBSViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/4.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBBSViewController.h"
#import "XPBBBSListTableViewCell.h"
#import "XPBBBSListDataModel.h"
#import "XPBLoginViewController.h"
#import "XPBBBSPublishViewController.h"
#import "XPBBBSDetailsViewController.h"

@interface XPBBBSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)NSMutableArray <XPBBBSListDataModel *>*bbsDataArr;
@property(nonatomic,assign)NSInteger currentRankType;
@property(nonatomic,strong)UIButton *selectedBtn;

@end

@implementation XPBBBSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"论坛";
    [self setupTableView];
    [self setupTitleView];
    [self setupRightBtn];
    _pageNum = 1;
    _currentRankType = 1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataWithRankType:1];
}

-(void)setupRightBtn{
    UIButton *publishBtn = [UIButton new];
    publishBtn.frame = CGRectMake(0, 0, 25, 25);
    [publishBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(didClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)didClickRightBtn:(UIButton *)sender{
    
    if(![BPUserModel shareModel].isLogin)
    {
        XPBLoginViewController *loginVC = [XPBLoginViewController new];
        loginVC.popVC = self;
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        
        XPBBBSPublishViewController *publishVC = [XPBBBSPublishViewController new];
        [self.navigationController pushViewController:publishVC animated:YES];
    }
}

-(void)getDataWithRankType:(NSInteger)rankType{
    NSLog(@"%@",BaseUrl(BBSList));
    NSString *uid = @"";
    if([BPUserModel shareModel].isLogin)
    {
        uid = [BPUserModel shareModel].uid;
    }
    NSString *rankTypeStr = [NSString stringWithFormat:@"%zd",rankType];
    
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":BBSList,
                           @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                           @"pageSize":@5,
                                           @"rankType" : rankTypeStr,
                                           @"user_id" :uid}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(BBSList) parameters:dict success:^(id responseObject) {
//        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                self.bbsDataArr =  [XPBBBSListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"main_list"][@"rows"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  [XPBBBSListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"main_list"][@"rows"]];
                if(!mutableArr.count)
                {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                    [self.bbsDataArr addObjectsFromArray:mutableArr];
                }
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)setupTitleView{
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UIView *lineView = [UIView new];
    [titleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    lineView.backgroundColor = GlobalLightGreyColor;
    
    NSArray *titleArr = @[@"默认",@"排行",@"精华"];
    CGFloat margant = 20;
    for(int i = 0; i < 3;i++){
        UIButton *titleBtn = [UIButton new];
        [titleView addSubview:titleBtn];
        titleBtn.frame = CGRectMake(20 + (40 + margant)* i,5, 40, 35);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        titleBtn.tag = 1000 + i;
        [titleBtn addTarget:self action:@selector(didClickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            titleBtn.selected = YES;
            _selectedBtn = titleBtn;
        }
    }
    
}

-(void)didClickTitleBtn:(UIButton *)sender{
    
    sender.selected = YES;
    _selectedBtn.selected = NO;
    _selectedBtn = sender;
    _pageNum = 1;
    _currentRankType = sender.tag - 999;
    [self getDataWithRankType:_currentRankType];
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.frame = CGRectMake(0, 45, SCREENWIDTH, SCREENHEIGHT- 64 - 45);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XPBBBSListTableViewCell class] forCellReuseIdentifier:@"bbsListCell"];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getDataWithRankType:_currentRankType];
    }];
    tableView.mj_header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        _pageNum++;
        
        [self getDataWithRankType:_currentRankType];
    }];
    tableView.mj_footer = footer;
    tableView.tableFooterView = [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XPBBBSListDataModel *dataModel = self.bbsDataArr[indexPath.row];
    XPBBBSDetailsViewController *bbsDetailVC = [XPBBBSDetailsViewController new];
    bbsDetailVC.mianId =[NSString stringWithFormat:@"%zd", dataModel.Id];
    [self.navigationController pushViewController:bbsDetailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bbsDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBBBSListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bbsListCell" forIndexPath:indexPath];
    XPBBBSListDataModel *dataModel = self.bbsDataArr[indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBBBSListDataModel *dataModel = self.bbsDataArr[indexPath.row];
    return dataModel.rowHeight;
}

-(NSMutableArray <XPBBBSListDataModel *>*)bbsDataArr
{
    if(_bbsDataArr == nil)
    {
        _bbsDataArr = [NSMutableArray array];
    }
    return _bbsDataArr;
}


@end
