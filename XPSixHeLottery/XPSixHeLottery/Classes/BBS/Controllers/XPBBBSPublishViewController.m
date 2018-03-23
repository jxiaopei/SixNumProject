//
//  XPBBBSPublishViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBBBSPublishViewController.h"
#import "DTextField.h"

@interface XPBBBSPublishViewController ()<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UILabel *placeholder;
@property(nonatomic,strong)UITextView *contentText;
@property(nonatomic,strong)DTextField *titleText;
@property(nonatomic,strong)UIButton *publishBtn;

@end

@implementation XPBBBSPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表新帖";
    [self customBackBtn];
    [self setupUI];
}

-(void)setupUI{
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    scrollView.delegate = self;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [scrollView setContentSize:CGSizeMake(SCREENWIDTH, SCREENHEIGHT - 64 + 10)];
    
    UILabel *titleLabel = [UILabel new];
    [scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(50);
    }];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"标题:";
    
    DTextField *titleText = [DTextField new];
    [scrollView addSubview:titleText];
    _titleText = titleText;
    [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
        make.left.mas_equalTo(titleLabel.mas_right).mas_offset(3);
        make.width.mas_equalTo(SCREENWIDTH-20);
    }];
    titleText.placeholder = @"(必填,最多30字)";
    titleText.font = [UIFont systemFontOfSize:16];
    titleText.textAlignment = NSTextAlignmentLeft;
    titleText.delegate = self;
    
    UIView *lineView = [UIView new];
    [scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREENWIDTH-20);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10);
    }];
    lineView.backgroundColor = [UIColor grayColor];
    
    UIButton *publishBtn = [UIButton new];
    [scrollView addSubview:publishBtn];
    _publishBtn = publishBtn;
    publishBtn.frame = CGRectMake(0, SCREENHEIGHT - 50 - 64, SCREENWIDTH, 50);
    publishBtn.backgroundColor = GlobalOrangeColor;
    [publishBtn setTitle:@"发 布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [publishBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *textView = [UITextView new];
    [scrollView addSubview:textView];
    _contentText = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREENWIDTH-20);
        make.bottom.mas_equalTo(publishBtn.mas_top).mas_offset(-5);
    }];
    textView.delegate =self;
    textView.font = [UIFont systemFontOfSize:18];
    
    _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, 200, 20)];
    _placeholder.enabled = NO;
    _placeholder.text = @"请输入内容";
    _placeholder.font =  [UIFont systemFontOfSize:18];
    _placeholder.textColor = [UIColor lightGrayColor];
    [textView addSubview:_placeholder];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    _publishBtn.frame = CGRectMake(0, SCREENHEIGHT - 50 - 64 + offsetY, SCREENWIDTH, 50);
}


-(void)didClickPublishBtn:(UIButton *)sender
{
    if (![_titleText.text isNotNil]) {
        _titleText.promptText = @"请输入标题";
        return;
    }
    
    NSLog(@"%@",BaseUrl(BBSPublish));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":BBSPublish,
                           @"paramData":@{ @"post_title":_titleText.text,
                                           @"post_content":_contentText.text,
                                           @"user_id" :[BPUserModel shareModel].uid,
                                           @"mission_id" : @"16",
                                           @"user_account" :[BPUserModel shareModel].userAccount,}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(BBSPublish) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [MBProgressHUD showSuccess:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"发布失败"];
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"发布失败"];
    }];

    
}

- (void) textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        
        [_placeholder setHidden:NO];
        
    }else{
        [_placeholder setHidden:YES];
        
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     [self.view endEditing:YES];
}

@end
