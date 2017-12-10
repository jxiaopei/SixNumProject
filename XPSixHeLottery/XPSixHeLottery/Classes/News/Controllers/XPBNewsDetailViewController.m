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

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)CGFloat imgH;

@end

@implementation XPBNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻详情";
    [self customBackBtn];
    [self setupUI];
}

-(void)setupUI{
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    _titleLab = [UILabel new];
    [_scrollView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREENWIDTH-30);
        make.top.mas_equalTo(10);
    }];
    _titleLab.font = [UIFont systemFontOfSize:22];
    _titleLab.numberOfLines = 0;
    
    _dateLab = [UILabel new];
    [_scrollView addSubview:_dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCREENWIDTH-15);
        make.top.mas_equalTo(_titleLab.mas_bottom).mas_offset(5);
    }];
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.font = [UIFont systemFontOfSize:13];
    _dateLab.textColor = [UIColor grayColor];
    
    UIView *line = [UIView new];
     [_scrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.top.mas_equalTo(_dateLab.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = .3;
    
    _imageView = [UIImageView new];
    [_scrollView addSubview:_imageView];
    _imageView.frame = CGRectMake(0, 65, SCREENWIDTH, 0);
    _imgH = 0;
    
    _textView = [UITextView new];
    [_scrollView addSubview:_textView];
    _textView.frame = CGRectMake(5, 65, SCREENWIDTH-10, SCREENHEIGHT - 60 - 64);
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = [UIColor darkGrayColor];
    _textView.text= @"我在这里";
    
    NSDictionary *parameters = nil;
    
    if([BPUserModel shareModel].isLogin){
        parameters = @{ @"id": self.newsID,
                        @"mission_id" : @"15",
                        @"user_account" :[BPUserModel shareModel].userAccount,
                        };
    }else{
        parameters = @{ @"id": self.newsID,
                        };
    }
    
    NSLog(@"%@",BaseUrl(NewsDetail));
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":NewsDetail,
                           @"paramData":parameters
                           };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(NewsDetail) parameters:dict success:^(id responseObject) {

        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            NSArray *images = responseObject[@"data"][@"news_image"];
            if(images.count){
                NSString *picDataStr = responseObject[@"data"][@"news_image"][0];
                NSArray *imgStrArr = [picDataStr componentsSeparatedByString:@","];
                picDataStr = imgStrArr[1];
                UIImage *image = nil;
                if([picDataStr isNotNil])
                {
                    NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:picDataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
                    
                    if(decodedImage != nil)
                    {
                        image = decodedImage;
                        CGFloat imgH =  image.size.height / image.size.width *SCREENWIDTH;
                        _imgH = imgH;
                        _imageView.frame = CGRectMake(0, 65, SCREENWIDTH, imgH);
                        _imageView.image = image;
                    }
                }
            }
            _imgH = _imgH > 0? _imgH : 0;
            
            _titleLab.text = responseObject[@"data"][@"news_title"];
            NSString *date = responseObject[@"data"][@"create_time"];
            _dateLab.text = [date insertStandardTimeFormat];
            NSString *htmlStr = responseObject[@"data"][@"data_content"];
            NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute :NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            _textView.attributedText = attributeStr;
            CGSize textSize = [_textView.text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 10, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
            
            CGFloat textHeight = textSize.height < 60 ? 60 : textSize.height;
            _textView.frame = CGRectMake(5, 65 + _imgH, SCREENWIDTH-10, textHeight);
            [_scrollView setContentSize:CGSizeMake(SCREENWIDTH, _imgH + textHeight + 75)];
        }

    } fail:^(NSError *error) {
        
    }];
    
}

@end
