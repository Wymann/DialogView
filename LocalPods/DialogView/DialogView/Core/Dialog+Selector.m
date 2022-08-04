//
//  Dialog+Selector.m
//  TCLPlus
//
//  Created by OwenChen on 2021/1/7.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogModelEditor.h"

#import "Dialog+Selector.h"


@implementation Dialog (Selector)

#pragma mark - 自动显示弹框

/// 显示选择器弹框
+ (DialogView *)showSelectorDialogWithTitle:(NSString *)title
                                   subtitle:(NSString *)subtitle
                        selectorDialogItems:(NSArray<SelectorDialogItem *> *)items
                               maxSelectNum:(NSInteger)maxSelectNum
                          resultFromItemTap:(BOOL)resultFromItemTap
                                    buttons:(NSArray<NSString *> *)buttons
                                resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [Dialog selectorDialogWithTitle:title subtitle:subtitle selectorDialogItems:items maxSelectNum:maxSelectNum
                                     resultFromItemTap:resultFromItemTap
                                               buttons:buttons
                                           resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

#pragma mark - 生成弹框，不自动显示

/// 选择器弹框
+ (DialogView *)selectorDialogWithTitle:(NSString *)title
                               subtitle:(NSString *)subtitle
                    selectorDialogItems:(NSArray<SelectorDialogItem *> *)items
                           maxSelectNum:(NSInteger)maxSelectNum
                      resultFromItemTap:(BOOL)resultFromItemTap
                                buttons:(NSArray<NSString *> *)buttons
                            resultBlock:(DialogResultBlock)resultBlock {
    NSMutableArray *array = [NSMutableArray array];
    if (title.length > 0) {
        TextDialogModel *textModel = [DialogModelEditor createTextDialogModelWithTitle:title titleColor:nil];
        [array addObject:textModel];
    }

    if (subtitle.length > 0) {
        TextDialogModel *textModel1 = [DialogModelEditor createTextDialogModelWithSubtitle:subtitle subtitleColor:nil];
        [array addObject:textModel1];
    }

    [DialogModelEditor createModelMarginWithModels:array existTitle:title.length > 0];

    if (items.count > 0) {
        SelectorDialogModel *model = [DialogModelEditor createSelectorDialogModelWithSelectorDialogItems:items maxSelectNum:maxSelectNum
                                                                                       resultFromItemTap:resultFromItemTap];
        [array addObject:model];
    }

    if (buttons.count > 0) {
        ButtonsDialogModel *buttonsModel = [DialogModelEditor createButtonsDialogModelWithButtons:buttons buttonColors:nil];
        [array addObject:buttonsModel];
    }

    DialogView *view = [[DialogView alloc] initWithDialogModels:array animation:[Dialog sharedInstance].animationType position:DialogPositionMiddle sideTap:YES
                                                         bounce:YES];
    view.resultBlock = resultBlock;

    return view;
}

@end
