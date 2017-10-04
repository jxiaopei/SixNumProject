//
//  XPBAttributeReferenceController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/7.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBAttributeReferenceController.h"
#import "XPBAttributeReferenceColorCell.h"
#import "XPBAttributeReferenceZodiaCell.h"
#import "XPBReferenceBallModel.h"


@interface XPBAttributeReferenceController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *selectedBtn;

@property(nonatomic,strong)NSArray *elementsTitleArr;
@property(nonatomic,strong)NSArray *zodiaTitleArr;
@property(nonatomic,strong)NSArray *colorTitleArr;
@property(nonatomic,strong)NSArray *animalTitleArr;

@property(nonatomic,strong)UITableView *colorTableView;
@property(nonatomic,strong)UITableView *zodiaTableView;
@property(nonatomic,strong)UITableView *elementsTableView;
@property(nonatomic,strong)UITableView *animalTableView;

@property(nonatomic,strong)NSDictionary *zodiaDataDic;
@property(nonatomic,strong)NSDictionary *colorDataDic;
@property(nonatomic,strong)NSDictionary *elementDataDic;
@property(nonatomic,strong)NSDictionary *animalDataDic;

@end

@implementation XPBAttributeReferenceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"属性参考";
    [self setupTitleView];
    [self setupScrollView];
    [self setupTableView];
    [self getData];
    
}

-(void)getData{
    
    NSLog(@"%@",BaseUrl(StatisReference));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":StatisReference,
                           @"paramData":@{}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(StatisReference) parameters:dict success:^(id responseObject) {

        [self.colorTableView.mj_header endRefreshing];
        [self.zodiaTableView.mj_header endRefreshing];
        [self.animalTableView.mj_header endRefreshing];
        [self.elementsTableView.mj_header endRefreshing];
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            self.zodiaDataDic = responseObject[@"data"][@"property"][@"生肖"];
            self.colorDataDic = responseObject[@"data"][@"property"][@"波色"];
            self.elementDataDic = responseObject[@"data"][@"property"][@"五行"];
            self.animalDataDic = responseObject[@"data"][@"savage"];
            [self.colorTableView reloadData];
            [self.zodiaTableView reloadData];
            [self.elementsTableView reloadData];
            [self.animalTableView reloadData];
            
        }else{
            
        }
    } fail:^(NSError *error) {
        
        [self.colorTableView.mj_header endRefreshing];
        [self.zodiaTableView.mj_header endRefreshing];
        [self.animalTableView.mj_header endRefreshing];
        [self.elementsTableView.mj_header endRefreshing];
       
    }];
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
    scrollView.contentSize = CGSizeMake(SCREENWIDTH *4, SCREENHEIGHT - 64 - 40);
}

