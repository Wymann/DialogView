//
//  DialogModelEditor.m
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogView.h"

#import "DialogModelEditor.h"
#import "DialogTextTool.h"
#import "DialogConfig.h"

#import "UIFont+Dialog.h"
#import "UIColor+Dialog.h"

#define DIALOG_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height //手机屏幕高


@implementation DialogModelEditor

+ (TextDialogModel *)createTextDialogModelWithTitle:(NSString *)title titleColor:(NSString *)titleColor {
    TextDialogModel *textModel = [[TextDialogModel alloc] init];
    textModel.elementClassName = @"TextDialogElement";
    textModel.textContent = title;
    textModel.textColor = titleColor.length > 0 ? [UIColor dialog_colorWithHexString:titleColor] : [UIColor dialog_normalColor];
    textModel.fontSize = 18.0;
    textModel.bold = YES;

    /// 一行时候居中，超过两行的话居左显示
    CGFloat textWidth = [DialogView contentWidth] - [DialogConfig sharedInstance].pattern.leftGap - [DialogConfig sharedInstance].pattern.rightGap;
    NSInteger lines = [DialogTextTool linesOfText:title font:[UIFont dialog_normalFontWithFontSize:textModel.fontSize] width:textWidth];
    textModel.textAlignment = lines >= 2 ? NSTextAlignmentLeft : NSTextAlignmentCenter;

    return textModel;
}

+ (TextDialogModel *)createTextDialogModelWithTimeText:(NSString *)timeText {
    TextDialogModel *textModel = [[TextDialogModel alloc] init];
    textModel.elementClassName = @"TextDialogElement";
    textModel.textContent = timeText;
    textModel.textColor = [UIColor dialog_normalColorWithAlpha:0.6];
    textModel.fontSize = 16.0;
    textModel.textAlignment = NSTextAlignmentCenter;
    textModel.bold = NO;
    return textModel;
}

+ (TextDialogModel *)createTextDialogModelWithSubtitle:(NSString *)subtitle subtitleColor:(NSString *)subtitleColor {
    TextDialogModel *textModel = [[TextDialogModel alloc] init];
    textModel.elementClassName = @"TextDialogElement";
    textModel.textContent = subtitle;
    textModel.textColor = subtitleColor.length > 0 ? [UIColor dialog_colorWithHexString:subtitleColor] : [UIColor dialog_normalColor];
    textModel.fontSize = 16.0;
    textModel.bold = NO;

    /// 一行时候居中，超过两行的话居左显示
    CGFloat textWidth = [DialogView contentWidth] - [DialogConfig sharedInstance].pattern.leftGap - [DialogConfig sharedInstance].pattern.rightGap;
    NSInteger lines = [DialogTextTool linesOfText:subtitle font:[UIFont dialog_normalFontWithFontSize:textModel.fontSize] width:textWidth];
    textModel.textAlignment = lines >= 2 ? NSTextAlignmentLeft : NSTextAlignmentCenter;

    return textModel;
}

+ (TextDialogModel *)createTextDialogModelWithSubtitle:(NSString *)subtitle fontSize:(CGFloat)fontSize subtitleColor:(NSString *)subtitleColor {
    TextDialogModel *textModel = [[TextDialogModel alloc] init];
    textModel.elementClassName = @"TextDialogElement";
    textModel.textContent = subtitle;
    textModel.textColor = subtitleColor.length > 0 ? [UIColor dialog_colorWithHexString:subtitleColor] : [UIColor dialog_normalColor];
    textModel.fontSize = fontSize;
    textModel.bold = NO;

    /// 一行时候居中，超过两行的话居左显示
    CGFloat textWidth = [DialogView contentWidth] - [DialogConfig sharedInstance].pattern.leftGap - [DialogConfig sharedInstance].pattern.rightGap;
    NSInteger lines = [DialogTextTool linesOfText:subtitle font:[UIFont dialog_normalFontWithFontSize:textModel.fontSize] width:textWidth];
    textModel.textAlignment = lines >= 2 ? NSTextAlignmentLeft : NSTextAlignmentCenter;

    return textModel;
}

+ (TextDialogModel *)createTextDialogModelWithAttributedSubtitle:(NSAttributedString *)attributedSubtitle subtitleColor:(NSString *)subtitleColor {
    TextDialogModel *textModel = [[TextDialogModel alloc] init];
    textModel.elementClassName = @"TextDialogElement";
    textModel.attributedTextContent = attributedSubtitle;
    textModel.maxHeight = DIALOG_SCREEN_HEIGHT * 0.5;
    textModel.scrollable = YES;

    return textModel;
}

+ (ButtonsDialogModel *)createButtonsDialogModelWithButtons:(NSArray<NSString *> *)buttons buttonColors:(NSArray<NSString *> *)buttonColors {
    return [self createButtonsDialogModelWithButtons:buttons
                                        buttonColors:buttonColors
                                   buttonsLayoutType:DialogButtonsLayoutHorizontal];
}

