//
//  XPBWalletViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/10/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBWalletViewController.h"
#import "XPBWalletDataModel.h"
#import "XPBTransformListModel.h"
#import "XPBWalletListTableViewCell.h"
#import "DTextField.h"
#import "XPBLoginViewController.h"

@interface XPBWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIView *underLineView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)NSMutableArray <XPBWalletDataModel *>*dataSource;
//pickerView
@property(nonatomic,strong)NSArray <XPBTransformListModel *>*dataArr;
@property(nonatomic,strong)UIView *markView;
@property(nonatomic,assign)NSInteger selectedIndex;
//textFeild
@property(nonatomic,strong)DTextField *moneyText;
@property(nonatomic,strong)DTextField *platfromText;
@property(nonatomic,strong)DTextField *accountText;
@property(nonatomic,assign)NSInteger balance;
@property(nonatomic,strong)UIButton *balanceBtn;

@end

@implementation XPBWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    _pageNum = 1;
    [self setupScrollView];
    [self setupTitleView];
    [self setupTableView];
    [self setTranfromMoneyUI];
    [self getData];
    [self getPlatFromList];
}

-(void)getData{
    if(![BPUserModel shareModel].isLogin){
        return;
    }
    NSLog(@"%@",BaseUrl(MoneyHistroy));
    NSDictionary *dic = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":MoneyHistroy,
                           @"paramData":@{@"user_id":[BPUserModel shareModel].uid,
                                          @"pageNum":[NSNumber numberWithInteger:_pageNum],
                                          @"pageSize":@10,
                                          }
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(MoneyHistroy) parameters:dic success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"]){
            if(_pageNum == 1)
            {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                _dataSource = [XPBWalletDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }else{
                NSMutableArray *mutableArr = [NSMutableArray array];
                mutableArr =   [XPBWalletDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                if(!mutableArr.count)
                {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                    [self.dataSource addObjectsFromArray:mutableArr];
                }
            }
            [_tableView reloadData];
        }else{
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } fail:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

-(void)getPlatFromList{

    NSLog(@"%@",BaseUrl(SiteList));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":SiteList,
                           @"paramData":@{}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(SiteList) parameters:dict success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"]){
            self.dataArr = [XPBTransformListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [_tableView reloadData];
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
    
    if(![BPUserModel shareModel].isLogin){
        return;
    }
    
    NSLog(@"%@",BaseUrl(WalletInfor));
    NSDictionary *dic = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":WalletInfor,
                           @"paramData":@{@"user_id":[BPUserModel shareModel].uid,
                                          }
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(WalletInfor) parameters:dic success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"]){
            _balance = [responseObject[@"data"][@"balance"] integerValue];
            NSString *str = [NSString stringWithFormat:@"总金额: %zd",_balance];
            NSMutableAttributedString *colorStr = [[NSMutableAttributedString alloc] initWithString:str];
            [colorStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5,str.length-5)];
            [_balanceBtn setAttributedTitle:colorStr forState:UIControlStateNormal];
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)setTranfromMoneyUI{
    
    UIView *tranfromView = [UIView new];
    [self.scrollView addSubview:tranfromView];
    tranfromView.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT - 40 - 64);
    
    UIScrollView *scrollView = [UIScrollView new];
    [tranfromView addSubview:scrollView];
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 40 - 64);
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT - 35 - 64);
    scrollView.bounces = YES;
    
    UILabel *tipLabel = [UILabel new];
    [scrollView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
    }];
    NSString *str = @"最低申请: 100元";
    NSMutableAttributedString *colorStr = [[NSMutableAttributedString alloc] initWithString:str];
    [colorStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6,str.length-6)];
    tipLabel.attributedText = colorStr;
    
    UILabel *transfromMoney = [UILabel new];
    [scrollView addSubview:transfromMoney];
    [transfromMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(25);
        make.width.mas_equalTo(80);
        
    }];
    transfromMoney.text = @"转换金额:";
    
    DTextField *moneyText = [DTextField new];
    [scrollView addSubview:moneyText];
    moneyText.backgroundColor = [UIColor whiteColor];
    moneyText.borderStyle = UITextBorderStyleRoundedRect;
    _moneyText = moneyText;
    [moneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(transfromMoney.mas_right).mas_offset(5);
        make.width.mas_equalTo(SCREENWIDTH-125);
        make.centerY.mas_equalTo(transfromMoney);
    }];
    moneyText.placeholder = @"请输入需要转换的金额";
    moneyText.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel *platformLabel = [UILabel new];
    [tranfromView addSubview:platformLabel];
    [platformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(transfromMoney.mas_bottom).mas_offset(25);
        make.width.mas_equalTo(80);
    }];
    platformLabel.text = @"平台选择:";
    
    DTextField *platformText = [DTextField new];
    [scrollView addSubview:platformText];
    platformText.backgroundColor = [UIColor whiteColor];
    platformText.borderStyle = UITextBorderStyleRoundedRect;
    _platfromText = platformText;
    [platformText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(platformLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(SCREENWIDTH-125);
        make.centerY.mas_equalTo(platformLabel);
    }];
    platformText.placeholder = @"请选择平台";
    
    UIButton *platformBtn = [UIButton new];
    [scrollView addSubview:platformBtn];
    [platformBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(platformText);
        make.height.mas_equalTo(25);
    }];
    [platformBtn addTarget:self action:@selector(didClickPlatformBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *accountLabel = [UILabel new];
    [scrollView addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(platformLabel.mas_bottom).mas_offset(25);
        make.width.mas_equalTo(80);
    }];
    accountLabel.text = @"平台账号:";
    
    DTextField *accountText = [DTextField new];
    [scrollView addSubview:accountText];
    _accountText = accountText;
    accountText.backgroundColor = [UIColor whiteColor];
    accountText.borderStyle = UITextBorderStyleRoundedRect;
    [accountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(SCREENWIDTH-125);
        make.centerY.mas_equalTo(accountLabel);
    }];
    accountText.placeholder = @"请输入目标平台账号";
    
    UIButton *transformBtn = [UIButton new];
    [tranfromView addSubview:transformBtn];
    [transformBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(SCREENWIDTH-60);
        make.top.mas_equalTo(accountText.mas_bottom).mas_offset(40);
        make.height.mas_equalTo(44);
    }];
    transformBtn.backgroundColor = GlobalOrangeColor;
    [transformBtn setTitle:@"立即转换" forState:UIControlStateNormal];
    [transformBtn addTarget:self action:@selector(didClickTransformBtn:) forControlEvents:UIControlEventTouchUpInside];
    transformBtn.layer.masksToBounds = YES;
    transformBtn.layer.cornerRadius = 22;
}

