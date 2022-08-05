//
//  ButtonsDialogElement.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "ButtonsDialogElement.h"

#import "UIFont+Dialog.h"

#define DefaultTextColor @"#000000"          // 默认文本颜色
#define LineColor @"#DDDDDD"                 // 默认线条颜色
static const CGFloat DefaultFontSize = 15.0; // 默认字体大小
static const CGFloat ButtonHeight = 56.0;
static const CGFloat LineHeight = 0.5;
static const NSInteger basicButtonTag = 777;


@interface ButtonsDialogElement ()


@end


@implementation ButtonsDialogElement

#pragma mark - Setter Methods
- (void)setModel:(BasicDialogModel *)model {
    [super setModel:model];

    ButtonsDialogModel *buttonsModel = (ButtonsDialogModel *)self.model;
    switch (buttonsModel.layoutType) {
        case DialogButtonsLayoutHorizontal: {
            [self layoutHorizontalButtons];
        } break;
        case DialogButtonsLayoutVertical: {
            [self layoutVerticalButtons];
        } break;
        default: {
            [self layoutHorizontalButtons];
        } break;
    }
}

- (void)layoutVerticalButtons {
    ButtonsDialogModel *buttonsModel = (ButtonsDialogModel *)self.model;
    CGFloat fontSize = buttonsModel.fontSize > 0 ? buttonsModel.fontSize : DefaultFontSize;

    CGFloat buttonWidth = CGRectGetWidth(self.frame);
    for (NSInteger i = 0; i < buttonsModel.buttonTitles.count; i++) {
        NSString *textColor;
        if (buttonsModel.textColors.count > i) {
            textColor = buttonsModel.textColors[i];
        } else {
            textColor = DefaultTextColor;
        }

        NSString *title = buttonsModel.buttonTitles[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i * ButtonHeight, buttonWidth, ButtonHeight);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dialog_colorWithHexString:textColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dialog_colorWithHexString:textColor alpha:0.5] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor dialog_colorWithHexString:textColor alpha:0.3] forState:UIControlStateDisabled];
        button.titleLabel.font = buttonsModel.bold ? [UIFont dialog_boldFontWithFontSize:fontSize] : [UIFont dialog_normalFontWithFontSize:fontSize];
        [self addSubview:button];
        button.tag = basicButtonTag + i;

        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

        if (i != buttonsModel.buttonTitles.count - 1) {
            CALayer *bottomLine = [[CALayer alloc] init];
            bottomLine.frame = CGRectMake(0, floor(ButtonHeight - LineHeight), CGRectGetWidth(button.frame), LineHeight);
            bottomLine.backgroundColor = [UIColor dialog_colorWithHexString:LineColor].CGColor;
            [button.layer addSublayer:bottomLine];

            if (i == 0) {
                CALayer *topLine = [[CALayer alloc] init];
                topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), LineHeight);
                topLine.backgroundColor = [UIColor dialog_colorWithHexString:LineColor].CGColor;
                [button.layer addSublayer:topLine];
            }
        }
    }
}

- (void)layoutHorizontalButtons {
    ButtonsDialogModel *buttonsModel = (ButtonsDialogModel *)self.model;
    CGFloat fontSize = buttonsModel.fontSize > 0 ? buttonsModel.fontSize : DefaultFontSize;

    CGFloat buttonWidth = CGRectGetWidth(self.frame) / buttonsModel.buttonTitles.count;
    for (NSInteger i = 0; i < buttonsModel.buttonTitles.count; i++) {
        NSString *textColor;
        if (buttonsModel.textColors.count > i) {
            textColor = buttonsModel.textColors[i];
        } else {
            textColor = DefaultTextColor;
        }

        NSString *title = buttonsModel.buttonTitles[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(floor(i * buttonWidth), 0, buttonWidth, ButtonHeight);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dialog_colorWithHexString:textColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dialog_colorWithHexString:textColor alpha:0.5] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor dialog_colorWithHexString:textColor alpha:0.3] forState:UIControlStateDisabled];
        button.titleLabel.font = buttonsModel.bold ? [UIFont dialog_boldFontWithFontSize:fontSize] : [UIFont dialog_normalFontWithFontSize:fontSize];
        [self addSubview:button];
        button.tag = basicButtonTag + i;

        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

        if (i != buttonsModel.buttonTitles.count - 1) {
            CALayer *rightLine = [[CALayer alloc] init];
            rightLine.frame = CGRectMake(floor(buttonWidth - LineHeight), 0, LineHeight, ButtonHeight);
            rightLine.backgroundColor = [UIColor dialog_colorWithHexString:LineColor].CGColor;
            [button.layer addSublayer:rightLine];
        }
    }

    CALayer *topLine = [[CALayer alloc] init];
    topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), LineHeight);
    topLine.backgroundColor = [UIColor dialog_colorWithHexString:LineColor].CGColor;
    [self.layer addSublayer:topLine];
}

#pragma mark - Target Methods
- (void)clickButton:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender.tag - basicButtonTag);
    }
}

#pragma mark - Public Methods
/** 使某个按钮重新恢复点击事件 */
- (void)enableButtonAtIndex:(NSInteger)buttonIndex {
    UIButton *button = [self viewWithTag:buttonIndex + basicButtonTag];
    button.enabled = YES;
}

/**使某个按钮无法点击。*/
- (void)disabledButtonAtIndex:(NSInteger)buttonIndex {
    UIButton *button = [self viewWithTag:buttonIndex + basicButtonTag];
    button.enabled = NO;
}

#pragma mark - Element Height
+ (CGFloat)elementHeightWithModel:(BasicDialogModel *)model elementWidth:(CGFloat)elementWidth {
    ButtonsDialogModel *buttonsModel = (ButtonsDialogModel *)model;
    switch (buttonsModel.layoutType) {
        case DialogButtonsLayoutHorizontal: {
            return ButtonHeight;
        } break;
        case DialogButtonsLayoutVertical: {
            CGFloat height = buttonsModel.buttonTitles.count > 0 ? ButtonHeight * buttonsModel.buttonTitles.count : ButtonHeight;
            return height;
        } break;
        default: {
            return ButtonHeight;
        } break;
    }
}

@end
