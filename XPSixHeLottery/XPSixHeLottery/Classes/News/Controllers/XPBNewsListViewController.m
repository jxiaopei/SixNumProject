//
//  XPBNewsListViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/18.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBNewsListViewController.h"
#import "XPBNewsListModel.h"
#import "XPBNewsListTableViewCell.h"
#import "XPBNewsDetailViewController.h"

@interface XPBNewsListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray <XPBNewsListModel *>*newsListArr;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)UITableView *newsTableView;

@end

@implementation XPBNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    self.title = @"新闻列表";
    [self setupNewsTableView];
    [self getData];
    
}

-(void)getData{
    NSLog(@"%@",BaseUrl(NewsListPage));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":NewsListPage,
                           @"paramData":@{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                           @"pageSize":@5 }
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(NewsListPage) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_newsTableView.mj_header endRefreshing];
                [_newsTableView.mj_footer endRefreshing];
                _newsListArr = [XPBNewsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"news_list"][@"rows"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr = [XPBNewsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"news_list"][@"rows"]];
                if(!mutableArr.count)
                {
                    [_newsTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_newsTableView.mj_footer endRefreshing];
                    [self.newsListArr addObjectsFromArray:mutableArr];
                }
            }
            [_newsTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)setupNewsTableView{
    UITableView *newsTableView = [UITableView new];
    [self.view addSubview:newsTableView];
    newsTableView.delegate =self;
    newsTableView.dataSource = self;
    newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    newsTableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLineEtched;
    _newsTableView = newsTableView;
    [newsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    [newsTableView registerClass:[XPBNewsListTableViewCell class] forCellReuseIdentifier:@"newsListCell"];
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getData];
    }];
    newsTableView.mj_header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self getData];
    }];
    newsTableView.mj_footer = footer;
    newsTableView.tableFooterView = [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBNewsListModel *dataModel = self.newsListArr[indexPath.row];
    XPBNewsDetailViewController *newsDetailVC = [XPBNewsDetailViewController new];
    newsDetailVC.newsID = dataModel.news_id;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsListArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBNewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsListCell" forIndexPath:indexPath];
    cell.dataModel = self.newsListArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

-(NSMutableArray <XPBNewsListModel *>*)newsListArr
{
    if(_newsListArr == nil)
    {
        _newsListArr = [NSMutableArray array];
    }
    return _newsListArr;
}

@end