-(void)didClickTransformBtn:(UIButton *)sender{
    
    if(![BPUserModel shareModel].isLogin){
        XPBLoginViewController *loginVC = [XPBLoginViewController new];
        loginVC.popVC = self;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if(![_moneyText.text isNotNil]){
        _moneyText.promptText = @"请输入转换金额";
        return;
    }
    
    if([_moneyText.text integerValue] > _balance){
        _moneyText.promptText = @"转换金额不能超过余额";
        return;
    }
    
    if([_moneyText.text integerValue] < 100){
        _moneyText.promptText = @"转换金额不能低于100";
        return;
    }
    
    if(![_platfromText.text isNotNil]){
        _platfromText.promptText = @"请选择转换的平台";
        return;
    }
    
    if(![_accountText.text isNotNil]){
        _accountText.promptText = @"请输入转换平台的账号";
        return;
    }
    
    XPBTransformListModel *model = self.dataArr[_selectedIndex];

    NSLog(@"%@",BaseUrl(Transfrom));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":Transfrom,
                           @"paramData":@{@"user_id":@([[BPUserModel shareModel].uid integerValue]),
                                          @"change_money":@([_moneyText.text integerValue]),
                                          @"site_id":   @(model.Id),
                                          @"site_account": _accountText.text,
                                          }
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(Transfrom) parameters:dict success:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"0000"]){
            [MBProgressHUD showSuccess:@"转换成功"];
            [self getData];
            [self getPlatFromList];
        }else{
            [MBProgressHUD showError:@"转换失败"];
        }
    } fail:^(NSError *error) {
         [MBProgressHUD showError:@"网络错误"];
    }];
}

