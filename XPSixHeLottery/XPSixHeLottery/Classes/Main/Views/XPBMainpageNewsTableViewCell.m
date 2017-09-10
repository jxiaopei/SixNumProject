//
//  XPBMainpageNewsTableViewCell.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/18.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBMainpageNewsTableViewCell.h"

@interface XPBMainpageNewsTableViewCell()

@property(nonatomic,strong)UILabel *newsTitle;
@property(nonatomic,strong)UITextView *newsDetail;
@property(nonatomic,strong)UIImageView *newsImage;

@end

@implementation XPBMainpageNewsTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *newsTitle = [UILabel new];
        [self addSubview:newsTitle];
        _newsTitle = newsTitle;
        [newsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-10);
        }];
        newsTitle.font = [UIFont systemFontOfSize:15];
        newsTitle.textColor = [UIColor blackColor];
        newsTitle.text = @"菲律宾新闻";
        
        UITextView  *newsDetail = [UITextView  new];
        [self addSubview:newsDetail];
        _newsDetail = newsDetail;
        [newsDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(newsTitle);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-13);
            make.top.mas_equalTo(newsTitle.mas_bottom).mas_offset(5);
        }];
        newsDetail.font = [UIFont systemFontOfSize:13];
        newsDetail.textColor = [UIColor grayColor];
        newsDetail.text = @"新闻内容";
        newsDetail.editable = NO;
        newsDetail.userInteractionEnabled = NO;
        
        UIImageView *newsImage = [UIImageView new];
        [self addSubview:newsImage];
        _newsImage = newsImage;
        [newsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-2);
            make.top.mas_equalTo(2);
        }];
        
    }
    return self;
}

-(void)setModel:(XPBNewsDataModel *)model
{
    _model = model;
    _newsTitle.text = model.news_title;
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithData:[model.news_content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute :NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    _newsDetail.attributedText = attributeStr;
    
}

@end