-(void)setupTableView
{
    for(int i = 0;i < 4;i++)
    {
        UITableView *tableView = [UITableView new];
        [_scrollView addSubview:tableView];
        tableView.tag = i;
        if(i == 0){
            self.colorTableView = tableView;
        }else if (i == 1){
            self.zodiaTableView = tableView;
        }else if (i == 2){
            self.elementsTableView = tableView;
        }else if (i == 3){
            self.animalTableView = tableView;
        }
        tableView.frame = CGRectMake(SCREENWIDTH *i, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 40);
        tableView.backgroundColor = [UIColor whiteColor]; 
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[XPBAttributeReferenceColorCell class] forCellReuseIdentifier:@"attributeReferenceColorCell"];
        [tableView registerClass:[XPBAttributeReferenceZodiaCell class] forCellReuseIdentifier:@"attributeReferenceZodiaCell"];
        tableView.tableFooterView = [UIView new];
        
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
        tableView.mj_header = header;
    }
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
    
    NSArray *titleArr = @[@"波色",@"生肖",@"五行",@"家禽野兽"];
    for(int i = 0 ; i < titleArr.count;i++)
    {
        UIButton *btn = [UIButton new];
        [titleView addSubview:btn];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:GlobalLightGreyColor];
        btn.frame = CGRectMake(i * SCREENWIDTH/4, 0, SCREENWIDTH/4, 36);
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickTitleViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        if(i == 0)
        {
            [self didClickTitleViewBtn:btn];
            btn.selected = YES;
            [btn setBackgroundColor:GlobalRoseRedColor];
            self.selectedBtn = btn;
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 0:
            return self.colorTitleArr.count;
            break;
        case 1:
            return self.zodiaTitleArr.count;
            break;
        case 2:
            return self.elementsTitleArr.count;
            break;
        default:
            return self.animalTitleArr.count;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0 || tableView.tag == 2)
    {
        XPBAttributeReferenceColorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attributeReferenceColorCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(tableView.tag == 0)
        {
            cell.nameStr = self.colorTitleArr[indexPath.row];
            NSArray *colorKeysArr = [self.colorDataDic allKeys];
            NSArray *colorValuesArr = [self.colorDataDic allValues];
            cell.dataSource = [self getDataArrWithKey:self.colorTitleArr[indexPath.row] KeysArr:colorKeysArr AndValuesArr:colorValuesArr].copy;
        
        }else{
            cell.nameStr = self.elementsTitleArr[indexPath.row];
            NSArray *elementKeysArr = [self.elementDataDic allKeys];
            NSArray *elementValuesArr = [self.elementDataDic allValues];
            cell.dataSource = [self getDataArrWithKey:self.elementsTitleArr[indexPath.row] KeysArr:elementKeysArr AndValuesArr:elementValuesArr].copy;
        }
        return cell;
    }else {
        XPBAttributeReferenceZodiaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attributeReferenceZodiaCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(tableView.tag == 1)
        {
            cell.nameStr = self.zodiaTitleArr[indexPath.row];
            NSArray *zodiaKeysArr = [self.zodiaDataDic allKeys];
            NSArray *zodiaValuesArr = [self.zodiaDataDic allValues];
            cell.dataSource = [self getDataArrWithKey:self.zodiaTitleArr[indexPath.row] KeysArr:zodiaKeysArr AndValuesArr:zodiaValuesArr].copy;
        }else{
            cell.nameStr = self.animalTitleArr[indexPath.row];
            NSArray *animalKeysArr = [self.animalDataDic allKeys];
            NSArray *animalValuesArr = [self.animalDataDic allValues];
            cell.dataSource = [self getDataArrWithKey:self.animalTitleArr[indexPath.row] KeysArr:animalKeysArr AndValuesArr:animalValuesArr].copy;
        }
        return cell;
    }
    
}

-(NSArray *)getDataArrWithKey:(NSString *)key KeysArr:(NSArray *)keys AndValuesArr:(NSArray *)values{
    
    if([key isEqualToString:@"家禽"] || [key isEqualToString:@"野兽"])
    {
        NSArray *arr = nil;
        for(int i = 0; i < keys.count; i++){
            if([key isEqualToString:keys[i]])
            {
               arr = values[i];
            }
        }
        return arr;
        
    }else{
        NSArray <XPBReferenceBallModel *>*dataArr = nil;
        for(int i = 0; i < keys.count; i++){
            if([key isEqualToString:keys[i]])
            {
                dataArr = [XPBReferenceBallModel mj_objectArrayWithKeyValuesArray:values[i]];
            }
        }
        return dataArr;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0){
        return 100;
    }else if (tableView.tag == 2){
        return 65;
    }else{
        return 45;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   if(scrollView.tag == 1000)
   {
       CGFloat offsetX =scrollView.contentOffset.x;
       if(offsetX == SCREENWIDTH || offsetX == SCREENWIDTH * 2 ||offsetX == SCREENWIDTH * 3 || offsetX == 0)
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
                       [btn setBackgroundColor:GlobalRoseRedColor];
                       self.selectedBtn.selected = NO;
                       [self.selectedBtn setBackgroundColor:GlobalLightGreyColor];
                       self.selectedBtn = btn;
                       [self didClickTitleViewBtn:btn];
                   }
               }
           }
       }
   }
}

-(void)didClickTitleViewBtn:(UIButton *)sender
{
    [_scrollView setContentOffset:CGPointMake(sender.tag * SCREENWIDTH, 0) animated:YES];
}

-(NSArray *)zodiaTitleArr
{
    if(_zodiaTitleArr == nil)
    {
        _zodiaTitleArr = @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"];
    }
    return _zodiaTitleArr;
}

-(NSArray *)colorTitleArr
{
    if(_colorTitleArr == nil)
    {
        _colorTitleArr = @[@"红波",@"蓝波",@"绿波"];
    }
    return _colorTitleArr;
}

-(NSArray *)elementsTitleArr
{
    if(_elementsTitleArr == nil)
    {
        _elementsTitleArr = @[@"金",@"木",@"水",@"火",@"土"];
    }
    return  _elementsTitleArr;
}

-(NSArray *)animalTitleArr
{
    if(_animalTitleArr == nil)
    {
        _animalTitleArr = @[@"家禽",@"野兽"];
    }
    return _animalTitleArr;
}

@end
