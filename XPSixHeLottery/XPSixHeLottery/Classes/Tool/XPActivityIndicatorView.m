//
//  XPActivityIndicatorView.m
//  YYQG-iOS
//
//  Created by 金晓沛 on 4/7/17.
//  Copyright © 2017 YYQG. All rights reserved.
//

#import "XPActivityIndicatorView.h"

@interface XPActivityIndicatorView ()
@property(nonatomic, strong) UIImageView *loading;
@end

@implementation XPActivityIndicatorView

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _loading = [[UIImageView alloc] initWithImage:image];
        _loading.frame = CGRectMake(0, 0, _loading.image.size.width, _loading.image.size.height);
        [self addSubview:_loading];
        self.bounds = CGRectMake(0, 0, _loading.image.size.width, _loading.image.size.height);
    }
    return self;
}

- (void)startAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.8;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 99999;
    
    [_loading.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation {
    [_loading.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
