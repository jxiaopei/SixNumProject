//
//  XPBActionViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBActionViewController.h"
#import "XPBActionDataModel.h"
#import "XPBActionCollectionViewCell.h"
#import "BPBaseWebViewController.h"

@interface XPBActionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *actionCollectionView;
@property(nonatomic,strong)NSMutableArray <XPBActionDataModel *>*dataSource;
@property(nonatomic,assign)NSInteger pageNum;

@end

@implementation XPBActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self setupCollectionView];
    [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(ActionsList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":ActionsList,
                           @"paramData":@{@"pageNum":[NSNumber numberWithInteger:_pageNum],
                                          @"pageSize":@6,}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(ActionsList) parameters:dict success:^(id responseObject) {
//        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"]){
            
            if(_pageNum == 1)
            {
                [_actionCollectionView.mj_header endRefreshing];
                [_actionCollectionView.mj_footer endRefreshing];
                _dataSource = [XPBActionDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  [XPBActionDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                if(!mutableArr.count)
                {
                    [_actionCollectionView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_actionCollectionView.mj_footer endRefreshing];
                    [self.dataSource addObjectsFromArray:mutableArr];
                }
            }
            [_actionCollectionView reloadData];
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)setupCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH/2 - 6, 270);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    UICollectionView *actionCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:layout];
    [self.view addSubview:actionCollectionView];
    _actionCollectionView = actionCollectionView;
    actionCollectionView.backgroundColor = GlobalLightGreyColor;
    [actionCollectionView setContentInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    actionCollectionView.delegate = self;
    actionCollectionView.dataSource = self;
    [actionCollectionView registerClass:[XPBActionCollectionViewCell class] forCellWithReuseIdentifier:@"actionCell"];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getData];
    }];
    actionCollectionView.mj_header = header;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        _pageNum++;
        
        [self getData];
    }];
    actionCollectionView.mj_footer = footer;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BPBaseWebViewController *actionDetailVC = [BPBaseWebViewController new];
    XPBActionDataModel *model = _dataSource[indexPath.row];
    actionDetailVC.title = model.act_name;
    actionDetailVC.urlString = model.act_link_url;
    [self.navigationController pushViewController:actionDetailVC animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XPBActionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"actionCell" forIndexPath:indexPath];
    cell.dataModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/2 - 6, 270);
}

-(NSMutableArray<XPBActionDataModel *>*)dataSource{
    if(_dataSource == nil){
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}



@end
