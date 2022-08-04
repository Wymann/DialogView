//
//  Dialog+Input.h
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog.h"


@interface Dialog (Input)

#pragma mark - 自动显示弹框

/// 显示普通标题、副标题和单行输入框(UITextField)
/// @param title 主标题
/// @param subtitle 副标题
/// @param inputText 输入框初始文字
/// @param placeHolder 输入框占位文字
/// @param keyboardType 键盘类型
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showTextFieldDialogWithTitle:(NSString *)title
                                    subtitle:(NSString *)subtitle
                                   inputText:(NSString *)inputText
                                 placeHolder:(NSString *)placeHolder
                                keyboardType:(UIKeyboardType)keyboardType
                                     buttons:(NSArray<NSString *> *)buttons
                                 resultBlock:(DialogResultBlock)resultBlock;

/// 显示普通标题、副标题和多行输入框(UITextView)
/// @param title 主标题
/// @param subtitle 副标题
/// @param inputText 输入框初始文字
/// @param placeHolder 输入框占位文字
/// @param buttons 按钮标题
/// @param maxTextLength 允许输入的最大数字
/// @param resultBlock 结果回调
+ (DialogView *)showTextViewDialogWithTitle:(NSString *)title
                                   subtitle:(NSString *)subtitle
                                  inputText:(NSString *)inputText
                                placeHolder:(NSString *)placeHolder
                               keyboardType:(UIKeyboardType)keyboardType
                                    buttons:(NSArray<NSString *> *)buttons
                              maxTextLength:(NSInteger)maxTextLength
                                resultBlock:(DialogResultBlock)resultBlock;

#pragma mark - 生成弹框，不自动显示

/// 普通标题、副标题和单行输入框(UITextField)
/// @param title 主标题
/// @param subtitle 副标题
/// @param inputText 输入框初始文字
/// @param placeHolder 输入框占位文字
/// @param keyboardType 键盘类型
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)textFieldDialogWithTitle:(NSString *)title
                                subtitle:(NSString *)subtitle
                               inputText:(NSString *)inputText
                             placeHolder:(NSString *)placeHolder
                            keyboardType:(UIKeyboardType)keyboardType
                                 buttons:(NSArray<NSString *> *)buttons
                             resultBlock:(DialogResultBlock)resultBlock;

/// 普通标题、副标题和多行输入框(UITextView)
/// @param title 主标题
/// @param subtitle 副标题
/// @param inputText 输入框初始文字
/// @param placeHolder 输入框占位文字
/// @param buttons 按钮标题
/// @param maxTextLength 允许输入的最大数字
/// @param resultBlock 结果回调
+ (DialogView *)textViewDialogWithTitle:(NSString *)title
                               subtitle:(NSString *)subtitle
                              inputText:(NSString *)inputText
                            placeHolder:(NSString *)placeHolder
                           keyboardType:(UIKeyboardType)keyboardType
                                buttons:(NSArray<NSString *> *)buttons
                          maxTextLength:(NSInteger)maxTextLength
                            resultBlock:(DialogResultBlock)resultBlock;

@end
