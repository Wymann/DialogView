//
//  Dialog+Input.m
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogModelEditor.h"

#import "Dialog+Input.h"


@implementation Dialog (Input)

/// 显示普通标题、副标题和单行输入框(UITextField)
+ (DialogView *)showTextFieldDialogWithTitle:(NSString *)title
                                    subtitle:(NSString *)subtitle
                                   inputText:(NSString *)inputText
                                 placeHolder:(NSString *)placeHolder
                                keyboardType:(UIKeyboardType)keyboardType
                                     buttons:(NSArray<NSString *> *)buttons
                                 resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self textFieldDialogWithTitle:title subtitle:subtitle inputText:inputText placeHolder:placeHolder keyboardType:keyboardType
                                              buttons:buttons
                                          resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示普通标题、副标题和多行输入框(UITextView)
+ (DialogView *)showTextViewDialogWithTitle:(NSString *)title
                                   subtitle:(NSString *)subtitle
                                  inputText:(NSString *)inputText
                                placeHolder:(NSString *)placeHolder
                               keyboardType:(UIKeyboardType)keyboardType
                                    buttons:(NSArray<NSString *> *)buttons
                              maxTextLength:(NSInteger)maxTextLength
                                resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self textViewDialogWithTitle:title subtitle:subtitle inputText:inputText placeHolder:placeHolder keyboardType:keyboardType
                                             buttons:buttons
                                       maxTextLength:maxTextLength
                                         resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 普通标题、副标题和单行输入框(UITextField)
+ (DialogView *)textFieldDialogWithTitle:(NSString *)title
                                subtitle:(NSString *)subtitle
                               inputText:(NSString *)inputText
                             placeHolder:(NSString *)placeHolder
                            keyboardType:(UIKeyboardType)keyboardType
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

    TextFieldDialogModel *model = [DialogModelEditor createTextFieldDialogModelWithInputText:inputText placeHolder:placeHolder keyboardType:keyboardType];
    [array addObject:model];

    [DialogModelEditor createModelMarginWithModels:array existTitle:title.length > 0];

    if (buttons.count > 0) {
        ButtonsDialogModel *buttonsModel = [DialogModelEditor createButtonsDialogModelWithButtons:buttons buttonColors:nil];
        [array addObject:buttonsModel];
    }

    DialogView *view = [[DialogView alloc] initWithDialogModels:array animation:[Dialog sharedInstance].animationType position:DialogPositionMiddle sideTap:YES
                                                         bounce:YES];
    view.resultBlock = resultBlock;

    return view;
}

/// 普通标题、副标题和多行输入框(UITextView)
+ (DialogView *)textViewDialogWithTitle:(NSString *)title
                               subtitle:(NSString *)subtitle
                              inputText:(NSString *)inputText
                            placeHolder:(NSString *)placeHolder
                           keyboardType:(UIKeyboardType)keyboardType
                                buttons:(NSArray<NSString *> *)buttons
                          maxTextLength:(NSInteger)maxTextLength
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

    TextViewDialogModel *model = [DialogModelEditor createTextViewDialogModelWithInputText:inputText placeHolder:placeHolder keyboardType:keyboardType
                                                                             maxTextLength:maxTextLength];
    [array addObject:model];

    [DialogModelEditor createModelMarginWithModels:array existTitle:title.length > 0];

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
