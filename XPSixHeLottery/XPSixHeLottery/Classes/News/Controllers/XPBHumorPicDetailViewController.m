//
//  XPBHumorPicDetailViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/9/2.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBHumorPicDetailViewController.h"
#import "XPBLoginViewController.h"

@interface XPBHumorPicDetailViewController ()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)CGFloat imgH;

@end

@implementation XPBHumorPicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBtn];
    _isAttention = NO;
    [self setupRightBtn];
    [self setupUI];
    [self getData];
}

-(void)getData{
    NSLog(@"%@",BaseUrl(ImageDetail));
    NSDictionary *paramData = nil;
    if([BPUserModel shareModel].isLogin)
    {
        paramData = @{@"pic_id" : _picID,
                      @"user_id"   : [BPUserModel shareModel].uid,
                      };
    }else{
        paramData = @{@"pic_id" : _picID,
                      };
    }
    NSDictionary *dict = @{
                           @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                           @"uri":ImageDetail,
                           @"paramData":paramData
                           };
    [[BPNetRequest getInstance] postDataWithUrl:BaseUrl(ImageDetail) parameters:dict success:^(id responseObject) {
      
        if([responseObject[@"code"] isEqualToString:@"0000"])
        {
            
            self.picDataStr = responseObject[@"data"][@"imger_dedails"][@"pic_value"];
            UIImage *image = nil;
            if([self.picDataStr isNotNil])
            {
                NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:self.picDataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
                if(decodedImage != nil)
                {
                    image = decodedImage;
                    CGFloat imgH =  image.size.height / image.size.width *SCREENWIDTH;
                    _imgH = imgH;
                    [_imageView sizeToFit];
                    _imageView.frame = CGRectMake(0, 0, SCREENWIDTH, imgH);
                    _imageView.image = image;
                }
            }
            _imgH = _imgH > 0? _imgH : SCREENHEIGHT;
            _textView.text = responseObject[@"data"][@"imger_dedails"][@"pic_content"];
            CGSize textSize = [_textView.text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 10, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
            CGFloat textHeight = textSize.height < 60 ? 60 : textSize.height;
            _textView.frame = CGRectMake(5, _imgH + 10, SCREENWIDTH -10, textHeight);
            [_scrollView setContentSize:CGSizeMake(SCREENWIDTH - 10,_imgH + 10 + textHeight)];
            NSNumber *num = responseObject[@"data"][@"iscollect"];
            NSInteger count = num.integerValue;
            if([BPUserModel shareModel].isLogin)
            {
                self.rightBtn.selected = count ? YES : NO;
            }else{
                self.rightBtn.selected = NO;
            }
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)setupRightBtn{
    UIButton *attentionBtn = [UIButton new];
    _rightBtn = attentionBtn;
    attentionBtn.frame = CGRectMake(0, 0, 25, 25);
    [attentionBtn setImage:[UIImage imageNamed:@"未关注"] forState:UIControlStateNormal];
    [attentionBtn setImage:[UIImage imageNamed:@"关注"] forState:UIControlStateSelected];
    //    attentionBtn.selected = _isAttention;
    [attentionBtn addTarget:self action:@selector(didClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:attentionBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)didClickRightBtn:(UIButton *)sender
{
    if(![BPUserModel shareModel].isLogin){
        XPBLoginViewController *loginVC = [XPBLoginViewController new];
        loginVC.popVC = self;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    if(sender.selected)
    {
        NSLog(@"%@",BaseUrl(ImageCancelAtt));
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":ImageCancelAtt,
                               @"paramData":@{@"pic_id" : _picID,
                                              @"user_id"   : [BPUserModel shareModel].uid,
                                              }
                               };
        [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(ImageCancelAtt) parameters:dict success:^(id responseObject) {
           
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                [MBProgressHUD showSuccess:@"取消收藏成功"];
                sender.selected = NO;
            }else{
                [MBProgressHUD showError:@"操作失败"];
            }
        } fail:^(NSError *error) {
            [MBProgressHUD showError:@"操作失败"];
        }];
        
    }else{
        NSLog(@"%@",BaseUrl(ImageAttention));
        NSDictionary *dict = @{
                               @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                               @"uri":ImageAttention,
                               @"paramData":@{@"pic_id" : _picID,
                                              @"user_id"   : [BPUserModel shareModel].uid,
                                              }
                               };
        [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(ImageAttention) parameters:dict success:^(id responseObject) {
            
            if([responseObject[@"code"] isEqualToString:@"0000"])
            {
                [MBProgressHUD showSuccess:@"收藏成功"];
                sender.selected = YES;
            }else{
                [MBProgressHUD showError:@"操作失败"];
            }
        } fail:^(NSError *error) {
            [MBProgressHUD showError:@"操作失败"];
        }];
    }
}

-(void)setupUI{
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    _scrollView = scrollView;
    
    if(![self.picDataStr isNotNil]){
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _imageView = imageView;
    [scrollView addSubview:imageView];
    [imageView sizeToFit];
    UIImage *image = nil;
    NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:self.picDataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    if(decodedImage != nil)
    {
        image = decodedImage;
        CGFloat imgH =  image.size.height / image.size.width *SCREENWIDTH;
        _imgH = imgH;
        imageView.frame = CGRectMake(0, 0, SCREENWIDTH, imgH);
        imageView.image = image;

    }
    
    _imgH = _imgH > 0? _imgH : SCREENHEIGHT;
    UITextView *textView = [UITextView new];
    [scrollView addSubview:textView];
    textView.text = _picContent;
    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 10, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    CGFloat textHeight = textSize.height < 60 ? 60 : textSize.height;
    textView.frame = CGRectMake(5, _imgH + 10, SCREENWIDTH -10, textHeight);
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor darkGrayColor];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 10;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.text= @"我在这里";
    _textView = textView;
    
    [scrollView setContentSize:CGSizeMake(SCREENWIDTH - 10, _imgH + 10 + textHeight)];
}





@end