+ (ButtonsDialogModel *)createButtonsDialogModelWithButtons:(NSArray<NSString *> *)buttons
                                               buttonColors:(NSArray<NSString *> *)buttonColors
                                          buttonsLayoutType:(DialogButtonsLayoutType)buttonsLayoutType {
    ButtonsDialogModel *buttonsModel = [[ButtonsDialogModel alloc] init];
    buttonsModel.elementClassName = @"ButtonsDialogElement";
    buttonsModel.buttonTitles = buttons;
    buttonsModel.fontSize = 16.0;
    buttonsModel.layoutType = buttonsLayoutType;
    if (buttonColors) {
        buttonsModel.textColors = buttonColors;
    } else if (buttons.count > 0) {
        NSMutableArray *colors = [NSMutableArray array];
        for (NSInteger i = 0; i < buttons.count; i++) {
            if (buttonsLayoutType == DialogButtonsLayoutVertical) {
                if (i == 0) {
                    [colors addObject:[DialogConfig sharedInstance].color.hintColor];
                } else {
                    [colors addObject:[DialogConfig sharedInstance].color.commonColor];
                }
            } else {
                if (i == buttons.count - 1) {
                    [colors addObject:[DialogConfig sharedInstance].color.hintColor];
                } else {
                    [colors addObject:[DialogConfig sharedInstance].color.commonColor];
                }
            }
        }
        buttonsModel.textColors = [colors copy];
    }
    return buttonsModel;
}

+ (TextFieldDialogModel *)createTextFieldDialogModelWithInputText:(NSString *)inputText
                                                      placeHolder:(NSString *)placeHolder
                                                     keyboardType:(UIKeyboardType)keyboardType {
    TextFieldDialogModel *model = [[TextFieldDialogModel alloc] init];
    model.elementClassName = @"TextFieldDialogElement";
    model.textContent = inputText;
    model.placeHolderContent = placeHolder;
    model.textColor = [UIColor dialog_normalColor];
    model.keyboardType = keyboardType;
    model.tintColor = [UIColor dialog_hintColor];
    return model;
}

+ (TextViewDialogModel *)createTextViewDialogModelWithInputText:(NSString *)inputText
                                                    placeHolder:(NSString *)placeHolder
                                                   keyboardType:(UIKeyboardType)keyboardType
                                                  maxTextLength:(NSInteger)maxTextLength {
    TextViewDialogModel *model = [[TextViewDialogModel alloc] init];
    model.elementClassName = @"TextViewDialogElement";
    model.textContent = inputText;
    model.placeHolderContent = placeHolder;
    model.textColor = [UIColor dialog_normalColor];
    model.keyboardType = keyboardType;
    model.tintColor = [UIColor dialog_hintColor];
    model.maxTextLength = maxTextLength;
    return model;
}

+ (ImageDialogModel *)createImageDialogModelWithImage:(UIImage *)image
                                            imageSize:(CGSize)imageSize
                                        imageFitWidth:(BOOL)imageFitWidth {
    ImageDialogModel *model = [[ImageDialogModel alloc] init];
    model.elementClassName = @"ImageDialogElement";
    model.image = image;
    model.imageWidth = imageSize.width;
    model.imageHeight = imageSize.height;
    model.imageFitWidth = imageFitWidth;

    return model;
}

+ (ImageDialogModel *)createImageDialogModelWithImageUrl:(NSString *)imageUrl
                                             placeholder:(UIImage *)placeholder
                                              errorImage:(UIImage *)errorImage
                                               imageSize:(CGSize)imageSize
                                           imageFitWidth:(BOOL)imageFitWidth {
    ImageDialogModel *model = [[ImageDialogModel alloc] init];
    model.placeholder = placeholder;
    model.elementClassName = @"ImageDialogElement";
    model.imgUrl = imageUrl;
    model.imageWidth = imageSize.width;
    model.imageHeight = imageSize.height;
    model.imageFitWidth = imageFitWidth;
    model.errorImage = errorImage;

    if (imageUrl.length > 0) {
        model.contentMode = UIViewContentModeScaleAspectFit;
        model.imgBackColor = @"#2B2E2F";
    }

    return model;
}

+ (SelectorDialogModel *)createSelectorDialogModelWithSelectorDialogItems:(NSArray<SelectorDialogItem *> *)items
                                                             maxSelectNum:(NSInteger)maxSelectNum
                                                        resultFromItemTap:(BOOL)resultFromItemTap {
    SelectorDialogModel *model = [[SelectorDialogModel alloc] init];
    model.elementClassName = @"SelectorDialogElement";
    model.items = items;

    SelectorPreference *preference = [[SelectorPreference alloc] init];
    preference.maxSelectNum = maxSelectNum;
    preference.resultFromItemTap = resultFromItemTap;

    model.preference = preference;

    return model;
}

+ (void)createModelMarginWithModels:(NSArray<BasicDialogModel *> *)models existTitle:(BOOL)existTitle {
    // 统一设置 element margin
    for (NSInteger i = 0; i < models.count; i++) {
        BasicDialogModel *model = models[i];
        CGFloat top;
        CGFloat bottom;
        CGFloat TopGap = existTitle ? [DialogConfig sharedInstance].pattern.topGapWithTile : [DialogConfig sharedInstance].pattern.topGapWithoutTile;
        top = (i == 0) ? TopGap : 0;
        if ([model isKindOfClass:[TextFieldDialogModel class]] || [model isKindOfClass:[TextViewDialogModel class]]) {
            bottom = 0;
        } else {
            bottom = (i == models.count - 1) ? [DialogConfig sharedInstance].pattern.bottomGap : [DialogConfig sharedInstance].pattern.verticalGap;
        }
        model.margin = UIEdgeInsetsMake(top, [DialogConfig sharedInstance].pattern.leftGap, bottom, [DialogConfig sharedInstance].pattern.rightGap);
    }
}

@end
