//
//  XPBRedBagViewController.m
//  XPSixHeLottery
//
//  Created by iMac on 2017/10/26.
//  Copyright © 2017年 eirc. All rights reserved.
//

#import "XPBRedBagViewController.h"

@interface XPBRedBagViewController ()

@end

@implementation XPBRedBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"每日红包";
    [self customBackBtn];
    
    UIImageView *imageView = [UIImageView new];
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    imageView.image = [UIImage imageNamed:@"领取红包活动背景"];
    
    if(_isGetRedPacket){
        [self setAlreadyGetRedPecketUI];
    }else{
        [self setupUI];
    }
}

-(void)setAlreadyGetRedPecketUI{
    [self initRedPacketWithMoney:nil];
}

-(void)setupUI{
    UIButton *getRedBagBtn = [UIButton new];
    [self.view addSubview:getRedBagBtn];
    [getRedBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(200);
    }];
    [getRedBagBtn addTarget:self action:@selector(didClickRedBagAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didClickRedBagAction:(UIButton *)sender{
    [SVProgressHUD showWithStatus:@"正在领取..."];
    NSLog(@"%@",BaseUrl(RedPacketAction));
    NSDictionary *dic = @{
                          @"token":@"4d2cbce9-4338-415e-8343-7c9e67dae7ef",
                          @"uri":RedPacketAction,
                          @"paramData":@{@"user_id":[BPUserModel shareModel].uid,
                                         }
                          };
    [[BPNetRequest getInstance] postJsonWithUrl:BaseUrl(RedPacketAction) parameters:dic success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if([responseObject[@"code"] isEqualToString:@"0000"]){
           [self initRedPacketWithMoney:[NSString stringWithFormat:@"%.2f元",[responseObject[@"data"] floatValue]]];
        }else{
            [MBProgressHUD showError:@"操作失败"];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:@"网络错误"];
    }];
}

-(void)initRedPacketWithMoney:(NSString *)money{
    UIImageView *markView = [UIImageView new];
    markView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    markView.alpha = 0;
    markView.image = [UIImage imageNamed:@"渐变背景"];
    [self.view addSubview:markView];
    
    UIView * redPacketView = [UIView new];
    [self.view addSubview:redPacketView];
    redPacketView.frame = CGRectMake(20, 30, SCREENWIDTH -40, SCREENHEIGHT - 60);
    UIImageView *redImageView = nil;
    if(_isGetRedPacket){
        UIImage *redPacketImage = [UIImage imageNamed:@"签到过了"];
        CGFloat imageH = (SCREENWIDTH - 40)/redPacketImage.size.width *redPacketImage.size.height;
        redImageView = [UIImageView new];
        redImageView.frame = CGRectMake(0, 0, SCREENWIDTH - 40, imageH);
        redImageView.image = redPacketImage;
        [redPacketView addSubview:redImageView];
        
    }else{
        UIImage *redPacketImage = [UIImage imageNamed:@"礼袋"];
        CGFloat imageH = (SCREENWIDTH - 40)/redPacketImage.size.width *redPacketImage.size.height;
        redImageView = [UIImageView new];
        redImageView.frame = CGRectMake(0, 0, SCREENWIDTH - 40, imageH);
        redImageView.image = redPacketImage;
        [redPacketView addSubview:redImageView];
        
        UILabel *moneyLabel = [UILabel new];
        [redPacketView addSubview:moneyLabel];
        CGFloat maxY = (350.0 - 64)/667 *(SCREENHEIGHT - 64);
        moneyLabel.frame = CGRectMake(20, maxY, SCREENWIDTH -80, 30);
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.text = money;
        moneyLabel.font = [UIFont systemFontOfSize:24];
        moneyLabel.textColor = [UIColor yellowColor];
  
    }
    
    UIButton * comfirtBtn = [UIButton new];
    [redPacketView addSubview:comfirtBtn];
    [comfirtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(redImageView.mas_bottom).mas_offset(20);
    }];
    [comfirtBtn setImage:[UIImage imageNamed:@"我知道了"] forState:UIControlStateNormal];
    [comfirtBtn addTarget:self action:@selector(didClickComfirnBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:1.0 animations:^{
        markView.alpha = 1.0;
    }];
    
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.3;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:1.0];
    pulse.toValue= [NSNumber numberWithFloat:1.2];
    [[redPacketView layer]addAnimation:pulse forKey:nil];
}

-(void)didClickComfirnBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
