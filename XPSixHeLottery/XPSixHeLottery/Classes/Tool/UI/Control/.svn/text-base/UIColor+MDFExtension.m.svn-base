//
//
//  UIColor+IDPExtension.m
//  IDP
//
//  Created by JDB on 13-3-6.
//  Copyright (c) 2012年 JDB. All rights reserved.
//

#import "UIColor+MDFExtension.h"

@implementation UIColor (MDFExtension)
- (CGColorSpaceModel)colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)mdf_colorSpaceString {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelUnknown:
			return @"kCGColorSpaceModelUnknown";
		case kCGColorSpaceModelMonochrome:
			return @"kCGColorSpaceModelMonochrome";
		case kCGColorSpaceModelRGB:
			return @"kCGColorSpaceModelRGB";
		case kCGColorSpaceModelCMYK:
			return @"kCGColorSpaceModelCMYK";
		case kCGColorSpaceModelLab:
			return @"kCGColorSpaceModelLab";
		case kCGColorSpaceModelDeviceN:
			return @"kCGColorSpaceModelDeviceN";
		case kCGColorSpaceModelIndexed:
			return @"kCGColorSpaceModelIndexed";
		case kCGColorSpaceModelPattern:
			return @"kCGColorSpaceModelPattern";
		default:
			return @"Not a valid color space";
	}
}

- (BOOL)canProvideRGBComponents {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
		case kCGColorSpaceModelMonochrome:
			return YES;
		default:
			return NO;
	}
}

- (NSArray *)mdf_arrayFromRGBAComponents {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -arrayFromRGBAComponents");
    
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [NSArray arrayWithObjects:
			[NSNumber numberWithFloat:r],
			[NSNumber numberWithFloat:g],
			[NSNumber numberWithFloat:b],
			[NSNumber numberWithFloat:a],
			nil];
}

- (BOOL)mdf_red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	
	CGFloat r,g,b,a;
	
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default:	// We don't know how to handle this model
			return NO;
	}
	
	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;
	
	return YES;
}

- (CGFloat)red {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat)blue {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat)white {
	NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}

- (UInt32)rgbHex {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbHex");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return 0;
	
	r = MIN(MAX(self.red, 0.0f), 1.0f);
	g = MIN(MAX(self.green, 0.0f), 1.0f);
	b = MIN(MAX(self.blue, 0.0f), 1.0f);
	
	return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)));
}

#pragma mark Arithmetic operations

- (UIColor *)mdf_colorByLuminanceMapping {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
	
	// http://en.wikipedia.org/wiki/Luma_(video)
	// Y = 0.2126 R + 0.7152 G + 0.0722 B
	return [UIColor colorWithWhite:r*0.2126f + g*0.7152f + b*0.0722f
							 alpha:a];
	
}

- (UIColor *)mdf_colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [UIColor colorWithRed:MAX(0.0, MIN(1.0, r * red))
						   green:MAX(0.0, MIN(1.0, g * green))
							blue:MAX(0.0, MIN(1.0, b * blue))
						   alpha:MAX(0.0, MIN(1.0, a * alpha))];
}

- (UIColor *)mdf_colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [UIColor colorWithRed:MAX(0.0, MIN(1.0, r + red))
						   green:MAX(0.0, MIN(1.0, g + green))
							blue:MAX(0.0, MIN(1.0, b + blue))
						   alpha:MAX(0.0, MIN(1.0, a + alpha))];
}

- (UIColor *)mdf_colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [UIColor colorWithRed:MAX(r, red)
						   green:MAX(g, green)
							blue:MAX(b, blue)
						   alpha:MAX(a, alpha)];
}

- (UIColor *)mdf_colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [UIColor colorWithRed:MIN(r, red)
						   green:MIN(g, green)
							blue:MIN(b, blue)
						   alpha:MIN(a, alpha)];
}

- (UIColor *)mdf_colorByMultiplyingBy:(CGFloat)f {
	return [self mdf_colorByMultiplyingByRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)mdf_colorByAdding:(CGFloat)f {
	return [self mdf_colorByMultiplyingByRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)mdf_colorByLighteningTo:(CGFloat)f {
	return [self mdf_colorByLighteningToRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)mdf_colorByDarkeningTo:(CGFloat)f {
	return [self mdf_colorByDarkeningToRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)mdf_colorByMultiplyingByColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self mdf_colorByMultiplyingByRed:r green:g blue:b alpha:1.0f];
}

- (UIColor *)mdf_colorByAddingColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self mdf_colorByAddingRed:r green:g blue:b alpha:0.0f];
}

- (UIColor *)mdf_colorByLighteningToColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [self mdf_colorByLighteningToRed:r green:g blue:b alpha:0.0f];
}

- (UIColor *)mdf_colorByDarkeningToColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmatic operations");
	
	CGFloat r,g,b,a;
	if (![self mdf_red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self mdf_colorByDarkeningToRed:r green:g blue:b alpha:1.0f];
}

#pragma mark String utilities

- (NSString *)mdf_stringFromColor {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -stringFromColor");
	NSString *result;
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
			result = [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
			break;
		case kCGColorSpaceModelMonochrome:
			result = [NSString stringWithFormat:@"{%0.3f, %0.3f}", self.white, self.alpha];
			break;
		default:
			result = nil;
	}
	return result;
}

- (NSString *)mdf_hexStringFromColor {
	return [NSString stringWithFormat:@"%0.6lX", (long)self.rgbHex];
}

#pragma mark Class methods

+ (UIColor *)mdf_randomColor {
	return [UIColor colorWithRed:(CGFloat)RAND_MAX / random()
						   green:(CGFloat)RAND_MAX / random()
							blue:(CGFloat)RAND_MAX / random()
						   alpha:1.0f];
}

+ (UIColor *)mdf_colorWithRGBHex:(UInt32)hex {
//	int r = (hex >> 16) & 0xFF;
//	int g = (hex >> 8) & 0xFF;
//	int b = (hex) & 0xFF;
//	
//	return [UIColor colorWithRed:r / 255.0f
//						   green:g / 255.0f
//							blue:b / 255.0f
//						   alpha:1.0f];
    return [UIColor colorWithRGBHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha{
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:alpha];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
//+ (UIColor *)colourWithHexString:(NSString *)stringToConvert {
////	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
////	unsigned hexNum;
////	if (![scanner scanHexInt:&hexNum]) return nil;
////	return [UIColor colorWithRGBHex:hexNum];
//    return [UIColor colourWithHexString:stringToConvert alpha:1.0f];
//}
//
//+ (UIColor *)colourWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha {
//	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
//	unsigned hexNum;
//	if (![scanner scanHexInt:&hexNum]) return nil;
//	return [UIColor colorWithRGBHex:hexNum alpha:alpha];
//}
//
//
+ (UIColor *)mdf_colourWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)mdf_colourWithHexString:(NSString *)stringToConvert {
    //	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    //	unsigned hexNum;
    //	if (![scanner scanHexInt:&hexNum]) return nil;
    //	return [UIColor colorWithRGBHex:hexNum];
    return [UIColor mdf_colourWithHexString:stringToConvert alpha:1.0f];
}

+ (UIColor *)mdf_colourWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor mdf_colourWithRGBHex:hexNum alpha:alpha];
}



@end
