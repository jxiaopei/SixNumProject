//
//  XPActivityIndicatorView.h
//  YYQG-iOS
//
//  Created by 金晓沛 on 4/7/17.
//  Copyright © 2017 YYQG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPActivityIndicatorView : UIView

- (instancetype)initWithImage:(UIImage *)image;
- (void)startAnimation;
- (void)stopAnimation;

@end
