//
//  XPBBAndWPicViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBAndWPicViewController.h"
#import "XPBBAndWPicTableViewCell.h"
#import "XPBAttentionPicTableViewCell.h"
#import "XPBPicDetailViewController.h"
#import "XPBHumorPicDetailViewController.h"
#import "XPBBAndWPicModel.h"

@interface XPBBAndWPicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIView *underLineView;

@property(nonatomic,strong)UITableView *picTableView;
@property(nonatomic,strong)NSMutableArray <XPBBAndWPicModel *>*picDataArr;
@property(nonatomic,assign)NSInteger pageNum;

@property(nonatomic,strong)UITableView *attentionTableView;
@property(nonatomic,strong)NSMutableArray <XPBBAndWPicModel *>*attenPicDataArr;
@property(nonatomic,assign)NSInteger attenPageNum;

@end

@implementation XPBBAndWPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    _pageNum = 1;
    _attenPageNum = 1;
    [self setupTitleView];
    [self setupScrollView];
    [self setupTableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
//    [self getAttentionData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(ImagesList));
    NSDictionary *paramData = nil;
    if([BPUserModel shareModel].isLogin)
    {
        paramData = @{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                       @"pageSize":@10,
                       @"pic_type":_picType,
                       @"user_id" :[BPUserModel shareModel].uid};
    }else{
        paramData = @{ @"pageNum":[NSNumber numberWithInteger:_pageNum],
                       @"pageSize":@10,
                       @"pic_type":_picType};
    }
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":ImagesList,
                           @"paramData":paramData
                           };
    [[BPNetRequest getInstance] postDataWithUrl:BaseUrl(ImagesList) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_pageNum == 1)
            {
                [_picTableView.mj_header endRefreshing];
                [_picTableView.mj_footer endRefreshing];
                self.picDataArr = [XPBBAndWPicModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  [XPBBAndWPicModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                if(!mutableArr.count)
                {
                    [_picTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_picTableView.mj_footer endRefreshing];
                    [self.picDataArr addObjectsFromArray:mutableArr];
                }
            }
            
            [self.picTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)getAttentionData{
    
    NSLog(@"%@",BaseUrl(ImageAttenList));
    NSDictionary *paramData = nil;
    if([BPUserModel shareModel].isLogin)
    {
        paramData = @{ @"pageNum":[NSNumber numberWithInteger:_attenPageNum],
                       @"pageSize":@10,
                       @"pic_type":_picType,
                       @"user_id" :[BPUserModel shareModel].uid};
    }else{
        paramData = @{ @"pageNum":[NSNumber numberWithInteger:_attenPageNum],
                        @"pageSize":@10,
                        @"pic_type":_picType};
    }
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":ImageAttenList,
                           @"paramData":paramData
                           };
    [[BPNetRequest getInstance] postDataWithUrl:BaseUrl(ImageAttenList) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            if(_attenPageNum == 1)
            {
                [_attentionTableView.mj_header endRefreshing];
                [_attentionTableView.mj_footer endRefreshing];
                self.attenPicDataArr = [XPBBAndWPicModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =  [XPBBAndWPicModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                if(!mutableArr.count)
                {
                    [_attentionTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_attentionTableView.mj_footer endRefreshing];
                    [self.attenPicDataArr addObjectsFromArray:mutableArr];
                }
            }
            
            [self.attentionTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)setupTableView
{
    for(int i = 0;i < 2;i++)
    {
        UITableView *tableView = [UITableView new];
        [_scrollView addSubview:tableView];
        tableView.tag = i;
        if(i == 0){
            self.picTableView = tableView;
        }else if (i == 1){
            self.attentionTableView = tableView;
        }
        tableView.frame = CGRectMake(SCREENWIDTH *i, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 40);
        tableView.backgroundColor = [UIColor whiteColor]; 
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[XPBBAndWPicTableViewCell class] forCellReuseIdentifier:@"picNewsCell"];
        [tableView registerClass:[XPBAttentionPicTableViewCell class] forCellReuseIdentifier:@"attentionPicCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            if(tableView.tag == 0){
                _pageNum = 1;
                [self getData];
            }else{
                _attenPageNum = 1;
                [self getAttentionData];
            }
            
        }];
        tableView.mj_header = header;
        MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            
            if(tableView.tag == 0){
                _pageNum++;
                [self getData];
            }else{
                _attenPageNum ++;
                [self getAttentionData];
            }
        }];
        tableView.mj_footer = footer;
    }
}

-(void)setupScrollView
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT - 64 - 40);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    scrollView.tag = 1000;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(SCREENWIDTH *2, SCREENHEIGHT - 64 - 40);
}

