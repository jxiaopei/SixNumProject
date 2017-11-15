//
//  XPBPicDetailViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/9.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBPicDetailViewController.h"
#import "XPBBAndWPicModel.h"
#import "XPBLoginViewController.h"

@interface XPBPicDetailViewController ()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIImage *placeHolder;

@end

@implementation XPBPicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
      
            if([self.picDataStr isNotNil])
            {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:self.picDataStr] placeholderImage:_placeHolder options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    CGFloat imgH =  image.size.height / image.size.width *SCREENWIDTH;
                    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.right.mas_equalTo(0);
                        make.height.mas_equalTo(imgH);
                    }];
                    _imageView.image = image;
                    
                }];
            }

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
    if(![self.picDataStr isNotNil]){
        
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _imageView = imageView;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.picDataStr] placeholderImage:[UIImage imageNamed:@"占位图"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        CGFloat imgH =  image.size.height / image.size.width *SCREENWIDTH;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(imgH);
        }];
        imageView.image = image;
        _placeHolder = image;
    }];
    
    
    //缩放手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [imageView addGestureRecognizer:pinch];
    
    // 移动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [imageView addGestureRecognizer:pan];
    
//    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://gallery.kj1372.com:13961/gallerys/thumbs/15491/2/j114.jpg"] placeholderImage:image];

}

-(void)pinchView:(UIPinchGestureRecognizer *)gestureRecognizer{
  
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        _imageView.transform = CGAffineTransformScale(_imageView.transform, gestureRecognizer.scale, gestureRecognizer.scale);
        gestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:_imageView.superview];
        [_imageView setCenter:(CGPoint){_imageView.center.x + translation.x, _imageView.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:_imageView.superview];
    }
}




@end
