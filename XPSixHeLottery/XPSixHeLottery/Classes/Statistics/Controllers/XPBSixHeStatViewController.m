//
//  XPBSixHeStatViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/5.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBSixHeStatViewController.h"
#import "XPBSixHeStatNumTableViewCell.h"
#import "XPBSixHeStatZodiaTableViewCell.h"
#import "XPBSixHeStatColorTableViewCell.h"
#import "XPBReferenceBallModel.h"

@interface XPBSixHeStatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *scrollView;

@property(nonatomic,strong)NSArray *numTitleArr;
@property(nonatomic,strong)NSArray *zodiaTitleArr;
@property(nonatomic,strong)NSArray *colorTitleArr;

@property(nonatomic,strong)NSArray *numDataArr;
@property(nonatomic,strong)NSArray *zodiaDataArr;
@property(nonatomic,strong)NSArray *colorDataArr;

@property(nonatomic,strong)UITableView *numTableView;
@property(nonatomic,strong)UITableView *zodiaTableView;
@property(nonatomic,strong)UITableView *colorTableView;

@end

@implementation XPBSixHeStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"六合统计";
    [self customBackBtn];
    UITableView *scrollView = [UITableView new];
    [self.view addSubview:scrollView];
    scrollView.tableFooterView = [UIView new];
    _scrollView = scrollView;
    scrollView.backgroundColor = GlobalLightGreyColor;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    scrollView.mj_header = header;
    
    [self setupNumView];
    [self setupZodiaView];
    [self setupColorView];
    [self getData];
    
}

-(void)getData{
    NSLog(@"%@",BaseUrl(StatisticDetail));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":StatisticDetail,
                           @"paramData":@{}//@"user_id" :uid
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(StatisticDetail) parameters:dict success:^(id responseObject) {

        [_scrollView.mj_header endRefreshing];
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            NSArray <XPBReferenceBallModel *>*spcNumMaxArr = [XPBReferenceBallModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tmMoreList"]];
            NSArray <XPBReferenceBallModel *>*spcNumMinArr = [XPBReferenceBallModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tmFewList"]];
            NSArray <XPBReferenceBallModel *>*norNumMaxArr = [XPBReferenceBallModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"zmMoreList"]];
            NSArray <XPBReferenceBallModel *>*norNumMinArr = [XPBReferenceBallModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"zmFewList"]];
            
            NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:spcNumMaxArr,spcNumMinArr,norNumMaxArr,norNumMinArr, nil];
            _numDataArr = mutableArr.copy;
            
            NSArray *spcZodiaMaxArr = responseObject[@"data"][@"tmSxMoreList"];
            NSArray *spcZodiaMinArr = responseObject[@"data"][@"tmSxFewList"];
            NSArray *norZodiaMaxArr = responseObject[@"data"][@"zmSxMoreList"];
            NSArray *norZodiaMinArr = responseObject[@"data"][@"zmSxFewList"];
            
            _zodiaDataArr = @[spcZodiaMaxArr,spcZodiaMinArr,norZodiaMaxArr,norZodiaMinArr];
            
            NSArray *spcColorMaxArr = responseObject[@"data"][@"tmBsMoreList"];
            NSArray *spcColorMinArr = responseObject[@"data"][@"tmBsFewList"];
            NSArray *norColorMaxArr = responseObject[@"data"][@"zmBsMoreList"];
            NSArray *norColorMinArr = responseObject[@"data"][@"zmBsFewList"];
            _colorDataArr = @[spcColorMaxArr,spcColorMinArr,norColorMaxArr,norColorMinArr];
            
            [_numTableView reloadData];
            [_zodiaTableView reloadData];
            [_colorTableView reloadData];
            
        }else{
            
        }
    } fail:^(NSError *error) {
       [_scrollView.mj_header endRefreshing];
    }];
}

-(void)setupNumView{
    UITableView *numTableView = [UITableView new];
    [_scrollView addSubview:numTableView];
    numTableView.backgroundColor = [UIColor whiteColor];
    numTableView.dataSource = self;
    numTableView.delegate =self;
    numTableView.frame = CGRectMake(0, 0, SCREENWIDTH, 230);
    numTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    numTableView.scrollEnabled = NO;
    numTableView.tag = 100;
    _numTableView = numTableView;
    [numTableView registerClass:[XPBSixHeStatNumTableViewCell class] forCellReuseIdentifier:@"statNumCell"];
}

