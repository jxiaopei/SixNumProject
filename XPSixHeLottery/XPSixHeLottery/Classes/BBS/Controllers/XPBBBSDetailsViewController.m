//
//  XPBBBSDetailsViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBBSDetailsViewController.h"
#import "XPBBBSCommentTableViewCell.h"
#import "XPBBBSDetailsDataModel.h"
#import "XPBLoginViewController.h"

#define kAnimationDuration 0.2

@interface XPBBBSDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *commentsArr;
@property(nonatomic,copy)void(^didCommentsGetData)(XPBBBSDetailsDataModel *dataModel);
@property(nonatomic,strong)XPBBBSDetailsDataModel *dataModel;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *placeholder;
@property(nonatomic,strong)UITextView *contentText;
@property(nonatomic,strong)UIButton *appreciatesBtn;

@end

@implementation XPBBBSDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热帖详情";
    self.view.backgroundColor = GlobalLightGreyColor;
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    [self setupTableView];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(BBSDetail));
    NSString *uid = @"";
    if([BPUserModel shareModel].isLogin)
    {
        uid = [BPUserModel shareModel].uid;
    }
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":BBSDetail,
                           @"paramData":@{@"main_id" :_mianId,@"user_id":uid}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(BBSDetail) parameters:dict success:^(id responseObject) {
        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [_scrollView.mj_header endRefreshing];
            _dataModel = [XPBBBSDetailsDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.didCommentsGetData(_dataModel);
            _commentsArr = _dataModel.reply_list;
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}


-(void)setupTableView
{
    UIButton *publishBtn = [UIButton new];
    [self.view addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-5);
    }];
    publishBtn.backgroundColor = GlobalOrangeColor;
    publishBtn.layer.masksToBounds = YES;
    publishBtn.layer.cornerRadius = 5;
    [publishBtn setTitle:@"评 论" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [publishBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(publishBtn.mas_top).mas_offset(-5);
    }];
    [scrollView setContentSize:CGSizeMake(SCREENWIDTH - 10, SCREENHEIGHT - 64- 45)];
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    scrollView.mj_header = header;
    _scrollView = scrollView;
    
    UIView *titleView = [UIView new];
    [scrollView addSubview:titleView];
    titleView.frame = CGRectMake(5, 5, SCREENWIDTH - 10, 60);
    titleView.backgroundColor = GlobalOrangeColor;
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 10;
    
    UILabel *titleLabel = [UILabel new];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(5);
    }];
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont systemFontOfSize:18];
    
    UIButton *appreciatesBtn = [UIButton new];
    [titleView addSubview:appreciatesBtn];
    _appreciatesBtn = appreciatesBtn;
    [appreciatesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
    }];
    [appreciatesBtn setTitle:@"0" forState:UIControlStateNormal];
    [appreciatesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appreciatesBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [appreciatesBtn setImage:[UIImage imageNamed:@"未点赞"] forState:UIControlStateNormal];
    [appreciatesBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateSelected];
    appreciatesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    appreciatesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [appreciatesBtn addTarget:self action:@selector(didClickAppreciatesBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *anthorLabel = [UILabel new];
    [titleView addSubview:anthorLabel];
    [anthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-5);
    }];
    anthorLabel.text = @"楼主:作者";
    anthorLabel.font = [UIFont systemFontOfSize:15];
    anthorLabel.textColor = [UIColor grayColor];
    
    UILabel *dateLabel = [UILabel new];
    [titleView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-5);
    }];
    dateLabel.text = @"2017-08-11 10:20:41";
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = [UIColor grayColor];
    
    UITextView *textView = [UITextView new];
    [scrollView addSubview:textView];
    textView.frame = CGRectMake(5, 70, SCREENWIDTH -10, 30);
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor darkGrayColor];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 10;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.text= @"我在这里";
    
    UILabel *commentsLabel = [UILabel new];
    [scrollView addSubview:commentsLabel];
    [commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(SCREENWIDTH - 10);
        make.top.mas_equalTo(textView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(30);
    }];
    commentsLabel.layer.masksToBounds = YES;
    commentsLabel.layer.cornerRadius = 10;
    commentsLabel.backgroundColor = [UIColor grayColor];
    commentsLabel.font = [UIFont systemFontOfSize:15];
    commentsLabel.text = @"评论(0)";
    commentsLabel.textColor = [UIColor blackColor];
    commentsLabel.textAlignment = NSTextAlignmentCenter;
    
    UITableView *tableView = [UITableView new];
    _tableView = tableView;
    [scrollView addSubview:tableView];
    tableView.frame = CGRectMake(0, 140, SCREENWIDTH, 10);
    tableView.backgroundColor = GlobalLightGreyColor;
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.scrollEnabled = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[XPBBBSCommentTableViewCell class] forCellReuseIdentifier:@"bbsCommentsCell"];
    tableView.tableFooterView = [UIView new];
    
    __weak typeof(self) weakSelf = self;
    self.didCommentsGetData = ^(XPBBBSDetailsDataModel *dataModel) {
        titleLabel.text = dataModel.post_title;
        anthorLabel.text = [NSString stringWithFormat:@"楼主:%@", dataModel.main_user_name];
        dateLabel.text = dataModel.main_time;
        textView.text = dataModel.post_content;
        [weakSelf.appreciatesBtn setTitle:[NSString stringWithFormat:@"%zd",dataModel.like_count] forState:UIControlStateNormal];
       
        weakSelf.appreciatesBtn.selected = [dataModel.like_user_id isNotNil];
        
        CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 10, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        
        CGFloat textHeight = textSize.height < 60 ? 60 : textSize.height;
        textView.frame = CGRectMake(5, 70, SCREENWIDTH -10, textHeight);
        tableView.frame = CGRectMake(0, 110 + textHeight, SCREENWIDTH, dataModel.reply_list.count * 60);
        [scrollView setContentSize:CGSizeMake(SCREENWIDTH, 110 + textHeight + dataModel.reply_list.count * 60)];
        [weakSelf.tableView reloadData];
        commentsLabel.text = [NSString stringWithFormat:@"评论(%zd)",dataModel.reply_count];
    };
}

