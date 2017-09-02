//
//
//  UIColor+IDPExtension.h
//  IDP
//
//  Created by JDB on 13-3-6.
//  Copyright (c) 2012年 JDB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MDFExtension)
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 rgbHex;

- (NSString *)mdf_colorSpaceString;

- (NSArray *)mdf_arrayFromRGBAComponents;

- (BOOL)mdf_red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;

- (UIColor *)mdf_colorByLuminanceMapping;

- (UIColor *)mdf_colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)mdf_colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)mdf_colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)mdf_colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)mdf_colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)mdf_colorByAdding:(CGFloat)f;
- (UIColor *)mdf_colorByLighteningTo:(CGFloat)f;
- (UIColor *)mdf_colorByDarkeningTo:(CGFloat)f;

- (UIColor *)mdf_colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)mdf_colorByAddingColor:(UIColor *)color;
- (UIColor *)mdf_colorByLighteningToColor:(UIColor *)color;
- (UIColor *)mdf_colorByDarkeningToColor:(UIColor *)color;

- (NSString *)mdf_stringFromColor;
- (NSString *)mdf_hexStringFromColor;

+ (UIColor *)mdf_randomColor;
+ (UIColor *)mdf_colorWithRGBHex:(UInt32)hex;
//+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha;
//+ (UIColor *)colourWithHexString:(NSString *)stringToConvert;
//+ (UIColor *)colourWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

+ (UIColor *)mdf_colourWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha;
+ (UIColor *)mdf_colourWithHexString:(NSString *)stringToConvert;
+ (UIColor *)mdf_colourWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;
@end
