//
//  LCMarqueView.m
//  LotteryClient
//
//  Created by Dick on 2017/7/10.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "LCMarqueView.h"

@interface LCMarqueView ()

@property (nonatomic, strong) UIImageView *hornView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation LCMarqueView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 25)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .4;
    [self addSubview:bgView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH, 5, SCREENWIDTH - 25, 20)];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.numberOfLines = 1;
    _textLabel.textColor = [UIColor whiteColor];
    [self addSubview:_textLabel];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = .7;
    [self addSubview:coverView];
    
    _hornView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 20, 20)];
    _hornView.image = [UIImage imageNamed:@"ic_action_speaker"];
    [self addSubview:_hornView];
}

- (void)setRunString:(NSString *)runString {
    _runString = runString;
    _textLabel.text = runString;
    [_textLabel sizeToFit];
    [self startAnimation];
}

- (void)startAnimation {
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    moveAnimation.values   = @[@0, @( - _textLabel.frame.size.width - SCREENWIDTH - 25)];
    moveAnimation.keyTimes = @[@0, @1.0];
    moveAnimation.duration = 50;
    moveAnimation.repeatCount = HUGE_VALF;
    [self.textLabel.layer addAnimation:moveAnimation forKey:@"move"];
}

- (void)stopAnimation {
    [self.textLabel.layer removeAnimationForKey:@"move"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
