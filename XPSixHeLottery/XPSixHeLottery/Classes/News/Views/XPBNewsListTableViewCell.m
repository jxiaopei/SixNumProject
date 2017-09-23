//
//  XPBNewsListTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/18.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBNewsListTableViewCell.h"

@interface XPBNewsListTableViewCell()

@property(nonatomic,strong)UILabel *newsTitle;
@property(nonatomic,strong)UITextView *newsDetail;
@property(nonatomic,strong)UIImageView *newsImage;
@property(nonatomic,strong)UILabel *publishLabel;

@end

@implementation XPBNewsListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *newsTitle = [UILabel new];
        [self addSubview:newsTitle];
        _newsTitle = newsTitle;
        [newsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-15);
        }];
        newsTitle.adjustsFontSizeToFitWidth = YES;
        newsTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        newsTitle.textColor = [UIColor blackColor];
        newsTitle.text = @"菲律宾新闻";
        
        UILabel *publishLabel = [UILabel new];
        [self addSubview:publishLabel];
        _publishLabel = publishLabel;
        [publishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-20);
        }];
        publishLabel.font = [UIFont systemFontOfSize:13];
        publishLabel.textColor = [UIColor grayColor];
        
       UITextView  *newsDetail = [UITextView new];
        [self addSubview:newsDetail];
        _newsDetail = newsDetail;
        [newsDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(newsTitle);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(publishLabel.mas_top).mas_offset(-15);
            make.top.mas_equalTo(newsTitle.mas_bottom).mas_offset(10);
        }];
        newsDetail.font = [UIFont systemFontOfSize:14];
        newsDetail.textColor = [UIColor grayColor];
        newsDetail.text = @"新闻内容";
        newsDetail.editable = NO;
        newsDetail.userInteractionEnabled = NO;
        
        UIImageView *newsImage = [UIImageView new];
        [self addSubview:newsImage];
        _newsImage = newsImage;
        [newsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-2);
            make.top.mas_equalTo(2);
        }];
        
        UIView *horView = [UIView new];
        [self addSubview:horView];
        [horView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
        horView.backgroundColor = GlobalLightGreyColor;
        
        
    }
    return self;
}

-(void)setDataModel:(XPBNewsListModel *)dataModel
{
    _dataModel = dataModel;
    _newsTitle.text = dataModel.news_title;
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithData:[dataModel.data_content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute :NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    _newsDetail.attributedText = attributeStr;
    _publishLabel.text = [dataModel.create_time insertStandardTimeFormat];
}

@end
