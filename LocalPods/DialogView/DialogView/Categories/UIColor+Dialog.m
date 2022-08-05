//
//  UIColor+Dialog.m
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import "UIColor+Dialog.h"

#import "DialogConfig.h"

@implementation UIColor (Dialog)

+ (UIColor *)dialog_colorWithHexString:(NSString *)hexString {
    return [UIColor dialog_colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)dialog_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


+ (UIColor *)dialog_normalColor {
    return [self dialog_normalColorWithAlpha:1.0];
}

+ (UIColor *)dialog_normalColorWithAlpha:(CGFloat)alpha {
    return [self dialog_colorWithHexString:[DialogConfig sharedInstance].color.commonColor alpha:alpha];
}

+ (UIColor *)dialog_hintColor {
    return [self dialog_colorWithHexString:[DialogConfig sharedInstance].color.hintColor];
}

@end
