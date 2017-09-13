//
//  XPBFreeInforDetailViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/28.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBFreeInforDetailViewController.h"
#import "XPBFreeInforListDataModel.h"

@interface XPBFreeInforDetailViewController ()

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,copy)void(^didFreeInforGetData)(XPBFreeInforListDataModel *dataModel);
@property(nonatomic,strong)XPBFreeInforListDataModel *dataModel;

@end

@implementation XPBFreeInforDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费资料详情";
    self.view.backgroundColor = GlobalLightGreyColor;
    [self setupScrollView];
    [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(FreeInforDetail));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":FreeInforDetail,
                           @"paramData":@{@"main_id" :_mianId}
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(FreeInforDetail) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            [_scrollView.mj_header endRefreshing];
            _dataModel = [XPBFreeInforListDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.didFreeInforGetData(_dataModel);

        }
        
    } fail:^(NSError *error) {
        
    }];
}


-(void)setupScrollView
{

    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
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
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
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
    
    self.didFreeInforGetData = ^(XPBFreeInforListDataModel *dataModel) {
        titleLabel.text = dataModel.post_title;
        dateLabel.text = dataModel.main_time;
        textView.text = dataModel.post_content;
        
        CGSize titleSize = [titleLabel.text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 20, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
        titleView.frame = CGRectMake(5, 5, SCREENWIDTH - 10, 30 + titleSize.height);

        CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 10, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        
        CGFloat textHeight = textSize.height < 60 ? 60 : textSize.height;
        textView.frame = CGRectMake(5, 40 + titleSize.height, SCREENWIDTH -10, textHeight);
        [scrollView setContentSize:CGSizeMake(SCREENWIDTH, 50 + titleSize.height + textHeight)];

    };
}



@end