-(void)didClickPlatformBtn:(UIButton *)sender{
    [_moneyText endEditing:YES];
    [_accountText endEditing:YES];
    [self initPickView];
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
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    NSArray *titleArr = @[@"总金额: 0",@"马上进行转换"];
    for(int i = 0 ; i < titleArr.count;i++)
    {
        UIButton *btn = [UIButton new];
        [titleView addSubview:btn];
        [btn setImage:[UIImage imageNamed:titleArr[i]] forState:UIControlStateNormal];
        NSString *str = titleArr[i];
        NSMutableAttributedString *colorStr = [[NSMutableAttributedString alloc] initWithString:str];
        [colorStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6,str.length-6)];
        [btn setAttributedTitle:colorStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * SCREENWIDTH/2, 0, SCREENWIDTH/2, 36);
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickTitleViewBtn:) forControlEvents:UIControlEventTouchUpInside];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if(i == 0)
        {
            self.balanceBtn = btn;
            [self didClickTitleViewBtn:btn];
            btn.selected = YES;
            self.selectedBtn = btn;
            UIView *underLineView = [UIView new];
            [titleView addSubview:underLineView];
            _underLineView = underLineView;
            underLineView.frame = CGRectMake(0, 35, SCREENWIDTH/2, 3);
            underLineView.backgroundColor = GlobalOrangeColor;
        }
    }
    UIView *tipView = [UIView new];
    tipView.backgroundColor = GlobalLightGreyColor;
    [self.scrollView addSubview:tipView];
    tipView.frame = CGRectMake(0, 0, SCREENWIDTH, 170);
    NSString *str = @"小提示:\n注册1396开奖可获得20金币\n还可通过每日红包获得随机金额的金币\n \n金币与各平台筹码之间的兑换规则为:\n10金币兑换1筹码\n \n假如转换用户不存在或者转换过程中异常,金额会返回到账户中";
    UITextView *textView = [UITextView new];
    textView.backgroundColor = GlobalLightGreyColor;
    [tipView addSubview:textView];
    textView.frame = CGRectMake(10, 10, SCREENWIDTH - 10, 160);
    textView.text = str;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor grayColor];
    
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
                        if(btn.tag == 0)
                        {
                            [self getData];
                            [self getPlatFromList];
//                        }else if ([btn.titleLabel.text isEqualToString:@"收藏"]){
//                            [self getAttentionData];
                        }
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
    [UIView animateWithDuration:0.5 animations:^{
        _underLineView.frame = CGRectMake(SCREENWIDTH/2 * sender.tag, 35, SCREENWIDTH/2, 3);
    }];
}

-(void)setupTableView
{
    UIView *titleView = [UIView new];
    [self.scrollView addSubview:titleView];
    titleView.frame = CGRectMake(0, 170, SCREENWIDTH, 30);
    UILabel *title = [UILabel new];
    [titleView addSubview:title];
    title.frame = CGRectMake(SCREENWIDTH/2 - 40, 5, 80, 20);
    title.text = @"红包记录";
    
    UITableView *tableView = [UITableView new];
    [self.scrollView addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.frame = CGRectMake(0, 200, SCREENWIDTH, SCREENHEIGHT- 64 - 240);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XPBWalletListTableViewCell class] forCellReuseIdentifier:@"walletListCell"];
    _tableView = tableView;
    tableView.rowHeight = 70;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPBWalletListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletListCell" forIndexPath:indexPath];
    cell.dataModel = _dataSource[indexPath.row];
    return cell;
}

-(void)initPickView{
    UIView *markView = [UIView new];
    _markView = markView;
    markView.backgroundColor = GlobalMarkViewColor;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickCancelBtn:)];
    [markView addGestureRecognizer:tap];
    [self.view addSubview:markView];
    markView.frame = self.view.bounds;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT -240 , SCREENWIDTH, 240)];
    titleView.backgroundColor = [UIColor whiteColor];
    [markView addSubview:titleView];
    
    UIPickerView *datePick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    datePick.backgroundColor = [UIColor whiteColor];
    datePick.delegate = self;
    datePick.dataSource = self;
    [titleView addSubview:datePick];
    
    UIButton *cancelBtn = [UIButton new];
    [titleView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    [cancelBtn setTitle:@"取消" forState: UIControlStateNormal];
    [cancelBtn setTitleColor:GlobalOrangeColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *comfirmBtn = [UIButton new];
    [titleView addSubview:comfirmBtn];
    [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);;
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    [comfirmBtn setTitle:@"确定" forState: UIControlStateNormal];
    [comfirmBtn setTitleColor:GlobalOrangeColor forState:UIControlStateNormal];
    [comfirmBtn addTarget:self action:@selector(didClickComfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)didClickCancelBtn:(UIButton *)sender{
    
    [_markView removeFromSuperview];
}

-(void)didClickComfirmBtn:(UIButton *)sender{
    NSLog(@"%zd",_selectedIndex);
    XPBTransformListModel *model = self.dataArr[_selectedIndex];
    _platfromText.text = model.site_name;
    [_markView removeFromSuperview];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    XPBTransformListModel *model = self.dataArr[row];
    return  model.site_name;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectedIndex = row;
}

-(NSArray <XPBTransformListModel *>*)dataArr{
    if(_dataArr == nil){
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

@end
