//
//  UIFont+Dialog.m
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/5.
//

#import "UIFont+Dialog.h"

#import "DialogConfig.h"

@implementation UIFont (Dialog)

+ (UIFont *)dialog_normalFontWithFontSize:(CGFloat)fontSize {
    UIFont *font;
    if ([DialogConfig sharedInstance].font.normalFontName.length > 0) {
        font = [UIFont fontWithName:[DialogConfig sharedInstance].font.normalFontName size:fontSize];
    }
    return font ? font : [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)dialog_boldFontWithFontSize:(CGFloat)fontSize {
    UIFont *font;
    if ([DialogConfig sharedInstance].font.boldFontName.length > 0) {
        font = [UIFont fontWithName:[DialogConfig sharedInstance].font.boldFontName size:fontSize];
    }
    return font ? font : [UIFont boldSystemFontOfSize:fontSize];
}

@end