-(void)setupZodiaView{
    UITableView *zodiaTableView = [UITableView new];
    [_scrollView addSubview:zodiaTableView];
    zodiaTableView.backgroundColor = [UIColor whiteColor];
    zodiaTableView.dataSource = self;
    zodiaTableView.delegate =self;
    zodiaTableView.frame = CGRectMake(0, 240, SCREENWIDTH, 120);
    zodiaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    zodiaTableView.scrollEnabled = NO;
    zodiaTableView.tag = 200;
    _zodiaTableView = zodiaTableView;
    [zodiaTableView registerClass:[XPBSixHeStatZodiaTableViewCell class] forCellReuseIdentifier:@"statZodiaCell"];
}

-(void)setupColorView{
    UITableView *colorTableView = [UITableView new];
    [_scrollView addSubview:colorTableView];
    colorTableView.backgroundColor = [UIColor whiteColor];
    colorTableView.dataSource = self;
    colorTableView.delegate =self;
    colorTableView.frame = CGRectMake(0, 370, SCREENWIDTH, 120);
    colorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    colorTableView.scrollEnabled = NO;
    colorTableView.tag = 300;
    _colorTableView = colorTableView;
    [colorTableView registerClass:[XPBSixHeStatColorTableViewCell class] forCellReuseIdentifier:@"statColorCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 100)
    {
        XPBSixHeStatNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statNumCell" forIndexPath:indexPath];
        cell.titleStr = self.numTitleArr[indexPath.row];
        cell.dataSource = self.numDataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.didClickBtnBlock = ^(NSString *title, NSString *btnTitle, NSInteger count){
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:[NSString stringWithFormat:@"%@出现了%zd次",btnTitle,count ] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cofrimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alert addAction:cofrimAction];
//            [self.navigationController presentViewController:alert animated:YES completion:nil];
//        };
        return cell;
    }else if(tableView.tag == 200){
        XPBSixHeStatZodiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statZodiaCell" forIndexPath:indexPath];
        cell.titleStr = self.zodiaTitleArr[indexPath.row];
        cell.dataSource = self.zodiaDataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.didClickBtnBlock = ^(NSString *title, NSString *btnTitle, NSInteger count){
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:[NSString stringWithFormat:@"%@出现了%zd次",btnTitle,count ] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cofrimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alert addAction:cofrimAction];
//            [self.navigationController presentViewController:alert animated:YES completion:nil];
//        };
        return cell;
    }else{
        XPBSixHeStatColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statColorCell" forIndexPath:indexPath];
        cell.titleStr = self.colorTitleArr[indexPath.row];
        cell.dataSource = self.colorDataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.didClickBtnBlock = ^(NSString *title, NSString *btnTitle, NSInteger count){
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:[NSString stringWithFormat:@"%@出现了%zd次",btnTitle,count ] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cofrimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alert addAction:cofrimAction];
//            [self.navigationController presentViewController:alert animated:YES completion:nil];
//        };
        return cell;
    }

}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 100)
    {
      return 55;
    }
    return 30;
}

-(NSArray *)numTitleArr
{
    if(_numTitleArr == nil)
    {
        _numTitleArr = @[@"特码出现期数最多的号码",@"特码未出现期数最多的号码",@"平码出现期数最多的号码",@"平码未出现期数最多的号码"];
    }
    return _numTitleArr;
}

-(NSArray *)zodiaTitleArr
{
    if(_zodiaTitleArr == nil)
    {
        _zodiaTitleArr = @[@"特码出现期数最多的生肖",@"特码未出现期数最少的生肖",@"平码出现期数最多的生肖",@"平码未出现期数最少的生肖"];
    }
    return _zodiaTitleArr;
}

-(NSArray *)colorTitleArr
{
    if(_colorTitleArr == nil)
    {
        _colorTitleArr = @[@"特码出现期数最多的波色",@"特码未出现期数最多的波色",@"平码出现期数最多的波色",@"平码未出现期数最多的波色"];
    }
    return _colorTitleArr;
}




@end
