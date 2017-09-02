//
//  XPBNewsDetailViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/18.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBNewsDetailViewController.h"

@interface XPBNewsDetailViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *dateLab;

@end

@implementation XPBNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻详情";
    [self setupUI];
}

-(void)setupUI{
    _titleLab = [UILabel new];
    [self.view addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
    }];
    _titleLab.font = [UIFont systemFontOfSize:22];
    _titleLab.numberOfLines = 0;
    
    _dateLab = [UILabel new];
    [self.view addSubview:_dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_titleLab.mas_bottom).mas_offset(5);
    }];
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.font = [UIFont systemFontOfSize:13];
    _dateLab.textColor = [UIColor grayColor];
    
    UIView *line = [UIView new];
     [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_dateLab.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = .3;
    
    _textView = [UITextView new];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(0);
    }];
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = [UIColor darkGrayColor];
    _textView.text= @"我在这里";
    
    NSLog(@"%@",BaseUrl(NewsDetail));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":NewsDetail,
                           @"paramData":@{ @"news_id": self.newsID }
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(NewsDetail) parameters:dict success:^(id responseObject) {
//        NSLog(@"%@",[responseObject mj_JSONString]);
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            _titleLab.text = responseObject[@"data"][@"news_title"];
            NSString *date = responseObject[@"data"][@"create_time"];
            _dateLab.text = [date insertStandardTimeFormat];
            _textView.text = responseObject[@"data"][@"data_content"];
        }

    } fail:^(NSError *error) {
        
    }];
    
}

@end