-(void)didClickAppreciatesBtn:(UIButton *)sender{
    
    if([_dataModel.like_user_id isNotNil])
    {
        [MBProgressHUD showError:@"您已经点赞过该帖子了"];
        return;
    }
    
    if(![BPUserModel shareModel].isLogin)
    {
        XPBLoginViewController *loginVC = [XPBLoginViewController new];
        loginVC.popVC = self;
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        
        NSLog(@"%@",BaseUrl(BBSAppreciates));
        NSDictionary *dict = @{
                               @"token":@"24e9dec7-fca1-42ae-b052-134db776a9b5",
                               @"uri":BBSAppreciates,
                               @"paramData":@{ @"main_id":self.mianId,
                                               @"user_id" :[BPUserModel shareModel].uid}
                               
                               };
        [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(BBSAppreciates) parameters:dict success:^(id responseObject) {
            NSLog(@"%@",[responseObject mj_JSONString]);
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                [MBProgressHUD showSuccess:@"点赞成功"];
                [self getData];
            }else{
                [MBProgressHUD showError:@"操作失败"];
            }
        } fail:^(NSError *error) {
            [MBProgressHUD showError:@"操作失败"];
        }];
    }
    
}

-(void)didClickPublishBtn:(UIButton *)sender{
    
    if(![BPUserModel shareModel].isLogin)
    {
        XPBLoginViewController *loginVC = [XPBLoginViewController new];
        loginVC.popVC = self;
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        
        UIView *markView = [UIView new];
        [self.view addSubview:markView];
        markView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT -64);
        markView.backgroundColor = [UIColor blackColor];
        markView.tag = 2000;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMarkView)];
        [markView addGestureRecognizer:tap];
        
        UIView *commentsView = [UIView new];
        [self.view addSubview:commentsView];
        commentsView.backgroundColor = [UIColor whiteColor];
        commentsView.tag = 1000;
        commentsView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 150);
        
        UIButton *cancelBtn = [UIButton new];
        [commentsView addSubview:cancelBtn];
        cancelBtn.frame = CGRectMake(10, 5, 60, 25);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(dismissMarkView) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmBtn = [UIButton new];
        [commentsView addSubview:confirmBtn];
        confirmBtn.frame = CGRectMake(SCREENWIDTH - 70, 5, 60, 25);
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmBtn addTarget:self action:@selector(publishComments) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *replyTitle = [UILabel new];
        [commentsView addSubview:replyTitle];
        [replyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cancelBtn.mas_right).mas_offset(5);
            make.right.mas_equalTo(confirmBtn.mas_left).mas_offset(5);
            make.centerY.mas_equalTo(cancelBtn.mas_centerY);
        }];
        replyTitle.textColor = [UIColor blackColor];
        replyTitle.text = @"回复帖子";
        replyTitle.font = [UIFont systemFontOfSize:18];
        replyTitle.textAlignment = NSTextAlignmentCenter;
        
        
        UITextView *textView = [UITextView new];
        [commentsView addSubview:textView];
        _contentText = textView;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(35);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-5);
        }];
        
        textView.delegate =self;
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = [UIColor grayColor].CGColor;
        textView.font = [UIFont systemFontOfSize:18];
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 5;
        
        _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, 200, 20)];
        _placeholder.enabled = NO;
        _placeholder.text = @"请输入内容";
        _placeholder.font =  [UIFont systemFontOfSize:18];
        _placeholder.textColor = [UIColor lightGrayColor];
        [textView addSubview:_placeholder];
        [textView becomeFirstResponder];
        
    }
    
}

//键盘弹出时

-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有textView的view的位置
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view viewWithTag:1000].frame = CGRectMake(0, SCREENHEIGHT-keyboardRect.size.height-150 -64, SCREENWIDTH, 150);
        [self.view viewWithTag:2000].frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT -64);
        [self.view viewWithTag:2000].alpha = 0.8;
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)publishComments{
    
    NSLog(@"%@",BaseUrl(BBSComment));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":BBSComment,
                           @"paramData":@{ @"main_id":self.mianId,
                                           @"reply_content":_contentText.text,
                                           @"user_id" :[BPUserModel shareModel].uid}
                          
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(BBSComment) parameters:dict success:^(id responseObject) {
        //        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"评论成功"];
            [self getData];
            
        }else{
            [MBProgressHUD showError:@"评论失败"];
        }
        [self dismissMarkView];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"评论失败"];
        [self dismissMarkView];
    }];
    
}

-(void)dismissMarkView{
    [_contentText endEditing:YES];
}

//键盘消失时
-(void)keyboardDidHidden{
    //定义动画
    [UIView animateWithDuration:kAnimationDuration*2 animations:^{
        [self.view viewWithTag:1000].frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 150);
        [self.view viewWithTag:2000].frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT -64);
        [self.view viewWithTag:2000].alpha = 0;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:2000]  removeFromSuperview];
        [[self.view viewWithTag:1000]  removeFromSuperview];
    }];
}

- (void) textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        [_placeholder setHidden:NO];
    }else{
        [_placeholder setHidden:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPBBBSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bbsCommentsCell" forIndexPath:indexPath];
    XPBBBSCommentsModel *commentModel = _commentsArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"personal"];
    cell.textLabel.text = commentModel.reply_user_name;
    cell.detailTextLabel.text = commentModel.reply_content;
    cell.dateLabel.text = commentModel.reply_time;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