-(void)setupTitleView
{
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    _titleView = titleView;
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    NSArray *titleArr = @[@"图库",@"收藏"];
    for(int i = 0 ; i < titleArr.count;i++)
    {
        UIButton *btn = [UIButton new];
        [titleView addSubview:btn];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * SCREENWIDTH/2, 0, SCREENWIDTH/2, 36);
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickTitleViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        if(i == 0)
        {
            [self didClickTitleViewBtn:btn];
            btn.selected = YES;
            self.selectedBtn = btn;
            UIView *underLineView = [UIView new];
            [titleView addSubview:underLineView];
            _underLineView = underLineView;
            underLineView.frame = CGRectMake(SCREENWIDTH/4 - 25, 35, 50, 3);
            underLineView.backgroundColor = GlobalOrangeColor;
        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == 1000)
    {
        CGFloat offsetX =scrollView.contentOffset.x;
        if(offsetX == SCREENWIDTH || offsetX == 0)
        {
            NSInteger tag =  offsetX/SCREENWIDTH;
            for(int i = 0;i < _titleView.subviews.count ; i++)
            {
                if([_titleView.subviews[i] isKindOfClass:[UIButton class]])
                {
                    if(tag == _titleView.subviews[i].tag )
                    {
                        UIButton *btn = _titleView.subviews[i];
                        btn.selected = YES;
                        self.selectedBtn.selected = NO;
                        self.selectedBtn = btn;
                        if([btn.titleLabel.text isEqualToString:@"图库"])
                        {
                            [self getData];
                        }else if ([btn.titleLabel.text isEqualToString:@"收藏"]){
                            [self getAttentionData];
                        }
                        [self didClickTitleViewBtn:btn];
                    }
                }
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBBAndWPicModel *dataModel  = nil;
    if(tableView.tag == 0){
        dataModel = _picDataArr[indexPath.row];
    }else{
        dataModel = _attenPicDataArr[indexPath.row];
    }
    if([_picType isEqualToString:@"3"]){
        XPBHumorPicDetailViewController *humorPicDetailVC = [XPBHumorPicDetailViewController new];
        humorPicDetailVC.picID = dataModel.pic_id;
        humorPicDetailVC.title = dataModel.pic_name;
        humorPicDetailVC.picDataStr = dataModel.pic_list;
        humorPicDetailVC.picContent = dataModel.pic_content;
        [self.navigationController pushViewController:humorPicDetailVC animated:YES];
    }else{
        XPBPicDetailViewController *picDetailVC = [XPBPicDetailViewController new];
        picDetailVC.picID = dataModel.pic_id;
        picDetailVC.title = dataModel.pic_name;
        picDetailVC.picDataStr = dataModel.pic_list;
        [self.navigationController pushViewController:picDetailVC animated:YES];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 0){
        return self.picDataArr.count;
    }else{
        return self.attenPicDataArr.count;
    }
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0){
        XPBBAndWPicModel *dataModel = _picDataArr[indexPath.row];
        XPBBAndWPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"picNewsCell" forIndexPath:indexPath];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dataModel.pic_list] placeholderImage:[UIImage imageNamed:@"占位图"]];
        cell.titleLabel.text = dataModel.pic_name;
        NSString *periodStr = [dataModel.lottery_num substringFromIndex:4];
        NSString *dateStr = [dataModel.create_date insertStandardTimeFormat];
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%@ %@期",dateStr,periodStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        XPBBAndWPicModel *dataModel = _attenPicDataArr[indexPath.row];
        XPBAttentionPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attentionPicCell" forIndexPath:indexPath];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dataModel.pic_list] placeholderImage:[UIImage imageNamed:@"占位图"]];
        cell.titleLabel.text = dataModel.pic_name;
        NSString *periodStr = [dataModel.lottery_num substringFromIndex:4];
        NSString *dateStr = [dataModel.create_date insertStandardTimeFormat];
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%@ %@期",dateStr,periodStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)didClickTitleViewBtn:(UIButton *)sender
{
    [_scrollView setContentOffset:CGPointMake(sender.tag * SCREENWIDTH, 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        _underLineView.frame = CGRectMake(SCREENWIDTH/4 + SCREENWIDTH/2 * sender.tag  - 25, 35, 50, 3);
    }];
}

-(NSMutableArray <XPBBAndWPicModel *>*)picDataArr
{
    if(_picDataArr == nil)
    {
        _picDataArr = [NSMutableArray array];
    }
    return _picDataArr;
}

-(NSMutableArray <XPBBAndWPicModel *>*)attenPicDataArr
{
    if(_attenPicDataArr == nil)
    {
        _attenPicDataArr = [NSMutableArray array];
    }
    return _attenPicDataArr;
}

@end
