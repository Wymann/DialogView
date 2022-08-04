//
//  Dialog+SpecialColors.m
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogModelEditor.h"

#import "Dialog+SpecialColors.h"


@implementation Dialog (SpecialColors)

/// 显示普通标题和副标题（颜色自定义）
+ (DialogView *)showDialogWithTitle:(NSString *)title
                         titleColor:(NSString *)titleColor
                           subtitle:(NSString *)subtitle
                      subtitleColor:(NSString *)subtitleColor
                            buttons:(NSArray<NSString *> *)buttons
                       buttonColors:(NSArray<NSString *> *)buttonColors
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithTitle:title
                                  titleColor:titleColor
                                    subtitle:subtitle
                               subtitleColor:subtitleColor
                                     buttons:buttons
                                buttonColors:buttonColors
                                 resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示普通标题和副标题（颜色自定义，副标题为富文本）
+ (DialogView *)showDialogWithTitle:(NSString *)title
                         titleColor:(NSString *)titleColor
                 attributedSubtitle:(NSAttributedString *)attributedSubtitle
                            buttons:(NSArray<NSString *> *)buttons
                       buttonColors:(NSArray<NSString *> *)buttonColors
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithTitle:title
                                  titleColor:titleColor
                          attributedSubtitle:attributedSubtitle
                                     buttons:buttons
                                buttonColors:buttonColors
                                 resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 普通标题和副标题（颜色自定义）
+ (DialogView *)dialogWithTitle:(NSString *)title
                     titleColor:(NSString *)titleColor
                       subtitle:(NSString *)subtitle
                  subtitleColor:(NSString *)subtitleColor
                        buttons:(NSArray<NSString *> *)buttons
                   buttonColors:(NSArray<NSString *> *)buttonColors
                    resultBlock:(DialogResultBlock)resultBlock {
    return [self dialogWithTitle:title
                      titleColor:titleColor
                        subtitle:subtitle
                   subtitleColor:subtitleColor
              attributedSubtitle:nil
                         buttons:buttons
                    buttonColors:buttonColors
                     resultBlock:resultBlock];
}

/// 普通标题和副标题（颜色自定义，副标题为富文本）
+ (DialogView *)dialogWithTitle:(NSString *)title
                     titleColor:(NSString *)titleColor
             attributedSubtitle:(NSAttributedString *)attributedSubtitle
                        buttons:(NSArray<NSString *> *)buttons
                   buttonColors:(NSArray<NSString *> *)buttonColors
                    resultBlock:(DialogResultBlock)resultBlock {
    return [self dialogWithTitle:title
                      titleColor:titleColor
                        subtitle:nil
                   subtitleColor:nil
              attributedSubtitle:attributedSubtitle
                         buttons:buttons
                    buttonColors:buttonColors
                     resultBlock:resultBlock];
}

#pragma mark - Private Methods

+ (DialogView *)dialogWithTitle:(NSString *)title
                     titleColor:(NSString *)titleColor
                       subtitle:(NSString *)subtitle
                  subtitleColor:(NSString *)subtitleColor
             attributedSubtitle:(NSAttributedString *)attributedSubtitle
                        buttons:(NSArray<NSString *> *)buttons
                   buttonColors:(NSArray<NSString *> *)buttonColors
                    resultBlock:(DialogResultBlock)resultBlock {
    NSMutableArray *array = [NSMutableArray array];
    if (title.length > 0) {
        TextDialogModel *textModel = [DialogModelEditor createTextDialogModelWithTitle:title titleColor:titleColor];
        [array addObject:textModel];
    }

    if (subtitle.length > 0) {
        TextDialogModel *textModel1 = [DialogModelEditor createTextDialogModelWithSubtitle:subtitle subtitleColor:subtitleColor];
        [array addObject:textModel1];
    } else if (attributedSubtitle.string.length > 0) {
        TextDialogModel *textModel1 = [DialogModelEditor createTextDialogModelWithAttributedSubtitle:attributedSubtitle subtitleColor:nil];
        [array addObject:textModel1];
    }

    [DialogModelEditor createModelMarginWithModels:array existTitle:title.length > 0];

    if (buttons.count > 0) {
        ButtonsDialogModel *buttonsModel = [DialogModelEditor createButtonsDialogModelWithButtons:buttons buttonColors:buttonColors];
        [array addObject:buttonsModel];
    }

    DialogView *view = [[DialogView alloc] initWithDialogModels:array
                                                      animation:[Dialog sharedInstance].animationType
                                                       position:DialogPositionMiddle
                                                        sideTap:YES
                                                         bounce:YES];
    view.resultBlock = resultBlock;

    return view;
}

@end
