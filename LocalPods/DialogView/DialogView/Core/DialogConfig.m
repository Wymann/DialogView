//
//  DialogConfig.m
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import "DialogConfig.h"

@implementation DialogConfig

#pragma mark - 单例
+ (instancetype)sharedInstance {
    static DialogConfig *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DialogConfig alloc] init];
        _instance.color = [[DialogColor alloc] init];
        _instance.font = [[DialogFont alloc] init];
        _instance.pattern = [[DialogPattern alloc] init];
        _instance.animation = ShowAnimationFade;
        _instance.position = DialogPositionMiddle;
        _instance.sideTap = YES;
        _instance.bounce = YES;
    });
    return _instance;
}

#pragma mark - Setter Methods

- (void)setColor:(DialogColor *)color {
    if (color) {
        _color = color;
    }
}

- (void)setFont:(DialogFont *)font {
    if (font) {
        _font = font;
    }
}

- (void)setPattern:(DialogPattern *)pattern {
    if (pattern) {
        _pattern = pattern;
    }
}

@end
