//
//  XPBFreeInforListViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBFreeInforListViewController.h"
#import "XPBFreeInforListDataModel.h"
#import "XPBFreeInforListTableViewCell.h"
#import "XPBFreeInforDetailViewController.h"

@interface XPBFreeInforListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)NSMutableArray <XPBFreeInforListDataModel *>*freeInforDataArr;

@end

@implementation XPBFreeInforListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费资料";
    [self customBackBtn];
    [self setupTableView];
    _pageNum = 1;
    
}

-(void)setupTableView
{
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XPBFreeInforListTableViewCell class] forCellReuseIdentifier:@"freeInforListCell"];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(FreeInforList));
    NSString *uid = @"";
    if([BPUserModel shareModel].isLogin)
    {
        uid = [BPUserModel shareModel].uid;
    }
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":FreeInforList,
                           @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                           @"pageSize":@5,
                                           @"user_id" :uid}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(FreeInforList) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                self.freeInforDataArr =  [XPBFreeInforListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"free_list"][@"rows"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  [XPBFreeInforListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"free_list"][@"rows"]];
                if(!mutableArr.count)
                {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                    [self.freeInforDataArr addObjectsFromArray:mutableArr];
                }
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XPBFreeInforListDataModel *dataModel = self.freeInforDataArr[indexPath.row];
    XPBFreeInforDetailViewController *freeInforDetailVC = [XPBFreeInforDetailViewController new];
    freeInforDetailVC.mianId =[NSString stringWithFormat:@"%zd", dataModel.Id];
    [self.navigationController pushViewController:freeInforDetailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.freeInforDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBFreeInforListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"freeInforListCell" forIndexPath:indexPath];
    XPBFreeInforListDataModel *dataModel = self.freeInforDataArr[indexPath.row];
    cell.dataModel = dataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBFreeInforListDataModel *dataModel = self.freeInforDataArr[indexPath.row];
    return dataModel.rowHeight;
}

-(NSMutableArray <XPBFreeInforListDataModel *>*)freeInforDataArr
{
    if(_freeInforDataArr == nil)
    {
        _freeInforDataArr = [NSMutableArray array];
    }
    return _freeInforDataArr;
}


@end
